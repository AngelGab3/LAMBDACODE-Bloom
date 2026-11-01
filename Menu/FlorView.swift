import SwiftUI

struct FlorView: View {
    @EnvironmentObject private var progressManager: ProgressManager
    
    // Determina qué imagen mostrar según los puntos de experiencia
    private var flowerImage: String {
        switch progressManager.experiencePoints {
        case 0..<15:
            return "Flor1.1"
        case 15..<30:
            return "Flor1.2"
        case 30..<45:
            return "Flor1.3"
        case 45..<60:
            return "Flor1.4"
        default: // 60 o más puntos
            return "Flor1.5"
        }
    }
    
    var body: some View {
        VStack {
            Text("Tu Progreso")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("Puntos de Experiencia: \(progressManager.experiencePoints)/100")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
            
            // Mostrar la imagen de la flor según los puntos de experiencia
            Image(flowerImage)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300) // Ajusta el tamaño según tus necesidades
                .padding()
            
            // Mostrar misiones completadas
            VStack(alignment: .leading, spacing: 15) {
                Text("Misiones Completadas:")
                    .font(.headline)
                    .padding(.horizontal)
                
                if progressManager.completedMissions.isEmpty {
                    Text("Aún no has completado ninguna misión.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                } else {
                    ForEach(Array(progressManager.completedMissions), id: \.self) { mission in
                        Text("✅ \(mission)")
                            .font(.body)
                            .foregroundColor(.green)
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
            
            Spacer()
        }
        .navigationTitle("Progreso")
    }
}

struct FlorView_Previews: PreviewProvider {
    static var previews: some View {
        FlorView()
            .environmentObject(ProgressManager())
    }
}
