import SwiftUI

class ProgressManager: ObservableObject {
    @Published var experiencePoints: Int = 0
    @Published var completedMissions: Set<String> = [] // Almacena los títulos de las misiones completadas
    @Published var reports: [Report] = [] // Almacena los reportes generados
    @Published var missionPhotos: [MissionPhoto] = [] // Almacena las fotos tomadas en las misiones
    
    // Agrega puntos de experiencia y marca una misión como completada
    func completeMission(_ missionTitle: String) {
        if !completedMissions.contains(missionTitle) {
            experiencePoints += 15 // Cada misión otorga 15 puntos
            completedMissions.insert(missionTitle)
        }
    }
    
    // Agrega un nuevo reporte a la lista
    func addReport(_ report: Report) {
        reports.append(report)
    }
    
    // Agrega una nueva foto de misión
    func addMissionPhoto(_ photo: UIImage, missionTitle: String) {
        let missionPhoto = MissionPhoto(image: photo, missionTitle: missionTitle, date: Date())
        missionPhotos.append(missionPhoto)
    }
    
    // Calcula el progreso como un valor entre 0 y 1 (para la barra de progreso)
    var progress: Double {
        min(Double(experiencePoints) / 100.0, 1.0) // La barra se completa con 100 puntos
    }
    
    // Número de reportes acumulados
    var reportCount: Int {
        reports.count
    }
}

// Estructura para representar un reporte
struct Report: Identifiable {
    let id = UUID()
    let date: Date
    let name: String
    let situation: String
    let description: String
}

// Estructura para representar una foto tomada en una misión
struct MissionPhoto: Identifiable {
    let id = UUID()
    let image: UIImage
    let missionTitle: String
    let date: Date // Añadimos la fecha en que se tomó la foto
}
