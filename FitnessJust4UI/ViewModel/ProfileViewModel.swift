//
//  ProfileViewModel.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 08.08.23.
//

import Foundation

class ProfileViewModel: ObservableObject{
    
    var pfname = UserDefaults.standard.string(forKey: "firstname")
    var plname = UserDefaults.standard.string(forKey: "lastname")
    var pmail = UserDefaults.standard.string(forKey: "mail")
    var isWeight = UserDefaults.standard.string(forKey: "isWeight")
    var pOneWeight = UserDefaults.standard.string(forKey: "periodOneWeight")
    var pTwoWeight = UserDefaults.standard.string(forKey: "periodTwoWeight")
    var isWater = UserDefaults.standard.string(forKey: "isWater")
    var pOneWater = UserDefaults.standard.string(forKey: "periodOneWater")
    var pTwoWater = UserDefaults.standard.string(forKey: "periodTwoWater")
    
    
    
}
