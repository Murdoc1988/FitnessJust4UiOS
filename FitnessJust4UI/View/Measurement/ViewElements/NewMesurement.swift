//
//  NewMesurement.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 08.08.23.
//

import SwiftUI

struct NewMesurement: View {
    @State var labelText: String
    @State var userDefault: String
    @State var unit: String
    @State var inputText: String
    
    init(labelText: String, userDefault: String, unit: String) {
        self.labelText = labelText
        self.userDefault = userDefault
        self.unit = unit
        _inputText = State(initialValue: UserDefaults.standard.string(forKey: userDefault) ?? "")
    }
    
    var body: some View {
        
        VStack{
            HStack{
                Text("\(labelText) (in \(unit)):")
                Spacer()
                TextField("\(labelText)", text: $inputText//, onCommit: {
                    //UserDefaults.standard.set(inputText, forKey: userDefault)
                //}
                )
                .frame(width: 100.0)
                .textFieldStyle(.roundedBorder)
                .onChange(of: inputText) { new in
                    UserDefaults.standard.set(new, forKey: userDefault)
                }
                
            }
            .padding([.trailing, .leading], 8)
            .padding([.top, .bottom], 8)
            
            Divider()
                .padding([.trailing, .leading], 16 )
        }
        
    }
}
