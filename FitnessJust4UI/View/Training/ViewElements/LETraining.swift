//
//  LETraining.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 18.07.23.
//

import SwiftUI

struct LETraining: View {
    @State var training = "Testtraining"
    @State var exerices = 11
    @State var time = 180
    var body: some View {
        VStack(alignment: .leading){
            
            HStack{
                Text("\(training)")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            
            Text("\(exerices) Exercises")
            
            Text("ca. \(time) min")
            
            //Divider()
            
        }
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 4)
        
        
        
    }
}

struct LETraining_Previews: PreviewProvider {
    static var previews: some View {
        LETraining()
    }
}
