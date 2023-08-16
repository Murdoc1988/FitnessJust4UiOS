//
//  Exercise.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 09.08.23.
//

import Foundation

struct Exercise: Hashable, Codable{
    var eid: Int            //ID
    var ename: String       //Name
    var edesc: String       //Beschreibung
    var eprimusc: String    //Primär trainierter Muskel
    var esecmusc: String    //Sekundär trainierte Muskeln
    var edate: String        //Erstelldatum
    var e_tid: Int          //Zugehöriges Training
    var recount: Int
    
    
    init?(json: [String: Any]) {
        guard let eid = json["eid"] as? Int,
              let ename = json["ename"] as? String,
              let edesc = json["edesc"] as? String,
              let eprimusc = json["eprimusc"] as? String,
              let esecmusc = json["esecmusc"] as? String,
              let edate = json["edate"] as? String,
              let e_tid = json["e_tid"] as? Int,
                let recount = json["recount"] as? Int
                
        else {return nil}
        
        self.eid = eid
        self.ename = ename
        self.edesc = edesc
        self.eprimusc = eprimusc
        self.esecmusc = esecmusc
        self.edate = edate
        self.e_tid = e_tid
        self.recount = recount
    }
    
    init(eid: Int, ename: String, edesc: String, eprimusc: String, esecmusc: String, edate: String, e_tid: Int, recount: Int){
        
        self.eid = eid
        self.ename = ename
        self.edesc = edesc
        self.eprimusc = eprimusc
        self.esecmusc = esecmusc
        self.edate = edate
        self.e_tid = e_tid
        self.recount = recount
        
    }
    
}
