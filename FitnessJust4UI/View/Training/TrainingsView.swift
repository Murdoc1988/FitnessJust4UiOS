//
//  TrainingsView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 17.07.23.
//

import SwiftUI

struct TrainingsView: View {
    var body: some View {
        
        List{
            VStack{
                LETraining()
                LETraining()
                LETraining()
                LETraining()
                LETraining()
                LETraining()
                LETraining()
                LETraining()
                NEWTraining()
            }
            .padding(.top, 0)
            .padding(.horizontal, 0)
        }
        .padding(.top, 0)
        .padding(.horizontal, 0)
    }
}

struct TrainingsView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingsView()
    }
}
