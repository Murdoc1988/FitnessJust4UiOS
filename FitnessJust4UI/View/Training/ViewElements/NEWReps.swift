//
//  NEWReps.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 18.07.23.
//

import SwiftUI

struct NEWReps: View {
    @EnvironmentObject private var tvm : TrainingsViewModel
    @State var r_eid = 0
    var body: some View {
        VStack{
            
            Button(action: {
                tvm.addRep(eid: r_eid)
                tvm.getReps(eid: r_eid)
            }) {
                Text("add")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.deepPurple)
                    .cornerRadius(10)
            }
        }
    }
}
