//
//  TrainingsView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 17.07.23.
//

import SwiftUI

struct TrainingsView: View {
    var body: some View {
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
    }
}

struct TrainingsView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingsView()
    }
}
