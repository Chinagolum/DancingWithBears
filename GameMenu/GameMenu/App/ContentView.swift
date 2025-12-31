import SwiftUI

struct ContentView: View {
    @State private var selectedBottomTab = 0 // Start on email tab
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content Area
            Group {
                switch selectedBottomTab {
                case 0:
                    HomeView()
                case 1:
                    ShopView()
                case 2:
                    AchievementsView()
                case 3:
                    ChatView()
                case 4:
                    NotificationView()
                default:
                    HomeView()
                }
            }
            
            Divider()
            
            // Bottom Tab Bar
            HStack(spacing: 0) {
                BottomTabButton(icon: "house.fill", isSelected: selectedBottomTab == 0) {
                    selectedBottomTab = 0
                }
                BottomTabButton(icon: "cart.fill", isSelected: selectedBottomTab == 1) {
                    selectedBottomTab = 1
                }
                BottomTabButton(icon: "trophy.fill", isSelected: selectedBottomTab == 2) {
                    selectedBottomTab = 2
                }
                BottomTabButton(icon: "message.fill", isSelected: selectedBottomTab == 3) {
                    selectedBottomTab = 3
                }
                BottomTabButton(icon: "envelope.fill", isSelected: selectedBottomTab == 4) {
                    selectedBottomTab = 4
                }
            }
            .frame(height: 60)
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    ContentView()
}
