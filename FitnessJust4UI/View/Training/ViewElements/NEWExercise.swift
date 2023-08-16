//
//  NEWExercise.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 18.07.23.
//

import SwiftUI

struct NEWExercise: View {
    @EnvironmentObject private var tvm : TrainingsViewModel
    @State var ename = ""
    @State var e_tid = 0
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                TextField("Exercise", text: $ename)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 120)
                    .padding(.trailing, 0)
            }
            .padding(0)
            
            HStack{
                Spacer()
                Button(action: {
                    if(!ename.isEmpty){
                       tvm.addExercise(exercise: Exercise(eid: 0, ename: ename, edesc: "", eprimusc: "Bizeps", esecmusc: "Trizeps", edate: "", e_tid: e_tid, recount: 0))
                        tvm.getExercise(tid: e_tid)
                        self.ename = ""
                    }}) {
                                Text("save")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.deepPurple)
                                    .cornerRadius(10)
                            }
            }
            
            
            
            
        }
        .padding([.leading, .trailing], 32)
        .padding([.top, .bottom], 4)

    }
}

struct NEWExercise_Previews: PreviewProvider {
    static var previews: some View {
        NEWExercise()
    }
}
