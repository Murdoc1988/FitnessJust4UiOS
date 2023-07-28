//
//  TextEdit.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 24.07.23.
//

import SwiftUI

struct TextEdit: View {
    @State var inputText = ""
    var body: some View {
        
        VStack{
            HStack{
                Text("Name:")
                Spacer()
                TextField("Name", text: $inputText)
                    .frame(width: 200.0)
                    .textFieldStyle(.roundedBorder)
            }
            .padding([.trailing, .leading], 32)
            .padding([.top, .bottom], 8)
            
            Divider()
                .padding([.trailing, .leading], 16 )
        }
        
    }
}

struct TextEdit_Previews: PreviewProvider {
    static var previews: some View {
        TextEdit()
    }
}
