====================================================
AppSwiftAR – Swift (SwiftUI + ARKit / RealityKit)
====================================================

Author: Emiliano Cepeda  
Created: 13/12/24  
Platform: iOS  
Language: Swift (SwiftUI) — integra ARKit / RealityKit

----------------------------------------------------
1. Overview
----------------------------------------------------
AppSwiftAR es una aplicación de demostración en SwiftUI que integra ARKit y RealityKit para colocar modelos 3D en el mundo real. El usuario selecciona uno de varios modelos desde una UI simple y puede ver el modelo seleccionado en una vista AR dedicada. La vista AR utiliza `ARWorldTrackingConfiguration` con detección de planos (horizontal y vertical) y texturizado de entorno automático.

El proyecto demuestra:
- Uso de `UIViewRepresentable` para integrar `ARView` en SwiftUI.  
- Configuración básica de sesión AR (`ARWorldTrackingConfiguration`).  
- Carga dinámica de modelos 3D con `Entity.loadModel(named:)` y anclaje a la escena con `AnchorEntity`.  
- Interacción simple entre la UI SwiftUI (selección de modelo) y la escena AR.

----------------------------------------------------
2. Estructura de Archivos
----------------------------------------------------

/AppSwiftARApp.swift  
    - Entrada `@main` del proyecto. Carga `ContentView` en la escena principal.

/ARViewContainer.swift  
    - `UIViewRepresentable` que crea y actualiza un `ARView`.  
    - `makeUIView(context:)`:
        • Crea `ARView`.  
        • Comprueba compatibilidad `ARWorldTrackingConfiguration.isSupported`.  
        • Configura `ARWorldTrackingConfiguration` con `planeDetection = [.horizontal, .vertical]` y `environmentTexturing = .automatic`.  
        • Inicia la sesión AR (`arView.session.run(config)`).  
    - `updateUIView(_:context:)`:
        • Crea un `AnchorEntity(plane: .any)` y carga el modelo con `Entity.loadModel(named:)`.  
        • Añade el modelo al ancla y añade el ancla a la escena (`uiView.scene.addAnchor(anchorEntity)`).

 /ContentView.swift  
    - Interfaz principal de selección de modelos:  
        • Estado `selectedModel` con nombre de modelo actual (por ejemplo `"toy_biplane_idle"`).  
        • Tres botones con miniaturas (`biplane`, `toycar`, `Trooper`) para elegir el modelo.  
        • Botón para abrir `fullScreenCover` que muestra la vista AR (`SheetView`).

 /SheetView.swift  
    - Contenedor que presenta la vista AR en pantalla completa:  
        • `ARViewContainer(modelName: $modelName)` para renderizar AR.  
        • Botón de cierre en la esquina superior derecha para dismiss.

----------------------------------------------------
3. Funcionalidad Clave
----------------------------------------------------
• **Selección de modelo**  
  – UI simple para elegir entre varios modelos 3D.

• **Visualización AR**  
  – `ARView` con seguimiento de mundo completo (6DoF), detección de planos horizontales y verticales, y texturizado de entorno.

• **Carga dinámica de modelos**  
  – `Entity.loadModel(named:)` carga modelos empaquetados en el app bundle (.reality, .usdz, .rcproject compilado a .reality).

• **Presentación en pantalla completa**  
  – La escena AR se presenta con `fullScreenCover` para experiencia inmersiva y fácil dismiss.

----------------------------------------------------
4. Requerimientos
----------------------------------------------------
• Dispositivo físico compatible con ARKit (iPhone/iPad con A9 o posterior y soporte ARKit).  
• iOS 13+ (RealityKit requiere iOS 13+; si usa características recientes, preferible iOS 14/15+).  
• Xcode 12/13/14/15 con RealityKit/ARKit disponibles.  
• Frameworks: RealityKit, ARKit (añadidos en el target).  
• Assets requeridos:  
  - Miniaturas de selección: `biplane`, `toycar`, `Trooper` (imágenes en Assets.xcassets).  
  - Modelos 3D (en bundle): `toy_biplane_idle`, `toy_car`, `Sith_trooper` — archivos compatibles RealityKit (.reality) o .usdz incluidas en el target.  

----------------------------------------------------
5. Archivos y assets incuidos
----------------------------------------------------
/AppSwiftARApp.swift  
/ARViewContainer.swift  
/ContentView.swift  
/SheetView.swift

Assets (añadir a Assets.xcassets):  
- biplane (imagen de selección)  
- toycar (imagen de selección)  
- Trooper (imagen de selección)

Modelos 3D (añadir al bundle / target):  
- toy_biplane_idle (.reality / .usdz)  
- toy_car (.reality / .usdz)  
- Sith_trooper (.reality / .usdz)

Info.plist:  
- NSCameraUsageDescription — texto explicativo del uso de la cámara.  
- (Opcional) UIRequiredDeviceCapabilities: `arkit` / `metal`.

Frameworks usados (debe importarse/estar disponibles en el target):  
- RealityKit  
- ARKit

