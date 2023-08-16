//
//  Rep.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 14.08.23.
//

import Foundation

struct Rep: Hashable, Codable{
        var rid: Int
        var rweight: Int
        var rreps: Int
        var rdate: String
        var r_eid: Int
    
    init?(json: [String: Any]) {
        guard let rid = json["rid"] as? Int,
              let rweight = json["rweight"] as? Int,
              let rreps = json["rreps"] as? Int,
              let rdate = json["rdate"] as? String,
              let r_eid = json["r_eid"] as? Int
                
        else {return nil}
        
        self.rid = rid
        self.rweight = rweight
        self.rreps = rreps
        self.rdate = rdate
        self.r_eid = r_eid
    }
    
    init(rid: Int, rweight: Int, rreps: Int, rdate: String, r_eid: Int){
        
        self.rid = rid
        self.rweight = rweight
        self.rreps = rreps
        self.rdate = rdate
        self.r_eid = r_eid
        
    }
        
}
