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
    
    @AppStorage("username")var user: String = "Gast"
    @AppStorage("apiToken")var apiToken: String = ""
    var success = false
    var error = ""
    @Published var trainingsList: [Training] = []
    @Published var exerciseList: [Exercise] = []
    @Published var repsList: [Rep] = []
    
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
                
                
                //print("Ausm ViewModel: \(trainingsList)")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.success = success
                self.error = error
                self.trainingsList = trainingsList
                
                //print("Ausm Viewmodel 2: \(trainingsList)")
                  //  print("Ausm Viemodel die var: \(self.trainingsList)")
                
            }
        }
        //print("Ausm Viewmodel 3: \(trainingsList)")
    }

    func addTraining(training: Training){
        self.logging("addTraining aufgerufen.")
        
        self.apiManager.addTraining(username: self.user, apiToken: self.apiToken, training: training){ success, error in
        

        //TODO: Fehlerbehandlung!
        
        }
        
        self.getTraining()
         
        
    }
    
    func getExercise(tid: Int){
        
        self.apiManager.getExercise(username: self.user, apiToken: self.apiToken, tid: tid){success, error, exerciseList in
            
            
            //print("Ausm ViewModel: \(trainingsList)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.success = success
                self.error = error
                self.exerciseList = exerciseList
                
                //print("Ausm Viewmodel 2: \(trainingsList)")
                //  print("Ausm Viemodel die var: \(self.trainingsList)")
                
            }
        }
        
        
    }
    
    func addExercise(exercise: Exercise){
        self.logging("addExercise aufgerufen.")
        
        self.apiManager.addExercise(username: self.user, apiToken: self.apiToken, exercise: exercise){ success, error in
            self.getExercise(tid: exercise.e_tid)

        //TODO: Fehlerbehandlung!
        
        }
        
        self.getTraining()
         
        
    }
    
    func getReps(eid: Int){
        
        self.apiManager.getReps(username: self.user, apiToken: self.apiToken, eid: eid) {success, error, repsList in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.success = success
                self.error = error
                self.repsList = repsList
                
            }
        }
    }
    
    func addRep(eid: Int){
        self.logging("addRep aufgerufen.")
        
        self.apiManager.addRep(username: self.user, apiToken: self.apiToken, eid: eid) { success, error in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                
                self.success = success
                self.error = error
                
            }
            
        }
    }
    
}
