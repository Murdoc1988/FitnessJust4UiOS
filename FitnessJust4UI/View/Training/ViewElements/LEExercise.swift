//
//  LEExercise.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 17.07.23.
//

import SwiftUI

struct LEExercise: View {
    @State var ename = "Exercise"
    @State var exerices = 4
    @State var time = 18
    var body: some View {
        VStack(alignment: .leading){
            
            HStack{
                Text("\(ename)")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            
            Text("\(exerices) Sets")
            
            Text("ca. \(time) min")
            
            //Divider()
            
        }
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 4)
        
        
        
    }
}

struct LEExercise_Previews: PreviewProvider {
    static var previews: some View {
        LEExercise()
    }
}
