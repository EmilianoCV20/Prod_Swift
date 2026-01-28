//
//  ContentView.swift
//  FireBase
//
//  Created by Emiliano Cepeda on 11/12/24.
//
/*
 Aplicacion original creada por
*/

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    
    var body: some View {
        if userIsLoggedIn {
            ListView()
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack {
            Color.black
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.purple, .teal], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(45))
                .offset(y: -310)
            
            VStack(spacing: 20) {
                Text("Hola, Bienvenido!")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -30, y: -100)
                
                TextField("CORREO", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                        Text("CORREO")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                SecureField("CONTRASEÑA", text: $password)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("CONTRASEÑA")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
                Button {
                    register()
                } label: {
                    Text("Registrarse")
                        .bold()
                        .frame(width: 200, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(.linearGradient(colors: [.teal, .purple], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundStyle(.white)
                }
                .padding(.top)
                .offset(y: 100)
                
                Button {
                    login()
                } label: {
                    Text("Ya tienes Cuenta? Inicia Sesion")
                        .bold()
                        .foregroundColor(.green)
                }
                .padding(.top)
                .offset(y: 105)
            }
            .frame(width: 350)
        }
        .ignoresSafeArea()
        .onAppear {
            // Verificar si el usuario ya está autenticado
            if Auth.auth().currentUser != nil {
                userIsLoggedIn = true
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                userIsLoggedIn = true
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                userIsLoggedIn = true
            }
        }
    }
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview {
    ContentView()
}
