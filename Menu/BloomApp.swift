import SwiftUI

@main
struct BloomApp: App {
    @StateObject private var progressManager = ProgressManager()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(progressManager)
        }
    }
}
