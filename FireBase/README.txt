====================================================
FireBase – SwiftUI + Firebase
====================================================

Author: Emiliano Cepeda  
Created: 11/12/24  
Platform: iOS  
Language: Swift (SwiftUI) — integra Firebase (Auth, Firestore)

----------------------------------------------------
1. Overview
----------------------------------------------------
Proyecto “FireBase” es una aplicación SwiftUI que integra Firebase Authentication y Cloud Firestore para ofrecer un flujo básico de autenticación y un CRUD en tiempo real sobre un recurso llamado `Inventario`. La app incluye:

- Pantalla de registro / login con Email+Password (Firebase Auth).  
- Lista en tiempo real de documentos `Inventario` (Firestore) mediante snapshot listener.  
- Alta de nuevos elementos (sheet) y eliminación con confirmación (alert).  
- Gestión de datos a través de un `DataManager` observable que expone los cambios mediante `@Published`.  
- Uso de `EnvironmentObject` para inyectar `DataManager` en vistas (aunque hay lugares que crean instancias locales duplicadas).

Es un ejemplo práctico de cómo enlazar la capa de persistencia en la nube (Firestore) con la UI declarativa de SwiftUI y cómo gestionar autenticación simple.

----------------------------------------------------
2. Estructura de Archivos
----------------------------------------------------

/FireBaseApp.swift  
    - `@main` de la app. Inicializa Firebase (`FirebaseApp.configure()`) y crea el `DataManager` como `@StateObject`.  
    - Inyecta `dataManager` en el entorno con `.environmentObject(dataManager)`.

/ContentView.swift  
    - Pantalla principal de autenticación que muestra campos `email` y `password`.  
    - Botones `register()` y `login()` que llaman a Firebase Auth.  
    - Verifica `Auth.auth().currentUser` en `onAppear` para mantener sesión.  
    - Muestra `ListView()` cuando `userIsLoggedIn == true`.  
    - Contiene extensión `placeholder` para TextField estilizado.

/DataManager.swift  
    - `ObservableObject` responsable de la capa de datos: lectura en tiempo real (`addSnapshotListener`), creación (`addInventario`) y eliminación (`deleteInventario`).  
    - Publica `@Published var inventario: [Inventario]`.  
    - Mantiene y remueve `listener` en `deinit`.

/ListView.swift  
    - Muestra `List` con `ForEach(dataManager.inventario)`.  
    - Permite eliminar un item mediante alert de confirmación.  
    - Presenta `NewInventarioView` en sheet para crear nuevos registros.  
    - **Nota:** actualmente crea su propio `@StateObject var dataManager = DataManager()` (duplicado). Debe usar `@EnvironmentObject` para reutilizar el `dataManager` global inyectado en `FireBaseApp`.

/NewInventarioView.swift  
    - Formulario para crear un nuevo `Inventario` (objeto, cantidad, importante).  
    - Llama `dataManager.addInventario(...)` (obtiene `dataManager` desde `@EnvironmentObject`).

/Inventario.swift  
    - Modelo simple `Identifiable` con campos: `id`, `objeto`, `cantidad`, `importante`.

/Dog.swift, NewDogView.swift (opcional)  
    - Código auxiliar (ejemplo original) para gestionar otra colección (`Dogs`) — se mantiene pero comentado/ no usado actualmente.

----------------------------------------------------
3. Funcionalidad Clave
----------------------------------------------------
• **Autenticación (Email/Password)**  
  - Registro y login usando `Auth.auth().createUser` y `Auth.auth().signIn`.  
  - Mantener sesión consultando `Auth.auth().currentUser`.

• **Lectura en tiempo real (Firestore)**  
  - `DataManager.fetchInventario()` se conecta a `collection("Inventario")` y escucha cambios con `addSnapshotListener`.  
  - La UI se actualiza automáticamente gracias a `@Published inventario`.

• **CRUD básico**  
  - `addInventario(...)` crea documentos con un `UUID`.  
  - `deleteInventario(...)` borra documentos por `id`.  
  - Conversión simple entre `DocumentSnapshot` y modelo `Inventario`.

• **UX básico**  
  - `List` con `onTapGesture` para marcar un elemento y lanzar alerta de eliminación.  
  - `sheet` para crear nuevos ítems.

----------------------------------------------------
4. Requerimientos y Configuración
----------------------------------------------------
• Xcode 14/15 recomendado.  
• iOS 14+ (SwiftUI moderno y compatibilidad Firebase reciente).  
• Dependencias Firebase instaladas (recomendado via Swift Package Manager):  
  - FirebaseAuth, FirebaseFirestore, FirebaseCore.  
• Archivo **GoogleService-Info.plist** añadido al target (no incluirlo en control de versiones público).  
• Habilitar en la consola Firebase: Authentication (Email/Password) y Firestore (crear colección `Inventario`).  
• Configurar reglas de seguridad de Firestore apropiadas antes de deploy (no usar reglas abiertas en producción).  
• Añadir el AppDelegate/SceneDelegate si el proyecto lo requiere (según plantilla).  
• Permisos de red en Info.plist si se usan características adicionales.

----------------------------------------------------
5. Dependencias (paquetes asociados a Firebase y utilidades)
----------------------------------------------------
A continuación se listan dependencias (bibliotecas y componentes) que suelen formar parte del ecosistema de Firebase o ser requeridas/empleadas por paquetes binarios que Firebase integra. Estas se pueden agregar al proyecto mediante **Swift Package Manager (SPM)** en Xcode o, en casos históricos, por CocoaPods — se recomienda SPM actualmente:

Nota: muchas de estas dependencias forman parte del bundle de Firebase distribuidas por Google; al agregar Firebase via SPM algunas se resuelven automáticamente. Aquí se indica su propósito y recomendaciones generales de inclusión.

- **Abseil**  
  - Descripción: Colección de bibliotecas de C++ reutilizables (Abseil).  
  - Uso: Dependencia de bajo nivel para implementaciones C++ empaquetadas como binarios para SPM.  
  - Cómo añadir: normalmente suministrado como dependencia transitiva de Firebase cuando se usa el paquete oficial.

- **App Check Core**  
  - Descripción: Núcleo para Firebase App Check (protección de recursos).  
  - Uso: Si se activa App Check en Firebase, incluir este módulo para validar peticiones.  
  - Nota: habilitar App Check en consola y configurar proveedores (DeviceCheck, App Attest).

- **Firebase Apple Open Source Development**  
  - Descripción: Conjunto de componentes open-source de Firebase para plataformas Apple.  
  - Uso: Se agregan con el paquete oficial de Firebase.

- **GoogleAppMeasurement**  
  - Descripción: Biblioteca para medición (Analytics).  
  - Uso: Necesario si se usa Firebase Analytics o Google Measurement APIs.

- **GoogleDataTransport**  
  - Descripción: Sistema de transporte de datos para enviar logs/telemetría.  
  - Uso: Utilizado por bibliotecas que envían eventos/telemetría (Analytics, Crashlytics).

- **GoogleUtilities**  
  - Descripción: Conjunto de utilidades de Google (helpers, logging, etc.).  
  - Uso: Biblioteca auxiliar requerida por varios SDKs de Google/Firebase.

- **gRPC Binary Distribution for Swift Package Manager**  
  - Descripción: Distribución binaria de gRPC para SPM (soporte para RPCs).  
  - Uso: Requerido por algunas implementaciones que usan gRPC; Firebase puede depender de gRPC en ciertas plataformas.

- **Google Toolbox for Mac - Session Fetcher**  
  - Descripción: Biblioteca para realizar fetches y sesiones HTTP de manera robusta.  
  - Uso: Auxiliar en comunicaciones de red en stack Google.

- **Interop Libraries for Google SDKs on Apple Platforms**  
  - Descripción: Librerías de interoperabilidad para integrar componentes escritos en C/C++/ObjC con Swift.  
  - Uso: Permiten que las dependencias nativas trabajen con SPM y el runtime de Swift.

- **LevelDB**  
  - Descripción: Base de datos embebida de clave-valor de alto rendimiento (C++) usada localmente por algunos componentes.  
  - Uso: Firebase local persistence / cache puede usar LevelDB como motor subyacente en ciertas builds.

- **Nanopb**  
  - Descripción: Implementación ligera de Protocol Buffers para sistemas embebidos.  
  - Uso: Serialización de mensajes Protobuf en clientes; usado por algunos módulos de Firebase.

- **Promises**  
  - Descripción: Framework que facilita la programación asíncrona (promesas) para Objective-C/Swift.  
  - Uso: Empleado internamente en algunas operaciones asíncronas.

- **Swift Protobuf**  
  - Descripción: Implementación de Protocol Buffers en Swift.  
  - Uso: Serialización/Deserialización de mensajes Protobuf en código Swift; útil si tu app procesa mensajes Protobuf.

----------------------------------------------------
6. Referencias rápidas
----------------------------------------------------
- Firebase iOS SDK — documentación oficial (instalación por SPM / CocoaPods).  
- GoogleService-Info.plist — archivo requerido para inicializar Firebase en iOS.  
- Firestore rules — configurar en consola antes de publicar.

----------------------------------------------------
7. Licencias y privacidad
----------------------------------------------------
- Verifica licencias de las dependencias (Apache 2.0, BSD, MIT, etc.) antes de publicar.  
- Asegura cumplimiento de políticas de privacidad si manejas datos de usuarios; publica una política de privacidad si la app va a producción.

====================================================
