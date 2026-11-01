import SwiftUI
import AVKit

struct SplashScreenView: View {
    @State private var isActive: Bool = false // Estado para controlar la transición a TransitionScreenView
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
                    .scaleEffect(0.5) // Reducimos la escala del video para que el logo se vea más pequeño
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
                Text("Cargando video...")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 391, height: 848)
        .fullScreenCover(isPresented: $isActive) {
            // Transicionar a TransitionScreenView después de que termine el video o el temporizador
            TransitionScreenView()
                .environmentObject(ProgressManager())
        }
        .onAppear {
            // Cargar el video desde los assets
            if let videoURL = Bundle.main.url(forResource: "logo", withExtension: "mp4") {
                player = AVPlayer(url: videoURL)
            }
        }
    }
}

// Vista personalizada para el reproductor de video
struct CustomVideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false // Ocultar controles de reproducción
        controller.videoGravity = .resizeAspectFill // Ajustar para ocupar toda la pantalla
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // No se necesitan actualizaciones dinámicas para este caso
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
