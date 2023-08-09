//
//  TrainingsView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 17.07.23.
//

import SwiftUI

struct TrainingsView: View {
    @ObservedObject private var tvm = TrainingsViewModel()
    //var trainingsList: [Training]
    
    //init(){
      //  self.trainingsList = TrainingsViewModel().trainingsList
    //}
    var body: some View {
        
        NavigationStack{
            List{
                ForEach(tvm.trainingsList, id: \.self) { training in
                    NavigationLink(destination: ExerciseView()) {
                        LETraining(training: training.tname, exerices: 18, time: 60)
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
