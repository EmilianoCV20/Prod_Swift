//
//  ContentView.swift
//  AppSwiftAR
//
//  Created by Emiliano Cepeda on 13/12/24.
//

import SwiftUI

struct ContentView: View {
    @State var isPresented: Bool = false
    @State var selectedModel: String = "toy_biplane_idle" // Variable para almacenar el modelo seleccionado

    var body: some View {
        VStack {
            // Imagen y selección de modelos
            Text("Selecciona un modelo:")
                .font(.headline)
                .padding()

            HStack {
                // Botón para el modelo del avión
                Button(action: {
                    selectedModel = "toy_biplane_idle"
                }) {
                    VStack {
                        Image("biplane")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                        Text("Biplane")
                            .font(.caption)
                    }
                }

                // Botón para el modelo del carro
                Button(action: {
                    selectedModel = "toy_car"
                }) {
                    VStack {
                        Image("toycar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                        Text("Car")
                            .font(.caption)
                    }
                }

                // Botón para el modelo del Sith Trooper
                Button(action: {
                    selectedModel = "Sith_trooper"
                }) {
                    VStack {
                        Image("Trooper")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                        Text("Trooper")
                            .font(.caption)
                    }
                }
            }
            .padding()

            // Botón para ver en AR
            Button {
                isPresented.toggle()
            } label: {
                Label("View in AR", systemImage: "arkit")
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .padding()
        }
        .padding()
        .fullScreenCover(isPresented: $isPresented, content: {
            SheetView(isPresented: $isPresented, modelName: $selectedModel)
        })
    }
}

#Preview {
    ContentView()
}
