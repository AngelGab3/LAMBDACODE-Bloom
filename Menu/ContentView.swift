import SwiftUI

struct ContentView: View {
    // Estructura para las secciones y los ítems
    struct Section {
        let title: String
        let items: [Item]
    }
    
    struct Item: Identifiable {
        let id = UUID()
        let title: String
        let imageName: String
        let completedImageName: String
        let description: String?
        let date: Date?
    }
    
    // Datos de las secciones
    let sections: [Section] = [
        Section(title: "", items: []),
        Section(title: "Misiones", items: [
            Item(title: "mision 1", imageName: "aguareutilizada", completedImageName: "aguareutilizada2", description: "¡Salva el agua, riega la vida! Reusa agua que ibas a tirar para regar una planta. ¿Quieres más puntos? Toma una foto de la planta regada. ¡Menos desperdicio, más verde en el planeta! ", date: nil),
            Item(title: "mision 2", imageName: "plansindesperdicio", completedImageName: "plansindesperdicio2", description: "¡Hagamos que el no desperdiciar sea un hábito! A nivel mundial, al día se desperdician más de 1000 millones de platos de comida.                 Escribe cómo evitarías tirar comida hoy.!", date: nil),
            Item(title: "mision 3", imageName: "plantaunfuturo", completedImageName: "plantaunfuturo2", description: "¡Sin plantas no tenemos vida! Cuida o riega una planta, toma una foto.¿Quieres más puntos? Escribe por qué las plantas ayudan al aire.¡Mientras más plantas existan, será más limpio el aire que respiras! ", date: nil)
        ]),
        Section(title: "Feed (Fotos)", items: []),
        Section(title: "¿Qué hacer si?", items: [
            Item(title: "Encuentras un Derrame de Petróleo", imageName: "petroleo", completedImageName: "", description: "Pasos a seguir si encuentras un derrame de petróleo en el agua.", date: nil),
            Item(title: "Ves Deforestación Ilegal", imageName: "deforestacion", completedImageName: "deforestation", description: "Cómo actuar si presencias deforestación ilegal en tu área.", date: nil),
            Item(title: "Hay un Incendio Forestal", imageName: "incendioforestal", completedImageName: "", description: "Qué hacer si te encuentras cerca de un incendio forestal.", date: nil)
        ]),
        Section(title: "Generación de Reportes", items: [])
    ]
    
    @EnvironmentObject private var progressManager: ProgressManager
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    VStack(alignment: .leading) {
                        Text("Progreso: \(progressManager.experiencePoints)/100 XP")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ProgressView(value: progressManager.progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                            .frame(height: 10)
                            .padding(.horizontal)
                    }
                    .padding(.top, 10)
                    
                    ForEach(sections.indices, id: \.self) { sectionIndex in
                        let section = sections[sectionIndex]
                        VStack(alignment: .leading) {
                            Text(section.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            if sectionIndex == 0 {
                                NavigationLink(destination: FlorView()) {
                                    Text("Ver Progreso")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color(red: 0.21, green: 0.51, blue: 0.1))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.horizontal)
                                }
                            } else if sectionIndex == 1 {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(section.items) { item in
                                            if progressManager.completedMissions.contains(item.title) {
                                                VStack {
                                                    Image(item.completedImageName)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 120, height: 120)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                    Text(item.title)
                                                        .font(.caption)
                                                        .multilineTextAlignment(.center)
                                                        .frame(width: 120)
                                                    Text("Completada ✅")
                                                        .font(.caption)
                                                        .foregroundColor(.green)
                                                }
                                            } else {
                                                NavigationLink(destination: MisionDetailView(item: item)) {
                                                    VStack {
                                                        Image(item.imageName)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 120, height: 120)
                                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                                        Text(item.title)
                                                            .font(.caption)
                                                            .multilineTextAlignment(.center)
                                                            .frame(width: 120)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            } else if sectionIndex == 2 {
                                VStack(spacing: 15) {
                                    if progressManager.missionPhotos.isEmpty {
                                        Text("Aún no has tomado fotos en las misiones.")
                                            .font(.body)
                                            .foregroundColor(.gray)
                                            .padding(.horizontal)
                                    } else {
                                        ForEach(progressManager.missionPhotos) { missionPhoto in
                                            VStack(alignment: .leading) {
                                                Image(uiImage: missionPhoto.image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(height: 200)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                Text(missionPhoto.missionTitle)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                Text("Foto tomada durante la misión")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                    .lineLimit(2)
                                                Text("Fecha: \(dateFormatter.string(from: missionPhoto.date))")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                                Button(action: {
                                                    shareImage(image: missionPhoto.image)
                                                }) {
                                                    HStack {
                                                        Image(systemName: "square.and.arrow.up")
                                                            .foregroundColor(.blue)
                                                        Text("Compartir")
                                                            .foregroundColor(.blue)
                                                    }
                                                }
                                                .padding(.top, 5)
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                }
                            } else if sectionIndex == 3 {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(section.items) { item in
                                            NavigationLink(destination: QueHacerDetailView(item: item)) {
                                                ZStack {
                                                    Image(item.imageName)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 200, height: 200)
                                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                                }
                                                .frame(width: 250)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            } else {
                                NavigationLink(destination: Reportes()) {
                                    Text("Generar un Reporte")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color(red: 0.21, green: 0.51, blue: 0.1))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Bloom")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ReportsListView()) {
                        ZStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.blue)
                            if progressManager.reportCount > 0 {
                                Text("\(progressManager.reportCount)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 10, y: -10)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func shareImage(imageName: String) {
        guard let image = UIImage(named: imageName) else {
            print("Error: No se pudo cargar la imagen predefinida con nombre \(imageName)")
            return
        }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            activityController.popoverPresentationController?.sourceView = rootViewController.view
            rootViewController.present(activityController, animated: true, completion: nil)
        } else {
            print("Error: No se pudo encontrar el controlador de vista raíz para presentar UIActivityViewController")
        }
    }
    
    private func shareImage(image: UIImage) {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            activityController.popoverPresentationController?.sourceView = rootViewController.view
            rootViewController.present(activityController, animated: true, completion: nil)
        } else {
            print("Error: No se pudo encontrar el controlador de vista raíz para presentar UIActivityViewController")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ProgressManager())
    }
}
