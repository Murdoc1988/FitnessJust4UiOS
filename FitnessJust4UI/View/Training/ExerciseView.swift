//
//  ExerciseView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 17.07.23.
//

import SwiftUI

struct ExerciseView: View {
    @EnvironmentObject var tvm : TrainingsViewModel
    var tid: Int
    
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(tvm.exerciseList, id: \.self) { exercise in
                    NavigationLink(destination: RepsView(eid: exercise.eid).environmentObject(tvm)) {
                        LEExercise(ename: exercise.ename, exerices: exercise.recount, time: 18)
                    }
                    
                }
                NEWExercise(ename: "", e_tid: tid)
            }
            .navigationTitle("TrainingXY")
            .id(tvm.exerciseList)
        }
        .padding(.top, 0)
        .padding(.horizontal, 0)
        .environmentObject(tvm)
        .onAppear{
            tvm.getExercise(tid: tid)
        }
    }
}
/*
 struct ExerciseView_Previews: PreviewProvider {
 static var previews: some View {
 ExerciseView()
 }
 }
 */
