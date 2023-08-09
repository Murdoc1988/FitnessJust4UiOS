//
//  ExerciseView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 17.07.23.
//

import SwiftUI

struct ExerciseView: View {
    @ObservedObject private var tvm = TrainingsViewModel()
    @State var exerciseList: [String]
    
    init(){
        self.exerciseList = TrainingsViewModel().exerciseList
    }

    
    var body: some View {
        NavigationStack{
            List{
                ForEach(exerciseList, id: \.self) { exercise in
                    NavigationLink(destination: RepsView()) {
                        LEExercise()
                    }
                    
                }
                NEWExercise()
            }
            .navigationTitle("TrainingXY")
            //NEWExercise()
        }
        .padding(.top, 0)
        .padding(.horizontal, 0)
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView()
    }
}
