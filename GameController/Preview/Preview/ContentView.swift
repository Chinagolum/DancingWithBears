//
//  ContentView.swift
//  Preview
//
//  Created by Chinagolum Adigwe on 12/22/25.
//

import SwiftUI
import GameController

struct ContentView: View {
    var body: some View {
        GameControllerView { pattern in
            print("Pattern completed: \(pattern)")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
