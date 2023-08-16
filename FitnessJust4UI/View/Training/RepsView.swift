//
//  RepsView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 17.07.23.
//

import SwiftUI

struct RepsView: View {
    @EnvironmentObject var tvm: TrainingsViewModel
    var eid: Int
    @State private var minutes = 1
    @State private var seconds = 30
    @State private var isCountingDown = false
    
    var body: some View {
        
        VStack{
            // Nur die ForEach-Loop innerhalb der List
            
            List{
                if(!tvm.repsList.isEmpty){
                    ForEach(tvm.repsList, id: \.rid) { rep in
                        LEReps(rep: rep).environmentObject(tvm)
                        
                    }
                    
            }
                NEWReps(r_eid: eid)
            }
            
            // RoundedRectangle außerhalb der List, aber immer noch innerhalb von VStack
            RoundedRectangle(cornerRadius: 24)
             .frame(width: 320, height: 320)
             .foregroundColor(.green)
             .overlay(
             HStack {
             Spacer()
             TextField("0", value: $minutes, formatter: NumberFormatter(), onCommit: {})
             .padding(0)
             Text(":")
             .padding(0)
             TextField("0", value: $seconds, formatter: NumberFormatter(), onCommit: {})
             .padding(0)
             Spacer()
             }
             .foregroundColor(.white)
             .padding()
             )
             .onTapGesture {
             startCountdown()
             }
             
        }
        .onAppear{
            tvm.getReps(eid: eid)
        }
    }


    func startCountdown() {
        if !isCountingDown {
            isCountingDown = true
            let totalSeconds = (minutes * 60) + seconds
            var remainingSeconds = totalSeconds
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                remainingSeconds -= 1
                if remainingSeconds <= 0 {
                    timer.invalidate()
                    isCountingDown = false
                }
                
                minutes = remainingSeconds / 60
                seconds = remainingSeconds % 60
            }
        }
    }
}
