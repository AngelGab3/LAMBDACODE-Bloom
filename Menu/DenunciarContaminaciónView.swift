import SwiftUI

struct DenunciarContaminacionView: View {
    @EnvironmentObject private var progressManager: ProgressManager
    @Environment(\.dismiss) private var dismiss // Para cerrar la vista
    @State private var missionCompleted: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var capturedImage: UIImage?
    @State private var showIncredibleText: Bool = false // Estado para el texto "Increíble"
    @State private var showSavingsText: Bool = false // Estado para el texto de ahorro
    @State private var showMissionButton: Bool = false // Estado para el botón "Misión Terminada"
    
    var body: some View {
        VStack {
            Text("Agua reutilizada")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    // Botón para tomar una foto
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Tomar Foto")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.588, green: 0.404, blue: 0.294))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                    }
                    .sheet(isPresented: $showImagePicker, onDismiss: {
                        if let image = capturedImage {
                            progressManager.addMissionPhoto(image, missionTitle: "mision 1")
                            // Mostrar los elementos con animación en secuencia
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showIncredibleText = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showSavingsText = true
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showMissionButton = true
                                }
                            }
                        }
                    }) {
                        ImagePicker(image: $capturedImage)
                    }
                    
                    // Mostrar la foto tomada (opcional, para confirmación)
                    if let image = capturedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal)
                    }
                    
                    // Texto "Increíble" con animación
                    if showIncredibleText {
                        Text("Increíble")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .opacity(showIncredibleText ? 1 : 0)
                            .transition(.opacity.combined(with: .slide))
                    }
                    
                    // Texto de ahorro con animación
                    if showSavingsText {
                        Text("¡Gran trabajo!\n\nAl reusar agua para regar una planta, reduces el desperdicio de agua y haces una diferencia real.\n\nCada gota que salvas cuenta.\n\n¡Tu aporte está construyendo un futuro más verde!")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center) // Para que el texto se vea bien alineado
                            .padding(.horizontal)
                            .opacity(showSavingsText ? 1 : 0)
                            .transition(.opacity.combined(with: .slide))
                    }
                }
            }
            
            // Mostrar mensaje de confirmación o botón "Misión Terminada"
            if missionCompleted || progressManager.completedMissions.contains("mision 1") {
                Text("Misión Completada ✅")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
            } else if showMissionButton {
                Button(action: {
                    progressManager.completeMission("mision 1")
                    missionCompleted = true
                    dismiss() // Regresa a MisionDetailView, que a su vez regresará al menú principal
                }) {
                    Text("Misión Terminada")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.21, green: 0.51, blue: 0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                        .opacity(showMissionButton ? 1 : 0)
                        .transition(.opacity.combined(with: .slide))
                }
            }
            
            Spacer()
        }
    }
}

struct DenunciarContaminacionView_Previews: PreviewProvider {
    static var previews: some View {
        DenunciarContaminacionView()
            .environmentObject(ProgressManager())
    }
}
