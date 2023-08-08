//
//  ToggleSettingsView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 08.08.23.
//

import SwiftUI

struct ToggleSettingsView: View {
    
    
    
    @State var labelText: String
    @State var userDefault: String
    @State var toggleState: Bool
    
    init(labelText: String, userDefault: String){
        
        self.self.labelText = labelText
        self.userDefault = userDefault
        _toggleState = State(initialValue: UserDefaults.standard.bool(forKey: userDefault))
        
    }
    
    var body: some View {
        VStack(spacing: 4){
            Toggle("\(labelText):", isOn: $toggleState)
                .disabled(false)
                .padding([.trailing, .leading], 32)
                .padding([.top, .bottom], 0)
        }
        .padding(0)
        .onChange(of: toggleState) { newValue in
                   UserDefaults.standard.set(newValue, forKey: userDefault)
               }
    }
}

/*
 struct ToggleSettingsView_Previews: PreviewProvider {
 static var previews: some View {
 ToggleSettingsView()
 }
 }
 */
