//
//  SheetView.swift
//  AppSwiftAR
//
//  Created by Emiliano Cepeda on 13/12/24.
//

import SwiftUI

struct SheetView: View {
    @Binding var isPresented: Bool
    @Binding var modelName: String // Variable enlazada para el modelo seleccionado

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ARViewContainer(modelName: $modelName)
                .ignoresSafeArea(edges: .all)

            Button {
                isPresented.toggle()
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding(24)
        }
    }
}

#Preview {
    SheetView(isPresented: .constant(true), modelName: .constant("toy_biplane_idle"))
}

