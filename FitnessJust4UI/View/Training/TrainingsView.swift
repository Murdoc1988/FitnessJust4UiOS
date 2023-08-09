//
//  TrainingsView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 17.07.23.
//

import SwiftUI

struct TrainingsView: View {
    @ObservedObject private var tvm = TrainingsViewModel()
    @State var trainingsList: [String]
    
    init(){
        self.trainingsList = TrainingsViewModel().trainingsList
    }
    var body: some View {
        
        NavigationStack{
            List{
                ForEach(trainingsList, id: \.self) { training in
                    NavigationLink(destination: ExerciseView()) {
                        LETraining()
                    }
                    
                }
                NEWTraining()
            }
            .navigationTitle("Deine Trainingsliste")
            
            //NEWTraining()
            
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
