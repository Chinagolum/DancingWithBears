// MARK: - Views/Shop/ShopView.swift
import SwiftUI

struct ShopView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Shop")
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
    MessageView()
}
 */
