====================================================
appDeportes – SwiftUI + Core ML
====================================================

Autor: Emiliano Cepeda  
Platforma: iOS  
Lenguaje: Swift (SwiftUI) — Core ML

----------------------------------------------------
1. Overview
----------------------------------------------------
appDeportes es una aplicación de demostración en SwiftUI que utiliza un modelo Core ML (`ClasificadorPelotas.mlmodel`) para clasificar imágenes de pelotas. La interfaz permite navegar entre un conjunto de imágenes locales, enviar la imagen actual al modelo y mostrar la etiqueta predicha.

El proyecto ilustra:
- Integración básica de un modelo Core ML en una app SwiftUI.  
- Conversión de `UIImage` a `CVPixelBuffer` para la entrada del modelo.  
- Uso del modelo generado automáticamente (`ClasificadorPelotas`) para realizar predicciones.  
- UI simple con navegación entre imágenes y un botón para predecir.

----------------------------------------------------
2. Estructura de Archivos
----------------------------------------------------

/appDeportesApp.swift  
    Punto de entrada (`@main`) que carga `ContentView` en la escena principal.

/ContentView.swift  
    - UI principal con:
        • Array `images` con nombres de assets (pelota1 .. pelota15).  
        • Propiedad `imageClassifier: ClasificadorPelotas?` — instancia del modelo Core ML.  
        • Estados `currentIndex` y `classLabel` para controlar la imagen actual y la etiqueta predicha.  
        • Método `predictImage()` que convierte la `UIImage` a `CVPixelBuffer` y llama a `imageClassifier?.prediction(image:)`.  
    - Incluye extensión de `UIImage` con `toCVPixelBuffer()` (función de preprocesado usada por el modelo).

/ClasificadorPelotas.mlmodel  
    - Archivo de modelo Core ML incluido en el proyecto (ya proporcionado).  
    - Al añadirlo al Xcode target, Xcode generará automáticamente la clase `ClasificadorPelotas` con métodos `prediction(...)` según la entrada esperada.

/Assets.xcassets  
    - Imágenes locales usadas por la demo: `pelota1`, `pelota2`, ... `pelota15` (deben añadirse al Asset Catalog).

----------------------------------------------------
3. Funcionalidad Clave
----------------------------------------------------
• **Navegación entre imágenes**  
  – Botones Previous / Next para recorrer imágenes locales.

• **Predicción con Core ML**  
  – Conversión `UIImage -> CVPixelBuffer` (extensión incluida).  
  – Llamada a `ClasificadorPelotas.prediction(image:)` y lectura del campo de salida `target` para mostrar la etiqueta.

• **Interfaz simple**  
  – Muestra imagen, botón Predict y etiqueta con resultado.

----------------------------------------------------
4. Requerimientos y pasos de integración del .mlmodel
----------------------------------------------------
• Xcode 14/15 recomendado.  
• iOS 14+ (SwiftUI moderno; Core ML soportado en iOS 11+).  
• Añadir `ClasificadorPelotas.mlmodel` al proyecto en Xcode:
  1. Arrastrar `ClasificadorPelotas.mlmodel` a tu proyecto Xcode (asegúrate de marcar el Target).  
  2. Xcode compilará el modelo y generará la clase `ClasificadorPelotas` (usada en el código).  
  3. Verifica en el inspector del modelo el tipo de entrada (imagen, tamaño esperado, color space). Ajusta `toCVPixelBuffer()` para producir la dimensión y formato esperado por el modelo (anchura/altura / pixel format).  
  4. Si el modelo requiere un tamaño fijo (p. ej. 224×224), redimensionar la `UIImage` antes de convertirla a `CVPixelBuffer`. La función `toCVPixelBuffer()` del proyecto no escala la imagen; si el modelo exige una dimensión concreta, escalar la imagen con `UIGraphicsImageRenderer` o similar antes de la conversión.

• Assets: añadir las imágenes `pelota1`..`pelota15` al Asset Catalog.

• Permisos: no son necesarios permisos especiales para este demo (no usa cámara ni red).

----------------------------------------------------
5. Observaciones técnicas y validaciones
----------------------------------------------------
• **Tamaño y formato de entrada:**  
  - Comprueba en Xcode (inspector del `.mlmodel`) el tipo de entrada (imagen, tamaño y escala). Si la entrada del modelo tiene un tamaño concreto, debes redimensionar la imagen antes de crear el `CVPixelBuffer`. Si usas la imagen tal cual, la predicción puede fallar o producir resultados inesperados.

• **Uso de MLModelConfiguration:**  
  - El proyecto crea `ClasificadorPelotas(configuration: MLModelConfiguration())`. Puedes ajustar `MLModelConfiguration` (p. ej. `computeUnits`) para seleccionar CPU/Neural Engine/GPU según el dispositivo:
    ```
    let cfg = MLModelConfiguration()
    cfg.computeUnits = .all  // .cpuOnly, .cpuAndGPU, .all
    ClasificadorPelotas(configuration: cfg)
    ```

• **Errores y manejo:**  
  - Se capturan errores con `do/catch` al cargar el modelo y al predecir; es recomendable notificar al usuario si falla la predicción y logear detalles durante desarrollo.

• **Performance:**  
  - Para predicciones en lote o en tiempo real (cámara), considera utilizar `Vision` (VNCoreMLModel / VNCoreMLRequest) que maneja preprocesado y escala automáticamente y ofrece mejor integración con cámara/video.

• **Compatibilidad del modelo en simulador vs dispositivo:**  
  - Algunos modelos que requieren accelerators (Neural Engine) funcionan distinto en simulador; prueba en dispositivo real para mediciones reales de rendimiento.

----------------------------------------------------
6. Notas finales y recomendaciones
----------------------------------------------------
- Asegúrate de que `ClasificadorPelotas.mlmodel` esté incluido en el target y que Xcode haya generado la clase correspondiente.  
- Si tras añadir el modelo la invocación `ClasificadorPelotas(...)` no existe, limpia el proyecto (Product → Clean Build Folder) y compila de nuevo para forzar la generación del wrapper Swift.

====================================================
