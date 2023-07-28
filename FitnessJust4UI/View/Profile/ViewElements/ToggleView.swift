//
//  ToggleView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 24.07.23.
//

import SwiftUI

struct ToggleView: View {
    @State var toggleState = true
    var body: some View {
        VStack(spacing: 4){
            Toggle("Gewicht:", isOn: $toggleState)
                .disabled(false)
                .padding([.trailing, .leading], 32)
                .padding([.top, .bottom], 0)
                
            
            if(toggleState){
                HStack(spacing: 4){
                    FrequenzyView()
                        .padding(0)
                }            }
            
            Divider()
                .padding([.trailing, .leading], 8 )
                .padding([.top, .bottom], 4)
        }
        .padding(0)
    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView()
    }
}
