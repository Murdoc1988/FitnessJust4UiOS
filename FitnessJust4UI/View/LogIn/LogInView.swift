//
//  LogInView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 26.06.23.
//

import SwiftUI
import AuthenticationServices

struct LogInView: View {
    @ObservedObject private var lvm = LogInViewModel()
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showErrorSheet = false
    @State private var errorMessage = ""
    @State private var showGoogleLoginAlert: Bool = false
    @State private var showAppleLoginAlert: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            TextField("Benutzername", text: $username)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(.black)
                .padding(.top, 16)
                .padding(.bottom, 4)
                .padding([.leading, .trailing], 8)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding([.top, .bottom], 16)
                .padding([.leading, .trailing], 8)
                .textContentType(.none)                 //AutoFill für das Feld deaktivieren
                .foregroundColor(.black)
            
            Button("AppleLogin") {
                showAppleLoginAlert = true
            }
            .padding()
            .alert(isPresented: $showAppleLoginAlert) {
                Alert(title: Text("Hinweis"), message: Text("Apple-Login wird später implementiert."), dismissButton: .default(Text("OK")))
            }
            
            Button("GoogleLogin") {
                showGoogleLoginAlert = true
            }
            .padding()
            .alert(isPresented: $showGoogleLoginAlert) {
                Alert(title: Text("Hinweis"), message: Text("Google-Login wird später implementiert."), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
