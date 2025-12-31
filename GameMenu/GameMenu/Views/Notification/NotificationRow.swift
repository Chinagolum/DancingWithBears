// MARK: - Views/Notification/NotificationRow.swift
import SwiftUI

struct NotificationRow: View {
    let isRead: Bool
    let showDivider: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Email Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    
                    if !isRead {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .offset(x: 8, y: -8)
                    }
                }
                
                // Email Content
                VStack(alignment: .leading, spacing: 4) {
                    if isRead {
                        Text("Regular = read")
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                    } else {
                        Text("Bold = unread")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            
            if showDivider {
                Divider()
                    .padding(.leading, 82)
            }
        }
    }
}

/*
#Preview {
    MessageView()
}
 */
