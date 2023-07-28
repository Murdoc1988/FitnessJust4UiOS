//
//  FrequenzyView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 24.07.23.
//

import SwiftUI

struct FrequenzyView: View {
    
    @State private var selectedUnitIndex = 0
    @State private var selectedValueIndex = 0
    
    let timeUnits = ["Tag", "Woche", "Monat", "Jahr"]
    let maxValues: [Int] = [31, 52, 12, 10]
    
    var body: some View {
        
        VStack(spacing: 4){
            HStack(spacing: 4) {
                
                Text("jeden")
                
                Picker(selection: $selectedValueIndex, label: Text("Wert")) {
                    ForEach(1...maxValues[selectedUnitIndex], id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                
                Picker(selection: $selectedUnitIndex, label: Text("Einheit")) {
                    ForEach(0..<timeUnits.count, id: \.self) { index in
                        Text(timeUnits[index]).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            .padding([.top, .bottom], 0)
        }
        .padding([.trailing, .leading], 40)
        .padding([.top, .bottom], 0)
        .frame(height: 48)

        
        
    }
}

struct FrequenzyView_Previews: PreviewProvider {
    static var previews: some View {
        FrequenzyView()
    }
}
