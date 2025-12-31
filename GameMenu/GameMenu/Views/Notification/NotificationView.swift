// MARK: - Views/Notification/NotificationView.swift
import SwiftUI

struct NotificationView: View {
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
                
                // Email List
                ScrollView {
                    VStack(spacing: 0) {
                        NotificationRow(isRead: false, showDivider: true)
                        NotificationRow(isRead: true, showDivider: true)
                        NotificationRow(isRead: true, showDivider: false)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        Spacer()
    }
}

/*
#Preview {
    NotificationView()
}
 */

