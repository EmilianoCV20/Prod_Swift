//
//  DataManager.swift
//  FireBase
//
//  Created by Emiliano Cepeda on 11/12/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

class DataManager: ObservableObject {
    @Published var inventario: [Inventario] = []
    private var listener: ListenerRegistration?
    
    init() {
        fetchInventario()
    }
    
    func fetchInventario() {
        let db = Firestore.firestore()
        let ref = db.collection("Inventario")
        
        // Agregar un listener para cambios en tiempo real
        listener = ref.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                self.inventario = snapshot.documents.map { document in
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let objeto = data["objeto"] as? String ?? ""
                    let cantidad = data["cantidad"] as? String ?? ""
                    let importante = data["importante"] as? String ?? ""
                    return Inventario(id: id, objeto: objeto, cantidad: cantidad, importante: importante)
                }
            }
        }
    }
    
    func addInventario(objeto: String, cantidad: String, importante: String) {
        let db = Firestore.firestore()
        let randomID = UUID().uuidString
        let ref = db.collection("Inventario").document(randomID)
        
        ref.setData([
            "id": randomID,
            "objeto": objeto,
            "cantidad": cantidad,
            "importante": importante
        ]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteInventario(_ item: Inventario) {
        let db = Firestore.firestore()
        let ref = db.collection("Inventario").document(item.id)
        
        ref.delete { error in
            if let error = error {
                print("Error al eliminar el inventario: \(error.localizedDescription)")
            } else {
                print("Elemento eliminado correctamente.")
            }
        }
    }
    
    deinit {
        // Detener el listener cuando la clase se deinit
        listener?.remove()
    }
}


//CODIGO ORIGINAL PARA LA BASE DE DATOS DE PERROS
/*
class DataManager: ObservableObject {
    @Published var dogs: [Dog] = []
    
    init() {
        fetchDogs()
    }
    
    func fetchDogs() {
        let db = Firestore.firestore()
        let ref = db.collection("Dogs")
        
        // Listener en tiempo real
        ref.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                self.dogs = snapshot.documents.compactMap { document in
                    let data = document.data()
                    let id = data["id"] as? String ?? ""
                    let breed = data["breed"] as? String ?? ""
                    return Dog(id: id, breed: breed)
                }
            }
        }
    }
    
    func addDog(dogBreed: String) {
        let db = Firestore.firestore()
        let randomInt = Int.random(in: 1...100)
        let ref = db.collection("Dogs").document(dogBreed)
        
        ref.setData(["breed": dogBreed, "id": "\(randomInt)"]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteDog(_ dog: Dog) {
        let db = Firestore.firestore()
        let ref = db.collection("Dogs").document(dog.breed)
        
        ref.delete { error in
            if let error = error {
                print("Error al eliminar el perro: \(error.localizedDescription)")
            } else {
                print("Perro eliminado correctamente.")
            }
        }
    }

}
 */

