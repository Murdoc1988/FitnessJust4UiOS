//
//  LogInViewModel.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 26.06.23.
//

import Foundation
import SwiftUI

class LogInViewModel: ObservableObject {
    @ObservedObject private var apiManager = APIManager()
    private var verify = false           //Rückgabewert der API, ob der Nutzername existiert
    private var apiToken = ""
    
    public let logging: (String) -> Void = { message in
        
        var logString = "LogInViewModel: \(message)"
        
        Logger.shared.log(message: logString)
        
    }
    
    func authUser(username: String, password: String){
        
        apiManager.authUser(username: username, password: password) {
            verify, apiToken in
            
            //Im Hauptstread ausführen, damit erst nach API-Ende die Werte
            //übernommen werden und wenn alle Werte gesetzt wurden, die View
            //aktualisiert wird (Die Main-Queue ist der Thread, auf dem die
            //Benutzeroberfläche in den meisten App-Frameworks aktualisiert
            //wird.)
            DispatchQueue.main.async {
                
                self.verify = verify
                
                self.apiToken = apiToken
                
                self.logging("Anwort des Servers: \(apiToken)")
                
                if self.verify {
                    
                    UserDefaults.standard.set(apiToken, forKey: apiToken)
                    
                } else {
                    
                }
            }
        }
    }
    
}

