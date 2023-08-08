//
//  FrequenzyView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 24.07.23.
//

import SwiftUI

struct FrequenzyView: View {
    
    @State var periodOneUD: String
    @State var periodTwoUD: String
    @State var selectedUnitIndex: Int = 0
    @State var selectedValueIndex: Int = 0
    
    
    let timeUnits = ["Tag", "Woche", "Monat", "Jahr"]
    let maxValues: [Int] = [31, 52, 12, 10]
    
    init(periodOneUD: String, periodTwoUD: String) {
        self.periodOneUD = periodOneUD
        self.periodTwoUD = periodTwoUD
        _selectedUnitIndex = State(initialValue: UserDefaults.standard.integer(forKey: periodOneUD))
        _selectedValueIndex = State(initialValue: UserDefaults.standard.integer(forKey: periodTwoUD))
    }
    
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
        .onChange(of: selectedUnitIndex) { newValue in
                   UserDefaults.standard.set(newValue, forKey: periodOneUD)
               }
        .onChange(of: selectedValueIndex) { newValue in
                   UserDefaults.standard.set(newValue, forKey: periodTwoUD)
               }

        
        
    }
}

/*
 struct FrequenzyView_Previews: PreviewProvider {
 static var previews: some View {
 FrequenzyView()
 }
 }
 */
