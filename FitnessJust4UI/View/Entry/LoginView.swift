//
//  LoginView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 31.05.23.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject private var lvm = LogInViewModel()
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var spusername: String = ""
    @State private var spapitoken: String = ""
    
    var body: some View {
        
        
        NavigationStack{
            VStack {
                TextField("Username", text: $lvm.username)
                    .padding()
                    .autocapitalization(.none)
                
                SecureField("Password", text: $lvm.password)
                    .padding()
                
                Button(action: {
                    //authenticateUser()
                    lvm.authUser()
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
            
            //.alert(isPresented: $showError) {
              //  Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            //}
            NavigationLink("", destination: NavigationView(), isActive: $lvm.verify)
                .opacity(0)
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    func authenticateUser() {
        APIManager.shared.getAuth(username: lvm.username, password: lvm.password) { success, message, apiToken in
            if success {
                
                lvm.verify = success
                
                UserDefaults.standard.set(apiToken, forKey: "apiToken")
                UserDefaults.standard.set(lvm.username, forKey: "username")
                
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
