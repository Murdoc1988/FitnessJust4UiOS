//
//  Logger.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 07.06.23.
//

import Foundation

class Logger {
    static let shared = Logger()  // Singleton-Instanz des Loggers
    var viewModel = StarterViewModel()
    
    func log(message: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let formattedDate = dateFormatter.string(from: Date())
        if(viewModel.debuggingOn){
            print("[\(formattedDate)] \(message)")
        }
    }
}
