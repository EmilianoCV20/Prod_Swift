//
//  FireBaseApp.swift
//  FireBase
//
//  Created by Emiliano Cepeda on 11/12/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct FireBaseApp: App {
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataManager) //Me envia directo al ListView sin inicio de sesion
                                                //Pero si lo quito el ListView deja de funcionar
        }
    }
}
