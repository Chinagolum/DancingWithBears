//
//  ContentView.swift
//  DWB3
//
//  Created by abcd on 10/18/25.
//  Updated: button-triggered p1…p4 .dae playback
//

import SwiftUI
import SceneKit
import Combine

// MARK: - Public View
struct ContentView: View {
    @StateObject private var vm = BearAnimViewModel()

    var body: some View {
        VStack(spacing: 12) {
            DAESceneView(vm: vm)
                .ignoresSafeArea(edges: .top)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    // start after mount
                    DispatchQueue.main.async { vm.playSelected(loop: true) }
                }

            // Controls
            VStack(spacing: 10) {

                // --- Bottom Buttons: P1 / P2 / P3 / P4 ---
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

                // Play / Pause / Stop
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

                // Speed slider
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
    }
}

// MARK: - ViewModel
final class BearAnimViewModel: ObservableObject {
    // Map directly to your files in art.scnassets: p1.dae, p2.dae, p3.dae, p4.dae
    let clips = ["p1", "p2", "p3", "p4"]

    @Published var selectedClip: String = "p1"
    @Published var speed: Float = 1.0
    @Published var isPaused: Bool = false

    // Scene references
    fileprivate weak var scnView: SCNView?

    // Cache last camera transform so swapping scenes keeps viewpoint
    private var lastCameraTransform: SCNMatrix4?

    func playSelected(loop: Bool) {
        guard let view = scnView else { return }

        // Preserve camera look before swapping scene
        if let camNode = view.pointOfView {
            lastCameraTransform = camNode.transform
        }

        // 1) Load the chosen DAE as a scene
        let path = "art.scnassets/\(selectedClip).dae"
        guard let newScene = SCNScene(named: path) else {
            print("⚠️ Could not load \(path)")
            return
        }

        // 2) Ensure lighting & background
        newScene.background.contents = view.backgroundColor ?? UIColor.systemBackground

        // 3) Force all animations in the scene to loop and use our speed
        loopAndSpeedAllAnimations(in: newScene.rootNode, loop: loop, speed: speed)

        // 4) Swap the scene in the view
        view.scene = newScene
        view.isPlaying = true   // make sure animations advance

        // 5) Restore camera
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

        DispatchQueue.main.async { self.isPaused = false }
    }

    func pauseOrResume() {
        guard let view = scnView else { return }
        let newPaused = !(view.scene?.isPaused ?? false)
        view.scene?.isPaused = newPaused
        DispatchQueue.main.async { self.isPaused = newPaused }
    }

    func stop() {
        guard let view = scnView else { return }
        // Remove all animations recursively
        view.scene?.rootNode.enumerateChildNodes { node, _ in
            node.removeAllAnimations()
        }
        DispatchQueue.main.async { self.isPaused = false }
    }

    func applySpeed() {
        guard let root = scnView?.scene?.rootNode else { return }
        // Re-apply speed to every animation currently attached
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

    // Make every animation on every node loop & honor speed
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

        // Load a base scene (first part)
        view.scene = SCNScene(named: "art.scnassets/p1.dae") ?? SCNScene()
        view.isPlaying = true

        // Keep a reference so VM can swap scenes
        vm.scnView = view
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}

#Preview {
    ContentView()
}

