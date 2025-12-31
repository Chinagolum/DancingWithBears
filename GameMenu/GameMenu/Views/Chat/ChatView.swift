// MARK: - Views/Messages/ChatView.swift
import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Chat")
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
    ChatView()
}
 */

