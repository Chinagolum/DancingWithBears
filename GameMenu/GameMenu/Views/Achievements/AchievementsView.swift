// MARK: - Views/Trophy/TrophyView.swift
import SwiftUI

struct AchievementsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Achievements")
                        .font(.largeTitle)
                        .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

/*
#Preview {
 AchievementsView()
}
 */
