//
//  NEWExercise.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 18.07.23.
//

import SwiftUI

struct NEWExercise: View {
    @State var training = ""
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                TextField("Exercise", text: $training)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 120)
                    .padding(.trailing, 0)
            }
            .padding(0)
            
            HStack{
                Spacer()
                Button(action: {
                                // Action to be performed when the button is tapped
                            }) {
                                Text("save")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.deepPurple)
                                    .cornerRadius(10)
                            }
            }
            
            
            
            
        }
        .padding([.leading, .trailing], 32)
        .padding([.top, .bottom], 4)

    }
}

struct NEWExercise_Previews: PreviewProvider {
    static var previews: some View {
        NEWExercise()
    }
}
