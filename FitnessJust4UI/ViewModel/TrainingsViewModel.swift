//
//  TrainingsViewModel.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 08.08.23.
//

import Foundation
import SwiftUI

class TrainingsViewModel : ObservableObject{
    @ObservedObject private var apiManager = APIManager()
    
    var user = "benutzer1"
    var apiToken = "1234"
    var success = false
    var error = ""
    @Published var trainingsList: [Training] = []
    var exerciseList = ["Exercise1", "Exercise2", "Exercise3", "Exercise4", "Exercise5"]
    var repsList = ["Rep1", "Rep2", "Rep3"]
    
    public let logging: (String) -> Void = { message in
        
        var logString = "TrainingsViewModel: \(message)"
        
        Logger.shared.log(message: logString)
        
    }
    
    init(){
        getTraining()
    }
    
    func getTraining(){
        self.logging("getTraining() aufgerufen.")
        
            self.apiManager.getTraining(username: self.user, apiToken: self.apiToken){success, error, trainingsList in
                
                
                print("Ausm ViewModel: \(trainingsList)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.success = success
                self.error = error
                self.trainingsList = trainingsList
                
                print("Ausm Viewmodel 2: \(trainingsList)")
                    print("Ausm Viemodel die var: \(self.trainingsList)")
                
            }
        }
        print("Ausm Viewmodel 3: \(trainingsList)")
    }
    
    
    
}
