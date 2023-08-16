//
//  NEWTraining.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 18.07.23.
//

import SwiftUI

struct NEWTraining: View {
    @EnvironmentObject private var tvm : TrainingsViewModel
    @State var training = ""
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                TextField("Training", text: $training)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 120)
                    .padding(.trailing, 0)
            }
            .padding(0)
            
            HStack{
                Spacer()
                Button(action: {
                    if(!training.isEmpty){
                        tvm.addTraining(training: Training(tid: 0, tname: training, tdesc: "Beschreibung", tdate: "2023-08-10", tecount: 5))
                        self.training = ""
                        //tvm.getTraining()
                    }
                            }) {
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

struct NEWTraining_Previews: PreviewProvider {
    static var previews: some View {
        NEWTraining()
    }
}
