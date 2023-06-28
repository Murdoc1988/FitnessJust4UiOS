//
//  LoginView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 31.05.23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var spusername: String = ""
    @State private var spapitoken: String = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .padding()
            
            Button(action: {
                authenticateUser()
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            VStack{
                if(spusername != ""){
                    Text("SP Username: \(spusername)")
                        .padding()
                        .font(.system(size: 12))
                    Text("SP Token: \(spapitoken)")
                        .padding()
                        .font(.system(size: 12))
                }
            }
            .frame(height: 120)
        }
        .padding()
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func authenticateUser() {
        APIManager.shared.authUser(username: username, password: password) { success, message in
            if success {
                // Authentifizierung erfolgreich, zur HomeView weiterleiten
                // Hier kannst du die Navigation zur HomeView implementieren
                // Beispiel: navigationLink(destination: HomeView()) { ... }
                
                UserDefaults.standard.set(message, forKey: "apiToken")
                UserDefaults.standard.set(username, forKey: "username")
                
                if  let uwapiToken = UserDefaults.standard.string(forKey: "apiToken"),
                    let uwusername = UserDefaults.standard.string(forKey: "username") {
                    
                    //Unwrapped username ->
                    spusername = uwusername
                    spapitoken = uwapiToken
                }
                
                
                errorMessage = "Login erfolgreich"
                showError = true
                
                
            } else {
                // Authentifizierung fehlgeschlagen, Fehlermeldung anzeigen
                errorMessage = message
                showError = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
