//
//  TrainingsView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 17.07.23.
//

import SwiftUI

struct TrainingsView: View {
    @EnvironmentObject var tvm : TrainingsViewModel
    
    //init(){
    //  self.trainingsList = TrainingsViewModel().trainingsList
    //}
    var body: some View {
        
        NavigationStack{
            List{
                ForEach(tvm.trainingsList, id: \.self) { training in
                    NavigationLink(destination: ExerciseView(tid: training.tid).environmentObject(tvm)) {
                        LETraining(training: training.tname, exerices: training.tecount, time: 60)
                    }
                    
                }
                NEWTraining()
            }
            .navigationTitle("Deine Trainingsliste")
            .id(tvm.trainingsList)
            
            //NEWTraining()
            
        }
        .padding(.top, 0)
        .padding(.horizontal, 0)
        .environmentObject(tvm)
    }
}

struct TrainingsView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingsView()
    }
}
