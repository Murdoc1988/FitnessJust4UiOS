//
//  Training.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 09.08.23.
//

import Foundation

struct Training: Hashable{
    var tid: Int        //ID
    var tname: String   //Name
    var tdesc: String   //Beschreibung
    var tdate: String     //Erstelldatum
    
    init?(json: [String: Any]) {
            guard let tid = json["tid"] as? Int,
                  let tname = json["tname"] as? String,
                  let tdesc = json["tdesc"] as? String,
                  let tdate = json["tdate"] as? String // oder String
            else { return nil }
            
            self.tid = tid
            self.tname = tname
            self.tdesc = tdesc
            self.tdate = tdate
        }
}
