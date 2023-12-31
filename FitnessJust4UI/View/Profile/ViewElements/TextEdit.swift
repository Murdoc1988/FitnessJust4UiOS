//
//  TextEdit.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 24.07.23.
//

import SwiftUI

struct TextEdit: View {
    @State var labelText: String
    @State var userDefault: String
    @State var inputText: String
    
    init(labelText: String, userDefault: String) {
            self.labelText = labelText
            self.userDefault = userDefault
            _inputText = State(initialValue: UserDefaults.standard.string(forKey: userDefault) ?? "")
        }
    
    var body: some View {
        
        VStack{
            HStack{
                Text("\(labelText):")
                Spacer()
                TextField("Name", text: $inputText//, onCommit: {
                    //UserDefaults.standard.set(inputText, forKey: userDefault)
                //}
                )
                .frame(width: 200.0)
                .textFieldStyle(.roundedBorder)
                .onChange(of: inputText) { new in
                    UserDefaults.standard.set(new, forKey: userDefault)
                }
                
            }
            .padding([.trailing, .leading], 32)
            .padding([.top, .bottom], 8)
            
            Divider()
                .padding([.trailing, .leading], 16 )
        }
        
    }
}
/*
 struct TextEdit_Previews: PreviewProvider {
 static var previews: some View {
 TextEdit()
 }
 }
 */
