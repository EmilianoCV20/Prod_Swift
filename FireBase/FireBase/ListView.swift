//
//  ListView.swift
//  FireBase
//
//  Created by Emiliano Cepeda on 11/12/24.
//

import SwiftUI

struct ListView: View {
    @StateObject var dataManager = DataManager()
    @State private var showPopup = false
    @State private var showAlert = false
    @State private var itemToDelete: Inventario? = nil // Elemento a eliminar
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.inventario, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.objeto)
                            .font(.headline)
                        HStack {
                            Text("Cantidad: \(item.cantidad)")
                            Spacer()
                            Text(item.importante == "true" ? "Importante" : "No Importante")
                                .foregroundColor(item.importante == "true" ? .red : .gray)
                                .italic()
                        }
                    }
                    .contentShape(Rectangle()) // Para detectar clics en toda la celda
                    .onTapGesture {
                        itemToDelete = item
                        showAlert = true
                    }
                }
            }
            .navigationTitle("Inventario")
            .navigationBarItems(trailing: Button(action: {
                showPopup.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $showPopup) {
                NewInventarioView()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Eliminar"),
                    message: Text("¿Estás seguro de que quieres eliminar \(itemToDelete?.objeto ?? "")?"),
                    primaryButton: .destructive(Text("Eliminar")) {
                        if let item = itemToDelete {
                            dataManager.deleteInventario(item)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

//CODIGO ORIGINAL PARA MOSTRAR LAS RAZAS DE PERRO
/*
struct ListView: View {
    @StateObject var dataManager = DataManager()
    @State private var showPopup = false
    @State private var showAlert = false
    @State private var dogToDelete: Dog? = nil // Elemento a eliminar
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.dogs, id: \.id) { dog in
                    HStack {
                        Text(dog.breed)
                        Spacer()
                        Button(action: {
                            dogToDelete = dog
                            showAlert = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Dogs")
            .navigationBarItems(trailing: Button(action: {
                showPopup.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $showPopup) {
                NewDogView()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Eliminar"),
                    message: Text("¿Estás seguro de que quieres eliminar \(dogToDelete?.breed ?? "")?"),
                    primaryButton: .destructive(Text("Eliminar")) {
                        if let dog = dogToDelete {
                            dataManager.deleteDog(dog)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
*/

#Preview {
    ListView()
        .environmentObject(DataManager())
}
