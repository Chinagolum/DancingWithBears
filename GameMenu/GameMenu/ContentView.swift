//
//  ContentView.swift
//  GameMenu
//
//  Created by Chinagolum Adigwe on 12/28/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Segmented Control
                Picker("Inbox Type", selection: $selectedTab) {
                    Text("System").tag(0)
                    Text("Announcement").tag(1)
                    Text("Gifts").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                // Main Content Area
                ScrollView {
                    // Your content goes here
                }
                
                Divider()
                
                // Bottom Tab Bar
                HStack(spacing: 0) {
                    BottomTabButton(icon: "house.fill")
                    BottomTabButton(icon: "cart.fill")
                    BottomTabButton(icon: "trophy.fill")
                    BottomTabButton(icon: "message.fill")
                    BottomTabButton(icon: "envelope.fill")
                }
                .frame(height: 60)
                .background(Color(.systemBackground))
            }
            .navigationBarHidden(true)
        }
    }
}

struct BottomTabButton: View {
    let icon: String
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
        }
    }
}


#Preview {
    ContentView()
}
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 */


/*
 import SwiftUI
 
 struct ContentView: View {
 var body: some View {
 VStack {
 Image(systemName: "globe")
 .imageScale(.large)
 .foregroundStyle(.tint)
 Text("Hello, world!")
 }
 .padding()
 
 }
 }
 
 #Preview {
 ContentView()
 }
 */
