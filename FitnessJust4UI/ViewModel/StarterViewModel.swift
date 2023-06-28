//
//  StarterViewModel.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 31.05.23.
//

import Foundation

class StarterViewModel: ObservableObject{
    
    @Published var debuggingOn: Bool
    
    init(debuggingOn: Bool = true){
        self.debuggingOn = debuggingOn
    }
      
    var starterID: Int {
        //Hier wird geprüft,
        //TODO:  -nicht eingeloggt ist (leere shared Preferences)
        //       return 1
        //TODO:  -passwort abgelaufen ist (shared Preferences)
        //       return 2
        //TODO: -AppVersion - neue App Version ist verfügbar
        //      -return 3
        //TODO: -Error
        //      -return 9
        //  je nach Wert wird dann beim Starten der App eine andere View angezeigt(Login/Home/Passwort ändern)
        
        //TODO:  -ob Nutzer bereits eingeloggt ist (shared Preferences)
        //       return 0
        if let _ = UserDefaults.standard.string(forKey: "username") {
            return 1
        }
        
        return 20
    }
    
}
