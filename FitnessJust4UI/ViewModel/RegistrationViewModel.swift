//
//  RegistrationViewModel.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 01.06.23.
//

import SwiftUI

class RegistrationViewModel: ObservableObject {
    @ObservedObject private var apiManager = APIManager()
    
    //Für Fehler- und Hinweismeldung --- hauptsächlich in der Entwicklungsphase
    @Published var showAlert = false                    //Soll der Alert angezeigt werden
    @Published var alertMessage = ""                    //Nachricht im Alert
    @Published var alertTitle = ""                      //Titel des Alerts
    let infoTime = DispatchTimeInterval.seconds(2)      //Dauer, die ein Alert angezeigt wird
    
    //Für checkUsername()
    @Published var username = ""
    @Published var usernameColor = Color.black          //Textfarbe für den Nutzernamen-Eingabe (wird rot, wenn Nutzer existiert)
    @Published private var userExists = false           //Rückgabewert der API, ob der Nutzername existiert
    @Published private var userMessage = ""             //Rückgabewert der API, für Fehlerauswertung
    
    //Für checkMail()
    @Published var mail = ""
    @Published var mailColor = Color.black              //Textfarbe für den EMail-Eingabe (wird rot, wenn EMail existiert)
    @Published private var mailExists = false           //Rückgabewert der API, ob die E-Mail bereits existiert
    @Published private var mailMessage = ""             //Rückgabewert, für Fehlerauswertung
    
    //Für isValidPassword isMatchPassword
    @Published var firstPassword = ""                   //Passworteingabe
    @Published var secondPassword = ""                  //Passworteingabe wiederholen
    @Published var fpwColor = Color.black               //Foregroundcolor der Passworteingabe
    @Published var spwColor = Color.black               //Foregroundcolor der Passwortwiederholung
    @Published var pwIndicatorColor = Color(red: CGFloat(1.0), green: CGFloat(0.0), blue: CGFloat(0.0))
    @Published var pwIndicatorLength = 10               //Farbcodierung und -länge für den Passwortindicator
    @Published var pwIndicatorBG = Color(red: CGFloat(0.9), green: CGFloat(0.9), blue: CGFloat(0.9))
    @Published private var passwortMessage = ""         //Rückgabewert, für Fehlerauswertung
    @Published var passwordStrength = 0                     //Passwortstärke
    
    //Für Button zur nächsten Seite, wenn alle eingegebenen Daten validiert sind
    @Published var allValid = false
    @Published private var isUsernameValid = false
    @Published private var isMailValid = false
    @Published private var isPasswordValid = false
    
    //Für die Hint-Bubble
    @Published var hintPosition: CGFloat = 144
    @Published var showHint = false
    @Published var hints: [HintText] = []

    //logging for Debugging
    public let logging: (String) -> Void = { message in
        
        var logString = "RegistrationViewModel: \(message)"
        
        Logger.shared.log(message: logString)
        
    }
    
    //MARK: checkUsername()
    //Check via API ob der Nutzername bereits vergeben ist.
    //true -> vergeben
    //false -> nicht vergeben
    func checkUsername() {
        
        self.logging("Übergebener Username: \(self.username)")
        
        apiManager.checkUsername(username: username) { exists, message in
            
            //Im Hauptstread ausführenm, damit erst nach API-Ende die Werte
            //übernommen werden und wenn alle Werte gesetzt wurden, die View
            //aktualisiert wird (Die Main-Queue ist der Thread, auf dem die
            //Benutzeroberfläche in den meisten App-Frameworks aktualisiert
            //wird.)
            DispatchQueue.main.async {
                
                self.userExists = exists
                
                self.userMessage = message
                
                self.logging("Anwort des Servers: \(message)")
                
                if exists {
                    //Debugging
                    self.logging("Benutzername existiert")
                    
                    //Schriftfarbe/ForegroundColor ändern
                    self.usernameColor = Color.red
                    
                    //TODO: Auf dem Server prüfen, ob Namensrichtlinien eingehalten wurden (Verbotene Worte etc)
                    
                    //InfoAlert bauen
                    //self.alertMessage = self.userMessage
                    //self.alertTitle = "Info:"
                    //InfoAlert anzeigen
                    //self.showAlert = true
                    
                    //Hint bauen
                    self.hintPosition = CGFloat(148)
                    self.hints.removeAll()
                    self.hints.append(HintText(text: "Benutzername existiert bereits!", color: "red"))
                    self.showHint = true
                    
                    
                    //InfoAlert nach einer Sekunde wieder Schließen
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.infoTime) {
                        
                        //self.showAlert = false
                        
                        self.showHint = false
                        
                        //TODO: Warum ändert sich kurzfristig die Farbe mit anzeigen des Alerts?
                        
                        self.usernameColor = Color.red
                    }
                    
                    self.isUsernameValid = false
                    
                } else {
                    
                    //Debugging
                    self.logging("Benutzername existiert nicht")
                    
                    //Farbe wieder auf schwarz setzen
                    self.usernameColor = Color.black
                    
                    self.isUsernameValid = true
                    
                }
            }
        }
        self.isAllValid()
    }
    
    //MARK: checkMail()
    func checkMail() {
        
        self.logging("View: Übergebener Username: \(mail)")
        
        apiManager.checkMail(mail: mail) { exists, message in
            DispatchQueue.main.async {
                
                self.mailExists = exists
                
                self.mailMessage =  message
                
                if exists {
                    self.logging("Benutzer existiert")
                    
                    self.mailColor = Color.red
                    
                    /*
                    self.alertMessage = self.mailMessage
                    self.alertTitle = "Info:"
                    self.showAlert = true
                    */
                    
                    //Hint bauen
                    self.hintPosition = CGFloat(200)
                    self.hints.removeAll()
                    self.hints.append(HintText(text: "E-Mail existiert bereits!", color: "red"))
                    self.showHint = true
                    
                    self.isMailValid = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.infoTime) {
                        
                        //self.showAlert = false
                        
                        self.showHint = false
                        
                        //TODO: siehe checkUsername()
                        
                        self.mailColor = Color.red
                    }
                    
                    
                } else {
                    
                    self.logging("View: mail existiert nicht")
                    
                    self.mailColor = Color.black
                    
                    
                    
                }
                
            }
        }
        self.isAllValid()
    }
    
    //MARK: isValidMail
    func isValidMail(){
        self.logging("isValidMail() wurde aufgerufen!")
        
        //Aufbau einer E-Mail-Adresse
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        let isValid = emailPredicate.evaluate(with: mail)
        
        if !isValid {
            
            logging("Mail entspricht Mailformat!")
            
            self.mailColor = Color.red
            /*
            self.alertMessage = "Die E-Mail-Adresse ist ungültig!"
            self.alertTitle = "Info:"
            //deaktiviert, da .onSubmit nicht wie erwartet funktionert
            //self.showAlert = true
            */
            
            //Hint bauen
            self.hintPosition = CGFloat(200)
            self.hints.removeAll()
            self.hints.append(HintText(text: "Die E-Mail-Adresse ist ungültig!", color: "red"))
            self.showHint = true
            
            self.isMailValid = false
            
            self.isAllValid()
            
            DispatchQueue.main.async {
            
                //self.showAlert = false
                
                self.showHint = false
                
                //TODO: siehe checkUsername()
                
                self.mailColor = Color.red
                
            }
            
        } else{
            
            logging("Mail entspricht Mailformat!")
            
            if(!self.mailExists){
                
                self.mailColor = Color.black
            
                DispatchQueue.main.async {
                
                    self.isMailValid = true
                    
                    self.logging("isMailValid auf true gesetzt!")
                    
                    self.isAllValid()
                    
                }
            }
        }
        
        self.isAllValid()
        
    }
    
    //MARK: isValidPassword
    func isValidPassword(){
        
        
        var passwordStrength = 0
            
                // Jede erfüllte Bedingung erhöht die Stärke des Passworts
                if firstPassword.rangeOfCharacter(from: .uppercaseLetters) != nil {
                    passwordStrength += 2
                    logging("PSP: UC: \(passwordStrength)")
                }
                if firstPassword.rangeOfCharacter(from: .lowercaseLetters) != nil {
                    passwordStrength += 2
                    logging("PSP: LC: \(passwordStrength)")
                }
                if firstPassword.rangeOfCharacter(from: .decimalDigits) != nil {
                    passwordStrength += 2
                    logging("PSP: DD: \(passwordStrength)")
                }
                if firstPassword.rangeOfCharacter(from: CharacterSet(charactersIn: "$@$#!%*?&.")) != nil {
                    passwordStrength += 2
                    logging("PSP: CS: \(passwordStrength)")
                }
                if !firstPassword.contains(self.username) {
                    passwordStrength += 2
                    logging("PSP: UN: \(passwordStrength)")
                }
        
        self.passwordStrength = passwordStrength
        
        logging("PSP: gespeicherte Passwortstärke: \(self.passwordStrength)")
        
        switch firstPassword.count{
            
            case 0:
                self.pwIndicatorLength = 10
            
            case 1:
                self.pwIndicatorLength = 40
            
            case 2:
                self.pwIndicatorLength = 80
            
            case 3:
                self.pwIndicatorLength = 120
            
            case 4:
                self.pwIndicatorLength = 160
            
            case 5:
                self.pwIndicatorLength = 200
            
            case 6:
                self.pwIndicatorLength = 240
            
            case 7:
                self.pwIndicatorLength = 280
            
            case 8...99:
                self.pwIndicatorLength = 320
            
            default:
                self.pwIndicatorLength = 10
            
        }
        
        switch self.passwordStrength {
            
            case 0:
                self.pwIndicatorColor = Color(red: CGFloat(1.0), green: CGFloat(0.0), blue: CGFloat(0.0))
            
            case 2:
                self.pwIndicatorColor = Color(red: CGFloat(1.0), green: CGFloat(0.3), blue: CGFloat(0.0))
            
            case 4:
                self.pwIndicatorColor = Color(red: CGFloat(1.0), green: CGFloat(0.6), blue: CGFloat(0.0))
            
            case 6:
                self.pwIndicatorColor = Color(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.0))
            
            case 8:
                self.pwIndicatorColor = Color(red: CGFloat(0.6), green: CGFloat(0.8), blue: CGFloat(0.0))
            
            case 10:
                self.pwIndicatorColor = Color(red: CGFloat(0.0), green: CGFloat(1.0), blue: CGFloat(0.0))
            
            default:
                self.pwIndicatorColor = Color(red: CGFloat(1.0), green: CGFloat(0.0), blue: CGFloat(0.0))
            
                self.logging("Fehler bei Ermittlung der Passwortstärke: \(self.passwordStrength)")
            
        }
        
        self.spwColor = Color.black
        
        self.isAllValid()
        
    }
    
    //MARK: isMatchPassword
    func isMatchPassword(){
        
        if(self.firstPassword == self.secondPassword){
            
            logging("Passwörter sind gleich")
            
            /*
            self.fpwColor = Color(red: CGFloat(0.4), green: CGFloat(1.0), blue: CGFloat(0.0))
            self.spwColor = Color(red: CGFloat(0.4), green: CGFloat(1.0), blue: CGFloat(0.0))
            */
            
            self.spwColor = Color(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0))
            
            self.pwIndicatorBG = Color(red: CGFloat(0.4), green: CGFloat(1.0), blue: CGFloat(0.0))
            
            logging("MP: passwortStrength: \(self.passwordStrength)")
            
            if(self.passwordStrength == 10) {
            
                self.isPasswordValid = true
                
            }
            
            
        } else {
            
            logging("Passwörter sind NICHT gleich")
            
            self.spwColor = Color(red: CGFloat(1.0), green: CGFloat(0.0), blue: CGFloat(0.0))
            
            self.pwIndicatorBG = Color(red: CGFloat(0.9), green: CGFloat(0.9), blue: CGFloat(0.9))
            
            self.isPasswordValid = false
            
        }
        
        self.isAllValid()
        
    }
    
    func isAllValid(){
        
        if(self.isMailValid && self.isPasswordValid && self.isUsernameValid && !self.mailExists)
        {
            self.allValid = true
            logging("allValid: \(self.allValid)")
        }
        else {
            logging("isMailValid: \(self.isMailValid)")
            logging("isPasswordValid: \(self.isPasswordValid)")
            logging("isUsernameValid: \(self.isUsernameValid)")
            logging("mailExists: \(self.mailExists)")
            
            self.allValid = false
            
        }
    }
    
    
    //MARK: showPasswordHint
    func showPasswordHint(){
        
        self.hintPosition = CGFloat(264)
        
        self.hints.removeAll()
        
        //TODO: einkürzen!!!
        if(!firstPassword.isEmpty){
        
            if firstPassword.count < 8 {
            
                self.hints.append(HintText(text: "- mindestens 8 Zeichen lang", color: "green"))
                
                logging("PSP: UC: \(passwordStrength)")
                
            }else{
                
                self.hints.append(HintText(text: "- mindestens 8 Zeichen lang", color: "red"))
                
            }
            
            if firstPassword.rangeOfCharacter(from: .uppercaseLetters) != nil {
                
                self.hints.append(HintText(text: "- mindestens ein Großbuchstabe", color: "green"))
                
                logging("PSP: UC: \(passwordStrength)")
                
            }else{
                
                self.hints.append(HintText(text: "- mindestens ein Großbuchstabe", color: "red"))
                
            }
            
            if firstPassword.rangeOfCharacter(from: .lowercaseLetters) != nil {
                
                self.hints.append(HintText(text: "- mindestens ein Kleinbuchstabe", color: "green"))
                
            }else{
                
                self.hints.append(HintText(text: "- mindestens ein Kleinbuchstabe", color: "red"))
                
            }
            
            if firstPassword.rangeOfCharacter(from: .decimalDigits) != nil {
                
                self.hints.append(HintText(text: "- mindestens eine Zahl (0-9)", color: "green"))
                
            }else{
                
                self.hints.append(HintText(text: "- mindestens eine Zahl", color: "red"))
                
            }
            
            if firstPassword.rangeOfCharacter(from: CharacterSet(charactersIn: "$@$#!%*?&.")) != nil {
                
                self.hints.append(HintText(text: "- mindestens ein Sonderzeichen ($@$#!%*?&.)", color: "green"))
                
            }else{
                
                self.hints.append(HintText(text: "- mindestens ein Sonderzeichen ($@$#!%*?&.)", color: "red"))
                
            }
            
            if !firstPassword.contains(self.username) {
                
                self.hints.append(HintText(text: "- darf den Nutzernamen nicht enthalten!", color: "green"))
                
            }else{
                
                self.hints.append(HintText(text: "- darf den Nutzernamen nicht enthalten!", color: "red"))
                
            }
        } else {
            
            self.hints.append(HintText(text: "- mindestens 8 Zeichen lang", color: "black"))
            
            self.hints.append(HintText(text: "- mindestens ein Großbuchstabe", color: "black"))
            
            self.hints.append(HintText(text: "- mindestens ein Kleinbuchstabe", color: "black"))
            
            self.hints.append(HintText(text: "- mindestens eine Zahl (0-9)", color: "black"))
            
            self.hints.append(HintText(text: "- mindestens ein Sonderzeichen ($@$#!%*?&.)", color: "black"))
            
            self.hints.append(HintText(text: "- darf den Nutzernamen nicht enthalten!", color: "black"))
            
        }
        
        self.showHint = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.infoTime) {
        
            self.showHint = false
            
        }
        
    }
    
    //MARK: showPasswordDissmatch
    func showPasswordDismatch(){
        
        self.hintPosition = CGFloat(368)
        
        self.hints.removeAll()
        
        if(!secondPassword.isEmpty){
            
            if(firstPassword != secondPassword){
                
                if(firstPassword != secondPassword){
                    
                    self.hints.append(HintText(text: "Passworter stimmen nicht überein!", color: "red"))
                    
                } else {
                    
                    self.hints.append(HintText(text: "Passworter stimmen überein!", color: "green"))
                    
                }
                
            }
            
        }else{
            
            self.hints.append(HintText(text: "Bitte das Passwort erneut eingeben!", color: "black"))
            
        }
        
        self.showHint = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.infoTime) {
            
            self.showHint = false
            
        }
        
    }
}
