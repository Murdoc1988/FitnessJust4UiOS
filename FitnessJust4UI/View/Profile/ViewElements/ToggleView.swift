//
//  ToggleView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 24.07.23.
//

import SwiftUI

struct ToggleView: View {
    
    @State var labelText: String
    @State var userDefault: String
    @State var toggleState: Bool
    @State var periodOneUD: String
    @State var periodTwoUD: String
    
    init(labelText: String, userDefault: String, periodOneUD: String, periodTwoUD: String) {
        
        self.labelText = labelText
        self.userDefault = userDefault
        self.periodOneUD = periodOneUD
        self.periodTwoUD = periodTwoUD
        _toggleState = State(initialValue: UserDefaults.standard.bool(forKey: userDefault))
        
    }
    
    var body: some View {
        VStack(spacing: 4){
            Toggle("\(labelText):", isOn: $toggleState)
                .disabled(false)
                .padding([.trailing, .leading], 32)
                .padding([.top, .bottom], 0)
                
            
            if(toggleState){
                HStack(spacing: 4){
                    FrequenzyView(periodOneUD: periodOneUD, periodTwoUD: periodTwoUD)
                        .padding(0)
                }            }
            
            Divider()
                .padding([.trailing, .leading], 8 )
                .padding([.top, .bottom], 4)
        }
        .padding(0)
        .onChange(of: toggleState) { newValue in
                   UserDefaults.standard.set(newValue, forKey: userDefault)
               }
    }
}

/*
 struct ToggleView_Previews: PreviewProvider {
 static var previews: some View {
 ToggleView()
 }
 }
 */
