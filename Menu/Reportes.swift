import SwiftUI
import PDFKit

struct Reportes: View {
    @EnvironmentObject private var progressManager: ProgressManager
    @State private var date = Date()
    @State private var name: String = ""
    @State private var situation: String = ""
    @State private var description: String = ""
    @State private var showSuccessMessage: Bool = false // Estado para mostrar mensaje de éxito
    
    // Determina si todos los campos están llenos
    private var isFormComplete: Bool {
        !name.isEmpty && !situation.isEmpty && !description.isEmpty
    }
    
    var body: some View {
        VStack {
            Text("Generar Reporte")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            // Formulario para los datos del reporte
            Form {
                Section(header: Text("Fecha")) {
                    DatePicker("Selecciona la fecha", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.compact)
                }
                
                Section(header: Text("Nombre")) {
                    TextField("Ingresa tu nombre", text: $name)
                        .textFieldStyle(.roundedBorder)
                }
                
                Section(header: Text("Situación")) {
                    TextField("Ingresa la situación", text: $situation)
                        .textFieldStyle(.roundedBorder)
                }
                
                Section(header: Text("Descripción de la Situación")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                
                if isFormComplete {
                    Section {
                        Button(action: {
                            // Crear el reporte y añadirlo a ProgressManager
                            let report = Report(date: date, name: name, situation: situation, description: description)
                            progressManager.addReport(report)
                            
                            // Generar y guardar el PDF
                            saveReportAsPDF(report: report)
                            
                            // Limpiar el formulario
                            name = ""
                            situation = ""
                            description = ""
                            date = Date()
                        }) {
                            Text("Terminar Reporte")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 0.21, green: 0.51, blue: 0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            
            // Mensaje de éxito
            if showSuccessMessage {
                Text("Reporte listo. Revisa tu lista de reportes en menu")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding()
                    .transition(.opacity)
            }
            
            Spacer()
        }
        .navigationTitle("Reportes")
    }
    
    // Función para generar y guardar el PDF en "Archivos"
    private func saveReportAsPDF(report: Report) {
        // Formatear la fecha para el contenido del PDF
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let formattedDate = dateFormatter.string(from: report.date)
        
        // Crear el contenido del PDF
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(x: 0, y: 0, width: 595.2, height: 841.8), nil) // Tamaño A4
        UIGraphicsBeginPDFPage()
        
        let context = UIGraphicsGetCurrentContext()!
        
        // Título
        let title = "Reporte de Situación"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ]
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        titleString.draw(at: CGPoint(x: 40, y: 40))
        
        // Contenido del reporte
        let content = """
        Fecha: \(formattedDate)
        Nombre: \(report.name)
        Situación: \(report.situation)
        Descripción: \(report.description)
        """
        let contentAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.black
        ]
        let contentString = NSAttributedString(string: content, attributes: contentAttributes)
        contentString.draw(in: CGRect(x: 40, y: 80, width: 515.2, height: 721.8))
        
        UIGraphicsEndPDFContext()
        
        // Guardar el PDF en el directorio de documentos
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "Reporte_\(report.situation)_\(UUID().uuidString).pdf" // Nombre único para evitar conflictos
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: fileURL)
            
            // Mover el archivo a "Archivos" usando UIDocumentInteractionController
            let documentController = UIDocumentInteractionController(url: fileURL)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                documentController.delegate = rootViewController as? UIDocumentInteractionControllerDelegate
                documentController.presentOptionsMenu(from: .zero, in: rootViewController.view, animated: true)
                
                // Mostrar mensaje de éxito
                withAnimation {
                    showSuccessMessage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showSuccessMessage = false
                    }
                }
            } else {
                print("Error: No se pudo encontrar el controlador de vista raíz para presentar UIDocumentInteractionController")
            }
            
            // Opcionalmente, también permitir compartir el PDF
            let activityController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                activityController.popoverPresentationController?.sourceView = rootViewController.view
                rootViewController.present(activityController, animated: true, completion: nil)
            } else {
                print("Error: No se pudo encontrar el controlador de vista raíz para presentar UIActivityViewController")
            }
        } catch {
            print("Error al guardar el PDF: \(error)")
        }
    }
}

// Extensión para manejar el delegate de UIDocumentInteractionController
extension UIViewController: UIDocumentInteractionControllerDelegate {
    public func documentInteractionControllerDidDismissOptionsMenu(_ controller: UIDocumentInteractionController) {
        // Opcional: Manejar cuando el usuario cierra el menú
    }
}

struct Reportes_Previews: PreviewProvider {
    static var previews: some View {
        Reportes()
            .environmentObject(ProgressManager())
    }
}
