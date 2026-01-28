//
//  NewInventarioView.swift
//  FireBase
//
//  Created by Emiliano Cepeda on 12/12/24.
//

import SwiftUI

struct NewInventarioView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var objeto = ""
    @State private var cantidad = ""
    @State private var importante = false
    
    var body: some View {
        VStack {
            TextField("Objeto", text: $objeto)
                .textFieldStyle(.roundedBorder)
            
            TextField("Cantidad", text: $cantidad)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            
            Toggle("¿Es importante?", isOn: $importante)
                .padding()
            
            Button {
                dataManager.addInventario(
                    objeto: objeto,
                    cantidad: cantidad,
                    importante: importante ? "true" : "false"
                )
            } label: {
                Text("Guardar")
                    .bold()
                    .frame(width: 200, height: 50)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.blue))
                    .foregroundColor(.white)
            }
            .padding()
        }
        .padding()
    }
}


#Preview {
    NewInventarioView()
}
