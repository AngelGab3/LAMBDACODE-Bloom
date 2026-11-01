import SwiftUI

struct QueHacerDetailView: View {
    let item: ContentView.Item
    
    var body: some View {
        VStack {
            // Imagen de la guía
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 350, height: 350)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
            
            // Descripción
            if let description = item.description {
                Text(description)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding()
            }
            
            switch item.title {
            case "Encuentras un Derrame de Petróleo":
                
                Text("Seguridad: No te acerques, evia fuego.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.8)
                    .padding(.horizontal)
                    .padding(6)
                Text("Documenta: Ubicación, fotos/videos (si es seguro).")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.7)
                    .padding(.horizontal)
                    .padding(6)
                Text("Reporta: PROFEPA (01-800-770-33-72) o 911.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.6)
                    .padding(.horizontal)
                    .padding(6)
                Text("No intervengas: Deja a expertos")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.5)
                    .padding(.horizontal)
                    .padding(6)
                Text("Seguimiento: Guarda folio.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.4)
                    .padding(.horizontal)
                    .padding(6)
                Text("Aléjate, documenta, reporta y no actúes solo.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.8)
                    .padding(.horizontal)
                    .padding(6)
                
            case "Ves Deforestación Ilegal":
                Text("Observa: Maquinaria, tala, permisos.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.8)
                    .padding(.horizontal)
                    .padding(6)
                Text("Documenta: Fotos/videos, ubicación.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.7)
                    .padding(.horizontal)
                    .padding(6)
                Text("Reporta: PROFEPA (01-800-770-33-72) o SEMARNAT.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.6)
                    .padding(.horizontal)
                    .padding(6)
                Text("No confrontes: Prioriza seguridad.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.5)
                    .padding(.horizontal)
                    .padding(6)
                Text("Monitorea: Actualiza denuncia. ")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.5)
                    .padding(.horizontal)
                    .padding(6)
                Text("Observa, documenta, reporta y evita riesgos")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.8)
                    .padding(.horizontal)
                    .padding(6)
            case "Hay un Incendio Forestal":
                Text("Seguridad: Aléjate de llamas/humo.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.8)
                    .padding(.horizontal)
                    .padding(6)
                Text("Documenta: Ubicación, tamaño.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.7)
                    .padding(.horizontal)
                    .padding(6)
                Text("Reporta: CONAFOR (01-800-462-3634) o 911.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.6)
                    .padding(.horizontal)
                    .padding(6)
                Text("No apagues solo: Solo expertos.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.5)
                    .padding(.horizontal)
                    .padding(6)
                Text("Detalla: Tamaño, dirección.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.4)
                    .padding(.horizontal)
                    .padding(6)
                Text("Aléjate, documenta, reporta y no intervengas.")
                    .font(.body)
                    .foregroundColor(.black)
                    .opacity(0.8)
                    .padding(.horizontal)
                    .padding(6)
            default:
                Text("1. Mantén la calma y evalúa la situación.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Text("2. Contacta a las autoridades locales.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Text("3. Documenta el incidente si es seguro hacerlo.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        
        Spacer()
    }
}

struct QueHacerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        QueHacerDetailView(item: ContentView.Item(
            title: "Encuentras un Derrame de Petróleo",
            imageName: "petroleo",
            completedImageName: "petroleo",
            description: "Pasos a seguir si encuentras un derrame de petróleo en el agua.",
            date: nil
        ))
    }
}
