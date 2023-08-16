//
//  APIResponse.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 14.08.23.
//

import Foundation

struct APIResponse: Codable {
    var success: Bool
    var error: String
    var numRows: Int
    var exercise: [Exercise]
}
