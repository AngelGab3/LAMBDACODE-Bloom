import SwiftUI
import AVKit

struct TransitionScreenView: View {
    @State private var isActive: Bool = false // Estado para controlar la transición a ContentView
    @State private var player: AVPlayer? // Reproductor de video
    
    var body: some View {
        ZStack {
            // Fondo de color
            Color(red: 0.21, green: 0.51, blue: 0.1)
                .ignoresSafeArea()
            
            // Reproductor de video personalizado
            if let player = player {
                CustomVideoPlayer(player: player)
                    .frame(width: 700, height: 848)
                    .scaleEffect(0.5) // Mantenemos la misma escala que en SplashScreenView
                    .onAppear {
                        // Reproducir el video automáticamente
                        player.play()
                        
                        // Configurar un temporizador para transicionar después de 5 segundos
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            } else {
                // Mostrar un placeholder si el video no se carga
                Text("Cargando video de transición...")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 391, height: 848)
        .fullScreenCover(isPresented: $isActive) {
            // Transicionar a ContentView después de que termine el video o el temporizador
            ContentView()
                .environmentObject(ProgressManager())
        }
        .onAppear {
            // Cargar el video de transición desde los assets
            if let videoURL = Bundle.main.url(forResource: "transitionVideo", withExtension: "mp4") {
                player = AVPlayer(url: videoURL)
            }
        }
    }
}

struct TransitionScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TransitionScreenView()
    }
}
