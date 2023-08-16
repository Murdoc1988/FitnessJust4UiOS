//
//  BodyLog.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 09.08.23.
//

import Foundation

struct BodyLog {
    var bid: Int
    var bdate: String // Datum als String speichern
    var b_uid: Int
    var bbody_fat: Double
    var bmuscle_mass: Double
    var bwater_content: Double
    var bweight: Double
    
    init?(json: [String: Any]) {
        guard let bid = json["bid"] as? Int,
            let bdate = json["bdate"] as? String, // Datum direkt als String erhalten
            let b_uid = json["b_uid"] as? Int,
            let bbody_fat = json["bbody_fat"] as? Double,
            let bmuscle_mass = json["bmuscle_mass"] as? Double,
            let bwater_content = json["bwater_content"] as? Double,
            let bweight = json["bweight"] as? Double
        else {
            return nil
        }
        
        self.bid = bid
        self.bdate = bdate
        self.b_uid = b_uid
        self.bbody_fat = bbody_fat
        self.bmuscle_mass = bmuscle_mass
        self.bwater_content = bwater_content
        self.bweight = bweight
    }
}

