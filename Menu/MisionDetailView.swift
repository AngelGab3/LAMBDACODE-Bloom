import SwiftUI

struct MisionDetailView: View {
    let item: ContentView.Item
    @EnvironmentObject private var progressManager: ProgressManager
    @Environment(\.dismiss) private var dismiss // Para cerrar la vista
    @State private var isJoined: Bool = false // Estado para controlar si el usuario se ha unido a la misión
    @State private var shouldDismissToMainMenu: Bool = false // Estado para redirigir al menú principal
    
    var body: some View {
        VStack {
            // Imagen de la misión
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
            
            // Descripción
            if let description = item.description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            // Verificamos si la misión está completada
            if progressManager.completedMissions.contains(item.title) {
                Text("Misión Completada ✅")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
            } else if !isJoined {
                // Botón para unirse a la misión
                Button(action: {
                    isJoined = true // Cambia el estado para mostrar el NavigationLink
                }) {
                    Text("Unirme a esta Misión")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.21, green: 0.51, blue: 0.1))                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                }
            } else {
                // Navegación a la vista específica según la misión
                NavigationLink(
                    destination: destinationView(for: item.title),
                    isActive: Binding(
                        get: { !shouldDismissToMainMenu },
                        set: { newValue in
                            if !newValue {
                                shouldDismissToMainMenu = true
                            }
                        }
                    )
                ) {
                    Text("Ver Detalles de la Misión")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.21, green: 0.51, blue: 0.1))                       
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .onAppear {
            // Depuramos el valor de title al aparecer la vista
            print("Title recibido: '\(item.title)'")
        }
        .onChange(of: shouldDismissToMainMenu) { shouldDismiss in
            if shouldDismiss {
                dismiss() // Regresa al menú principal
            }
        }
    }
    
    // Función para determinar la vista de destino según el título de la misión
    @ViewBuilder
    private func destinationView(for title: String) -> some View {
        // Normalizamos el title para evitar problemas con espacios o mayúsculas
        let normalizedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        switch normalizedTitle {
        case "mision 1":
            DenunciarContaminacionView()
        case "mision 2":
            ReforestacionView()
        case "mision 3":
            MonitorearAguaView()
        default:
            Text("Vista no disponible: '\(title)'")
        }
    }
}

struct MisionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MisionDetailView(item: ContentView.Item(
            title: "agua reutilizada",
            imageName: "aguareutilizada",
            completedImageName: "aguareutilizada2",
            description: "AGUA REUTILIZADA ¡Salva el agua, riega la vida! Reusa agua que ibas a tirar para regar una planta. ¿Quieres más puntos? Toma una foto de la planta regada. ¡Menos desperdicio, más verde en el planeta! ",
            date: nil
        ))
        .environmentObject(ProgressManager())
    }
}
