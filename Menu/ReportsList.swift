import SwiftUI

struct ReportsListView: View {
    @EnvironmentObject private var progressManager: ProgressManager
    
    var body: some View {
        VStack {
            Text("Lista de Reportes")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            if progressManager.reports.isEmpty {
                Text("No hay reportes generados.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(progressManager.reports) { report in
                    NavigationLink(destination: ReportDetailView(report: report)) {
                        Text(report.situation)
                            .font(.headline)
                            .padding(.vertical, 5)
                    }
                }
            }
            
            Spacer()
        }
        .navigationTitle("Reportes")
    }
}

struct ReportDetailView: View {
    let report: Report
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Detalles del Reporte")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
            
            // Formatear la fecha
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
                return formatter
            }()
            let formattedDate = dateFormatter.string(from: report.date)
            
            Text("Fecha: \(formattedDate)")
                .font(.headline)
            
            Text("Nombre: \(report.name)")
                .font(.headline)
            
            Text("Situación: \(report.situation)")
                .font(.headline)
            
            Text("Descripción: \(report.description)")
                .font(.body)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding()
        .navigationTitle(report.situation)
    }
}

struct ReportsListView_Previews: PreviewProvider {
    static var previews: some View {
        ReportsListView()
            .environmentObject(ProgressManager())
    }
}
