// MARK: - Views/Home/HomeView.swift
import SwiftUI
import GameEngine  // Import your game project


struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Home")
                        .font(.largeTitle)
                        .padding()
                    
                    NavigationLink(destination: GameEngine.GameEngineView()) {
                        Text("It's Party Time")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}


#Preview {
    HomeView()
}
 
