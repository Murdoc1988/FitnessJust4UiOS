//
//  Reg01View.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 16.06.23.
//

import SwiftUI

struct Reg01View: View {
    
    @ObservedObject private var rvm = RegistrationViewModel()
    
    //logging for Debugging
    public let logging: (String) -> Void = { message in
        
        var logString = "View: \(message)"
        
        Logger.shared.log(message: logString)
        
    }
    
    var body: some View {
        
        ZStack(alignment: .top){
            
            NavigationStack{
                
                List{
                    
                    VStack{
                        
                        //MARK: INPUT Benutzername
                        TextField("Benutzername", text: $rvm.username)
                            .autocapitalization(.none)              //damit nicht direkt mit einem Großbuchstaben begonnen wird
                            .disableAutocorrection(true)            //Autokorrektur unterbinden
                            .textFieldStyle(.roundedBorder)
                            .foregroundColor(rvm.usernameColor)     //Foregroundcolor, wird durch VM geändert, wenn Benutzername bereits existiert
                            .padding(.top, 16)
                            .padding(.bottom, 4)
                            .padding([.leading, .trailing], 8)
                            .onChange(of: rvm.username) { newValue in
                                
                                rvm.checkUsername()                 //APICall und Auswertung
                                
                            }
                        //TODO: Schönere Variante für den Hint
                            .alert(isPresented: $rvm.showAlert) {
                                Alert(
                                    title: Text(rvm.alertTitle),
                                    message: Text(rvm.alertMessage),
                                    dismissButton: .default(Text("OK")))
                            }
                        
                        //MARK: INPUT Benutzername
                        TextField("E-Mail", text: $rvm.mail)
                            .autocapitalization(.none)              //damit nicht direkt mit einem Großbuchstaben begonnenw wird
                            .disableAutocorrection(true)            //Autokorrektur unterbinden
                            .textFieldStyle(.roundedBorder)
                            .foregroundColor(rvm.mailColor)         //Foregroundcolor, wird durch VM geändert, wenn Benutzername bereits existiert
                            .padding(.top, 8)
                            .padding(.bottom, 4)
                            .padding([.leading, .trailing], 8)
                            .onChange(of: rvm.mail) { newValue in
                                
                                rvm.checkMail()                     //APICall, Formatprüfung und Auswertung
                                rvm.isValidMail()
                                
                            }
                        //Funktioniert nicht wie erwartet!
                        //TODO: neueLösung für isValidMail()-Visualisierung
                        /*
                         .onSubmit {
                         self.logging(".onSubmit funktioniert! 42")
                         rvm.isValidMail()                   //Prüfung ob die E-Mail im richtigen Format eingegeben wurde
                         
                         }
                         */
                        
                        //MARK: INPUT Passwort
                        SecureField("Password", text: $rvm.firstPassword)
                            .textFieldStyle(.roundedBorder)
                            .padding([.top, .bottom], 16)
                            .padding([.leading, .trailing], 8)
                            .textContentType(.none)                 //AutoFill für das Feld deaktivieren
                            .foregroundColor(rvm.fpwColor)
                            .onChange(of: rvm.firstPassword) { newValue in
                                
                                rvm.isValidPassword()
                                
                                //TODO: wird im ViewModel bei isPasswordValid mit erledigt!
                                //calcPasswordIndicator()
                                
                            }
                            .onTapGesture {
                                
                                rvm.showPasswordHint()
                                
                            }
                        
                        //MARK Passwortindicator
                        VStack{
                            HStack{
                                Spacer()
                                //TODO: PasswordIndicator fixen!
                                ZStack{
                                    
                                    
                                    Rectangle()
                                        .frame(width: 320, height: 24)
                                        .foregroundColor(rvm.pwIndicatorBG)
                                        .cornerRadius(12)
                                    
                                    HStack{
                                        if(rvm.firstPassword.count >= 8){
                                            Spacer()
                                        }
                                        Rectangle()
                                            .frame(width: CGFloat(rvm.pwIndicatorLength), height:12)
                                            .foregroundColor(rvm.pwIndicatorColor)
                                            .cornerRadius(6)
                                            .padding(0)
                                        Spacer()
                                        
                                        
                                    }
                                    .frame(width: 280, height:12)
                                    .padding(0)
                                    
                                    
                                }
                                
                                
                                Spacer()
                            }
                        }
                        
                        
                        //MARK: INPUT Passwortwiederholung
                        SecureField("Password wiederholen", text: $rvm.secondPassword)
                            .textFieldStyle(.roundedBorder)
                            .padding([.top, .bottom], 16)
                            .padding([.leading, .trailing], 8)
                            .textContentType(.none)                 //AutoFill für das Feld deaktivieren
                            .foregroundColor(rvm.spwColor)
                            .onChange(of: rvm.secondPassword) { newValue in
                                
                                rvm.isMatchPassword()
                                
                            }
                            .onTapGesture {
                                
                                rvm.showPasswordDismatch()
                                
                            }
                        
                        Spacer()
                        Spacer()
                        
                        HStack{
                            
                            Spacer()
                            
                            /*
                             if rvm.allValid {
                             NavigationLink("Next", destination: Reg02View())
                             } else {
                             Text("Next")
                             .foregroundColor(.gray)
                             }
                             */
                            Button("Registrieren") {
                                rvm.regUser()
                            }
                            .disabled(!rvm.allValid)
                            
                            NavigationLink("", destination: LoginView(), isActive: $rvm.success)
                                               .opacity(0)
                            
                            
                        }
                        .padding(.trailing, 32)
                    }
                    .navigationBarTitle("Registration")
                }
                
                
                
            }
            if(rvm.showHint){
                HintBubble(texts: rvm.hints)
                    .padding(.top, rvm.hintPosition)
            }
            
        }
    }
}

struct Reg01View_Previews: PreviewProvider {
    static var previews: some View {
        Reg01View()
    }
}
