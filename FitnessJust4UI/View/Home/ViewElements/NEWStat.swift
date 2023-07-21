//
//  NEWStat.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 18.07.23.
//

import SwiftUI

struct NEWStat: View {
    @State var stat = "Gewicht"
    @State var quantity = ""
    @State var unit = "kg"
    
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 320, height: 120)
                    .overlay(
                                   RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.deepPurple, lineWidth: 1)
                               )


                
                VStack(alignment: .leading){
                    HStack{
                        TextField("\(stat)", text: $quantity)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 120)
                            .padding(.trailing, 0)
                        
                        Text("\(unit)")
                            .padding(.leading, 0)
                    }
                    .padding(0)
                    
                    HStack{
                        Spacer()
                        Button(action: {
                                        // Action to be performed when the button is tapped
                                    }) {
                                        Text("eintragen")
                                            .font(.body)
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.deepPurple)
                                            .cornerRadius(10)
                                    }
                    }
                    
                    
                    
                    
                }
                .frame(width: 300)
                
                
                
            }
        }
    }
}

struct NEWStat_Previews: PreviewProvider {
    static var previews: some View {
        NEWStat()
    }
}
