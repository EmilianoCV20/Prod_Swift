//
//  NewDogView.swift
//  FireBase
//
//  Created by Emiliano Cepeda on 11/12/24.
//

import SwiftUI

struct NewDogView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var newDog = ""
    
    var body: some View {
        VStack {
            TextField("Dog",text: $newDog)
            
            Button {
                //dataManager.addDog(dogBreed: newDog) SOLO ACTIVAR CUANDO SE USA "Dogs"
            } label: {
                Text("Guardar")
            }
            .padding()
        }
    }
}

#Preview {
    NewDogView()
}
