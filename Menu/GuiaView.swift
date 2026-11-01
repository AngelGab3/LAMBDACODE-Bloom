import SwiftUI

struct GuiaView: View {
    var body: some View {
        VStack {
            Text("Guía de Acción")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("Aquí puedes encontrar más guías y consejos para actuar frente a problemas ambientales.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            
            // Ejemplo de contenido (puedes personalizarlo)
            VStack(alignment: .leading, spacing: 15) {
                Text("¿Qué hacer si encuentras residuos tóxicos?")
                    .font(.headline)
                Text("1. No toques los residuos.\n2. Reporta a las autoridades locales.\n3. Documenta con fotos si es seguro.")
                    .font(.body)
                    .foregroundColor(.gray)
                
                Text("¿Qué hacer si ves pesca ilegal?")
                    .font(.headline)
                Text("1. No intervengas directamente.\n2. Contacta a la guardia costera.\n3. Registra la ubicación y detalles.")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Guía")
    }
}

struct GuiaView_Previews: PreviewProvider {
    static var previews: some View {
        // No usamos NavigationView aquí, ya que ContentView ya lo proporciona
        GuiaView()
    }
}
