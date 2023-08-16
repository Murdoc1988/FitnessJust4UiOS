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
    @Published var verify = false           //Rückgabewert der API, ob Nutzer angemeldet ist
    @Published var username = ""
    @Published var password = ""
    private var apiToken = ""
    private var error = ""
    
    
    public let logging: (String) -> Void = { message in
        
        var logString = "LogInViewModel: \(message)"
        
        Logger.shared.log(message: logString)
        
    }
    
    func authUser(){
        
        apiManager.getAuth(username: self.username, password: self.password) {
            verify, error, apiToken in
            
            DispatchQueue.main.async {
                
                self.verify = verify
                print("\(self.verify)")
                self.error = error
                
                self.apiToken = apiToken
                
                self.logging("Anwort des Servers: \(apiToken)")
                
                if self.verify {
                    
                    UserDefaults.standard.set(apiToken, forKey: "apiToken")
                    UserDefaults.standard.set(self.username, forKey: "username")
                    
                } else {
                    
                }
            }
        }
    }
    
}

