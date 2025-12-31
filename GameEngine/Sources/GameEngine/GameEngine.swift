//
//  GameEngine.swift
//  GameEngine
//
//  Created by Chinagolum Adigwe on 12/31/25.
//

import Foundation
import SwiftUI
import SceneKit
import Combine
import GameController

// MARK: - Public View
public struct GameEngineView: View {
    public init() {}
    @StateObject private var vm = BearAnimViewModel()
    
    public var body: some View {
        ZStack {
            VStack(spacing: 12) {
                DAESceneView(vm: vm)
                    .ignoresSafeArea(edges: .top)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        vm.playSelected(loop: true)
                    }
                
                // Controls
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        ForEach(vm.clips, id: \.self) { clip in
                            Button {
                                vm.selectedClip = clip
                                vm.playSelected(loop: true)
                            } label: {
                                Text(clip.uppercased())
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(vm.selectedClip == clip ? .accentColor : .secondary)
                        }
                    }
                    
                    HStack(spacing: 12) {
                        Button { vm.playSelected(loop: true) } label: {
                            Label("Play", systemImage: "play.fill")
                        }
                        Button { vm.pauseOrResume() } label: {
                            Label(vm.isPaused ? "Resume" : "Pause",
                                  systemImage: vm.isPaused ? "playpause.fill" : "pause.fill")
                        }
                        Button(role: .destructive) { vm.stop() } label: {
                            Label("Stop", systemImage: "stop.fill")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Speed"); Spacer()
                            Text(String(format: "%.2fx", vm.speed)).monospacedDigit()
                        }
                        Slider(value: $vm.speed, in: 0.25...3.0, step: 0.05)
                    }
                    .onChange(of: vm.speed) { _ in vm.applySpeed() }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            
            GameControllerView { pattern in
                print("Pattern completed: \(pattern)")
            }
        }
    }
}

// MARK: - ViewModel
@MainActor
final class BearAnimViewModel: ObservableObject {
    let clips = ["p1", "p2", "p3", "p4"]

    @Published var selectedClip: String = "p1"
    @Published var speed: Float = 1.0
    @Published var isPaused: Bool = false

    fileprivate weak var scnView: SCNView?
    private var lastCameraTransform: SCNMatrix4?

    func playSelected(loop: Bool) {
        guard let view = scnView else { return }

        if let camNode = view.pointOfView {
            lastCameraTransform = camNode.transform
        }

        // Load from app bundle directly
        guard let newScene = SCNScene(named: "art.scnassets/\(selectedClip).dae") else {
            print("⚠️ Could not load \(selectedClip).dae from art.scnassets")
            return
        }

        newScene.background.contents = view.backgroundColor ?? UIColor.systemBackground
        loopAndSpeedAllAnimations(in: newScene.rootNode, loop: loop, speed: speed)

        view.scene = newScene
        view.isPlaying = true

        if let saved = lastCameraTransform {
            if let pov = view.pointOfView {
                pov.transform = saved
            } else {
                let camera = SCNCamera()
                let pov = SCNNode()
                pov.camera = camera
                pov.transform = saved
                newScene.rootNode.addChildNode(pov)
                view.pointOfView = pov
            }
        }

        isPaused = false
    }

    func pauseOrResume() {
        guard let view = scnView else { return }
        let newPaused = !(view.scene?.isPaused ?? false)
        view.scene?.isPaused = newPaused
        isPaused = newPaused
    }

    func stop() {
        guard let view = scnView else { return }
        view.scene?.rootNode.enumerateChildNodes { node, _ in
            node.removeAllAnimations()
        }
        isPaused = false
    }

    func applySpeed() {
        guard let root = scnView?.scene?.rootNode else { return }
        root.enumerateChildNodes { node, _ in
            for key in node.animationKeys {
                if let ca = node.animation(forKey: key) as? CAAnimation {
                    let copy = ca.copy() as! CAAnimation
                    copy.speed = speed
                    node.removeAnimation(forKey: key)
                    node.addAnimation(copy, forKey: key)
                }
            }
        }
    }

    private func loopAndSpeedAllAnimations(in root: SCNNode, loop: Bool, speed: Float) {
        root.enumerateChildNodes { node, _ in
            for key in node.animationKeys {
                if let ca = node.animation(forKey: key) as? CAAnimation {
                    let copy = ca.copy() as! CAAnimation
                    copy.repeatCount = loop ? .infinity : 0
                    copy.isRemovedOnCompletion = false
                    copy.fillMode = .forwards
                    copy.fadeInDuration = 0.12
                    copy.fadeOutDuration = 0.12
                    copy.speed = speed
                    node.removeAnimation(forKey: key)
                    node.addAnimation(copy, forKey: key)
                }
            }
        }
    }
}

// MARK: - SceneKit bridge
struct DAESceneView: UIViewRepresentable {
    @ObservedObject var vm: BearAnimViewModel

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.backgroundColor = .systemBackground
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = true

        if let scene = SCNScene(named: "art.scnassets/p1.dae") {
            view.scene = scene
        } else {
            print("⚠️ Could not load p1.dae from art.scnassets")
            view.scene = SCNScene()
        }

        view.isPlaying = true
        vm.scnView = view
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}

/*
#Preview {
    GameEngineView()
}
*/
