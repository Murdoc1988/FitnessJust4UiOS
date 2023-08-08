//
//  MeasurementView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 08.08.23.
//

import SwiftUI

struct MeasurementView: View {
    var body: some View {
        
        List{
            NewMesurement(labelText:"Weight", userDefault: "CurrentWeight", unit: "Kg")
            NewMesurement(labelText:"Water", userDefault: "CurrentWater", unit: "%")
            NewMesurement(labelText: "Muscle", userDefault: "CurrentMuscle", unit: "%")
        }
        
    }
}
