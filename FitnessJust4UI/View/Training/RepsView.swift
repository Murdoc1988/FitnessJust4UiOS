//
//  RepsView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 17.07.23.
//

import SwiftUI

struct RepsView: View {
    @ObservedObject private var tvm = TrainingsViewModel()
    @State var repsList: [String]
    @State private var minutes = 1
    @State private var seconds = 30
    @State private var isCountingDown = false
    
    init(){
        self.repsList = TrainingsViewModel().repsList
    }

    
    var body: some View {
        VStack{
            List(repsList, id: \.self) { rep in
                LEReps()
            }
            .navigationTitle("ÜbungXY")
            
            
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
        
            
    }
    
    private func startCountdown() {
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
