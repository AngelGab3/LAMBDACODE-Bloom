# Documentación de Arquitectura — Bloom (LambdaCode)

Este documento describe la arquitectura interna, el modelo de datos, la gestión de estado reactivo y los patrones de diseño implementados en la aplicación **Bloom**.

---

## 1. Patrón Arquitectónico General

Bloom implementa una arquitectura reactiva basada en **MVVM (Model-View-ViewModel)** adaptada a las directrices declarativas de SwiftUI y Combine:

```
┌────────────────────────────────────────────────────────┐
│                   Vistas (SwiftUI)                     │
│  ContentView, FlorView, MisionDetailView, Reportes...  │
└───────────────────────────▲────────────────────────────┘
                            │ @EnvironmentObject
                            │ @Published Bindings
┌───────────────────────────▼────────────────────────────┐
│              ViewModel / State Manager                 │
│                   ProgressManager                      │
│     (experiencePoints, completedMissions, reports)     │
└───────────────────────────▲────────────────────────────┘
                            │ Model Structs
┌───────────────────────────▼────────────────────────────┐
│                    Modelos de Datos                    │
│            Report, MissionPhoto, Section, Item         │
└────────────────────────────────────────────────────────┘
```

---

## 2. Modelos de Datos

### 2.1. `ProgressManager` (`ObservableObject`)
Es la fuente única de verdad (*Single Source of Truth*) para el estado de la sesión:

- `experiencePoints: Int`: Puntos acumulados (0 a 100+). Cada misión finalizada incrementa en `+15 XP`.
- `completedMissions: Set<String>`: Conjunto inmutable de identificadores de misiones completadas para evitar duplicidad de recompensas.
- `reports: [Report]`: Colección en memoria de reportes levantados por el usuario.
- `missionPhotos: [MissionPhoto]`: Registro histórico de fotografías tomadas como evidencia en misiones.
- `progress: Double`: Propiedad computada que normaliza el progreso entre `0.0` y `1.0`:
  $$\text{progress} = \min\left(\frac{\text{experiencePoints}}{100.0}, 1.0\right)$$
- `reportCount: Int`: Conteo de reportes para el badge de notificación en la toolbar.

### 2.2. Entidades Secundarias
- **`Report` (`Identifiable`):**
  - `id: UUID`: Identificador único.
  - `date: Date`: Fecha de registro del incidente.
  - `name: String`: Nombre del ciudadano denunciante.
  - `situation: String`: Título o asunto del reporte.
  - `description: String`: Explicación detallada de la problemática ecológica.
- **`MissionPhoto` (`Identifiable`):**
  - `id: UUID`: Identificador único.
  - `image: UIImage`: Imagen binaria capturada con la cámara.
  - `missionTitle: String`: Título de la misión a la que pertenece la evidencia.
  - `date: Date`: Marca temporal en que fue capturada.

---

## 3. Puentes de Interoperabilidad con UIKit (`UIViewControllerRepresentable`)

Debido a que ciertas capacidades del sistema requerían integración profunda con APIs de iOS, Bloom implementa puentes estructurados:

### 3.1. `ImagePicker` (`UIViewControllerRepresentable`)
- **Objetivo:** Invocar la cámara del dispositivo físico para validar el cumplimiento de misiones.
- **Implementación:**
  - Envuelve un `UIImagePickerController` configurado con `.sourceType = .camera`.
  - Emplea un `Coordinator` que adopta `UIImagePickerControllerDelegate` y `UINavigationControllerDelegate` para capturar la imagen original en `@Binding var image: UIImage?` y cerrar el modal.

### 3.2. `CustomVideoPlayer` (`UIViewControllerRepresentable`)
- **Objetivo:** Reproducir videos cinemáticos de inicio y transición sin mostrar controles nativos del reproductor.
- **Implementación:**
  - Envuelve un `AVPlayerViewController`.
  - Configura `showsPlaybackControls = false` y `videoGravity = .resizeAspectFill`.

---

## 4. Pipeline de Generación de Reportes en PDF

El módulo `Reportes.swift` realiza un proceso completo de exportación documental estándar:

1. **Definición del Canvas:** Crea un contexto gráfico mediante `UIGraphicsBeginPDFContextToData` con dimensiones estándar ISO 216 **A4** (595.2 $\times$ 841.8 puntos).
2. **Dibujado Vectorial:**
   - Dibuja el título del reporte con tipografía en negrita (`UIFont.boldSystemFont(ofSize: 20)`).
   - Renderiza los metadatos (Fecha, Nombre, Situación, Descripción) en un área delimitada con espaciado de seguridad (`CGRect(x: 40, y: 80, width: 515.2, height: 721.8)`).
3. **Persistencia en Sandbox:** Guarda el binario `.pdf` en el directorio de documentos del contenedor de la aplicación (`FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)`).
4. **Exportación al Sistema:**
   - Utiliza `UIDocumentInteractionController` para permitir guardar en la aplicación nativa "Archivos" (iCloud / Local).
   - Ofrece `UIActivityViewController` para compartir por canales de mensajería externa.

---

## 5. Árbol de Vistas y Jerarquía

```
BloomApp (@main)
└── WindowGroup
    └── SplashScreenView (carga logo.mp4)
        └── [fullScreenCover] TransitionScreenView (carga transitionVideo.mp4)
            └── [fullScreenCover] ContentView (Dashboard Principal)
                ├── [NavigationLink] FlorView (Visualizador dinámico de XP)
                ├── [ScrollView Horizontal] Misiones
                │   └── [NavigationLink] MisionDetailView
                │       ├── [NavigationLink] DenunciarContaminacionView (Agua Reutilizada)
                │       ├── [NavigationLink] ReforestacionView (Plan sin Desperdicio)
                │       └── [NavigationLink] MonitorearAguaView (Planta un Futuro)
                ├── [VStack] Feed (Fotos capturadas + Compartir)
                ├── [ScrollView Horizontal] ¿Qué hacer si?
                │   └── [NavigationLink] QueHacerDetailView (Guías de contingencia)
                ├── [NavigationLink] Reportes (Formulario de Denuncia y Generador PDF)
                └── [ToolbarItem] ReportsListView (Bandeja de reportes generados)
                    └── [NavigationLink] ReportDetailView (Lectura individual)
```
