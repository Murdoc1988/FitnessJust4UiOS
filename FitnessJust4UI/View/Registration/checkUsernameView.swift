//
//  checkUsernameView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 01.06.23.
//

import SwiftUI

struct checkUsernameView: View {
    @ObservedObject private var apiManager = APIManager()
    
    @State private var username = ""
    @State private var mail = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var userexists = false
    @State private var mailexists = false
    @State private var usermessage = ""
    @State private var mailmessage = ""
    @State private var isEmailValid = true
    @State private var isPasswordValid = false
    @State private var arePasswordsMatching = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var passwordStrength = 0
    @State private var pwindicatorcolor = Color(red: CGFloat(1.0), green: CGFloat(0.0), blue: CGFloat(0.0))
    @State private var pwindicatorlength = 10
    @State private var pwForegroundColor = Color.black
    @State private var usernameColor = Color.black
    @State private var mailColor = Color.black
    
    public let logging: (String) -> Void = { message in
        
        var logString = "checkUsernameView(): \(message)"
        
        Logger.shared.log(message: logString)
        
    }
    
    

    var body: some View {
        VStack {
            //MARK: InputUsername
            TextField("Benutzername", text: $username)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(usernameColor)
                .disableAutocorrection(true)
                .padding()
                .onChange(of: username) { newValue in
                    self.checkUsername()
                }
            /*
            VStack{
                if userexists {
                    Text(usermessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .frame(height: 40)
            */
            
            //MARK: InputEMail
            TextField("E-Mail", text: $mail)
                .foregroundColor(mailColor)
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .onChange(of: mail) { newValue in
                    DispatchQueue.main.async{
                        self.checkMail()
                        isEmailValid = self.isValidEmail(mail)
                        self.colorizeForeground()
                    }
                }
            
            //vergaltet
            /*
            VStack{
                if mailexists {
                    Text(mailmessage)
                        .foregroundColor(.red)
                        .padding()
                }
                if !isEmailValid {
                    Text("Ungültiges E-Mail-Format")
                    
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .frame(height: 40)
            */
            //MARK: IntputPasswort
            SecureField("Passwort", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding()
                .textContentType(.none) //AutoFill für das Feld deaktivieren
                .onChange(of: password) { newValue in
                    isPasswordValid = self.isPasswordValid(password, username)
                    calcPasswordIndicator()
                    
                }
                .foregroundColor(pwForegroundColor)
            
            VStack{
                    HStack{
                        Spacer()
                        //TODO: PasswordIndicator fixen!
                        ZStack{
                            
                            
                            Rectangle()
                                .frame(width: 360, height: 24)
                                .foregroundColor(.gray)
                                .cornerRadius(12)
                                
                            HStack{
                                if(password.count >= 8){
                                    Spacer()
                                }
                                Rectangle()
                                    .frame(width: CGFloat(pwindicatorlength), height:12)
                                    .foregroundColor(pwindicatorcolor)
                                    .cornerRadius(6)
                                    .padding(0)
                                Spacer()
                                    
                                
                            }
                            .frame(width: 320, height:12)
                            .padding(0)
                            
                            
                        }
                            
                        
                        Spacer()
                    }
                    //veraltet
                    /*
                    if !isPasswordValid {
                        Text("Unsicheres Password!")
                            .foregroundColor(.red)
                            .padding()
                    }
                    */
                
                    //veraltet
                    /*
                    if arePasswordsMatching {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .padding()
                    }
                    */
                
            }
            .frame(height: 80)
            //MARK: InputSecondPassword
            SecureField("Passwort bestätigen", text: $confirmPassword)
                .textFieldStyle(.roundedBorder)
                .padding()
            
                .textContentType(.none) //AutoFill für das Feld deaktivieren
                .onChange(of: confirmPassword) { newValue in
                    arePasswordsMatching = self.arePasswordsMatching(password, confirmPassword)
                }
                .foregroundColor(pwForegroundColor)
            
            //MARK: ButtonRegisterUser
            Button(action: {
                print("Button clicked!")
                registerUser()
                
            }) {
                Text("Registrieren")
                    .padding()
                    .foregroundColor(.white)
                    .background(isInputValid() ? Color.blue : Color.gray)
                    .cornerRadius(10)
            }
            .disabled(!isInputValid())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("\(alertTitle)"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            //nur zum Debuggen
            /*
            HStack{
                Text("Passwortsicherheit: \(passwordStrength)")
            }
            */
            
        }
        .padding(.all, 0)
    }
    
    //TODO: Funktionen ins ViewModel übertragen!!!
    
    
    //MARK: CheckMail()
    private func checkMail() {
        
        print("View: Übergebener Username: \(mail)")
        apiManager.checkMail(mail: mail) { exists, message in
            self.mailexists = exists
            self.mailmessage =  message
            
            if exists {
                //self.mailColor = Color.red
                logging("View: Mail existiert")
            } else {
                //self.mailColor = Color.black
                logging("View: mail existiert nicht")
            }
        }
    }
    //MARK: checkUsername()
    private func checkUsername() {
        print("View: Übergebener Username: \(username)")
        apiManager.checkUsername(username: username) { exists, message in
            self.userexists = exists
            self.usermessage = message
            
            if exists {
                logging("View: Benutzername existiert")
                self.usernameColor = Color.red
            } else {
                logging("View: Benutzername existiert nicht")
                self.usernameColor = Color.black
            }
        }
    }
    
    //MARK: isValidMail()
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    
    //MARK: isPasswordValid
    private func isPasswordValid(_ password: String, _ username: String) -> Bool {
        
        logging("isPasswordValid() wurde aufgerufen")
        
        //Passwortanforderungen:
        //Mindestens ein Großbuchstabe ([A-Z])
        //Mindestens ein Kleinbuchstabe ([a-z])
        //Mindestens eine Ziffer ([0-9])
        //Mindestens ein Sonderzeichen ([$@$#!%*?&])
        //Mindestens 8 Zeichen insgesamt ({8,})
        //Darf Username nicht enthalten!
        //Später auch nicht vor/nachnamen etc.
        
        let passwordRegex = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&])(?!.*\(username))[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        var passwordStrength = 0
            
                // Jede erfüllte Bedingung erhöht die Stärke des Passworts
                if password.rangeOfCharacter(from: .uppercaseLetters) != nil {
                    passwordStrength += 2
                }
                if password.rangeOfCharacter(from: .lowercaseLetters) != nil {
                    passwordStrength += 2
                }
                if password.rangeOfCharacter(from: .decimalDigits) != nil {
                    passwordStrength += 2
                }
                if password.rangeOfCharacter(from: CharacterSet(charactersIn: "$@$#!%*?&")) != nil {
                    passwordStrength += 2
                }
        
            self.passwordStrength = passwordStrength // Aktualisiere den Wert der passwordStrength-Variable in der View
        print(self.passwordStrength)
        /*
        let passwordPredicate2 = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        logging("password: \(password)")
        logging("passwordPredicate: \(passwordPredicate.evaluate(with: password))")
        logging("passwordPredicate2: \(passwordPredicate2.evaluate(with: password))")
        logging("passwordStrength: \(passwordStrength)")
        */

        return passwordPredicate.evaluate(with: password)
    }
    /*
    private func isPasswordValid(_ password: String, _ username: String) -> Bool {
        //Passwortanforderungen:
        //Mindestens ein Großbuchstabe ([A-Z])
        //Mindestens ein Kleinbuchstabe ([a-z])
        //Mindestens eine Ziffer ([0-9])
        //Mindestens ein Sonderzeichen ([$@$#!%*?&])
        //Mindestens 8 Zeichen insgesamt ({8,})
        //Darf Username nicht enthalten!
        //Später auch nicht vor/nachnamen etc.
        
        let passwordRegex = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&])(?!.*\(username))[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    */
    
    //MARK: arePasswordsMatching
    private func arePasswordsMatching(_ password: String, _ confirmPassword: String) -> Bool {
        let matching = password == confirmPassword && !password.isEmpty && !confirmPassword.isEmpty
        if matching {
            self.pwForegroundColor = Color.green
        } else {
            self.pwForegroundColor = Color.black
        }
        return matching
    }
    
    //MARK: registerUser()
    private func registerUser() {
        print("registerUser() wird ausgeführt!")
        apiManager.registerUser(username: username, password: password, email: mail) { success, message in
            
            //apiManager.checkfunccall(username: username, password: password, email: mail) { success, message in
            print(success)
            print(message)
            if success {
                showAlert = true
                let apimessage = "API-Key: \(message)"
                alertMessage = apimessage
                alertTitle = "Erfolg!"
                
                
            } else {
                DispatchQueue.main.async {
                    showAlert = true
                    alertMessage = message
                    alertTitle = "Fehler!"
                }
            }
            print("nach dem ApiAufruf!")
            
        }
    }
    
    //MARK: isInputValid
    private func isInputValid() -> Bool {
        return !username.isEmpty && !mail.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && isEmailValid && isPasswordValid && arePasswordsMatching
    }
    
    //MARK: calcPasswordIndicator
    private func calcPasswordIndicator(){
        
        switch password.count{
            
        case 0:
            pwindicatorlength = 10
        case 1:
            pwindicatorlength = 40
        case 2:
            pwindicatorlength = 80
        case 3:
            pwindicatorlength = 120
        case 4:
            pwindicatorlength = 160
        case 5:
            pwindicatorlength = 200
        case 6:
            pwindicatorlength = 240
        case 7:
            pwindicatorlength = 280
        case 8...99:
            pwindicatorlength = 320
        default:
            pwindicatorlength = 10
            
        }
        
        switch passwordStrength {
        case 0:
            pwindicatorcolor = Color(red: CGFloat(1.0), green: CGFloat(0.0), blue: CGFloat(0.0))
        case 2:
            pwindicatorcolor = Color(red: CGFloat(1.0), green: CGFloat(0.3), blue: CGFloat(0.0))
        case 4:
            pwindicatorcolor = Color(red: CGFloat(1.0), green: CGFloat(0.6), blue: CGFloat(0.0))
        case 6:
            pwindicatorcolor = Color(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.0))
        case 8:
            pwindicatorcolor = Color(red: CGFloat(0.4), green: CGFloat(1.0), blue: CGFloat(0.0))
        default:
            pwindicatorcolor = Color(red: CGFloat(1.0), green: CGFloat(0.0), blue: CGFloat(0.0))
            
        }
    }
    
    private func colorizeForeground(){
        
        if(!mailexists && isEmailValid){
            logging("mailexist(sbt): \(mailexists)")
            logging("ismailvalid(sbt): \(isEmailValid)")
            self.mailColor = Color.black
        } else {
            logging("mailexist(sbf): \(mailexists)")
            logging("ismailvalid(sbf): \(isEmailValid)")
            self.mailColor = Color.red
        }
        
    }
    
    
    
}

struct checkUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        checkUsernameView()
    }
}
