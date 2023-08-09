//
//  LEReps.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 18.07.23.
//

import SwiftUI

struct LEReps: View {
    @State var set = 1
    @State var oWeight = 100
    @State var minWeight = 1
    @State var maxWeight = 300
    @State var nWeight = 100
    @State var selectedWeight = 100
    @State var oRep = 20
    @State var nRep = 18
    @State var minRep = 1
    @State var maxRep = 100
    @State var selectedReps = 20
    @State var pause = 120
    @State var time = 0
    @State var active = true
    var body: some View {
        
        VStack{
            HStack{
                VStack{
                    Text("\(set).Satz")
                    Spacer()
                    
                }
                Spacer()
                VStack{
                    Text("\(oWeight)kg")
                    if(active){
                        VStack{
                            Picker("Selectet Weight", selection: $selectedWeight){
                                ForEach(minWeight...maxWeight, id: \.self) { weight in
                                    Text("\(weight)")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20, weight: .bold))
                                    
                                }
                            }
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .bold))
                            .pickerStyle(WheelPickerStyle())
                            .padding(0)
                        }
                        .frame(height: 40)
                        .padding(0)
                    }
                    Spacer()
                }
                Spacer()
                VStack{
                    Text("\(oRep)Wdh.")
                    if(active){
                        VStack{
                            Picker("Selectet Reps", selection: $selectedReps){
                                ForEach(minRep...maxRep, id: \.self) { weight in
                                    Text("\(weight)")
                                        .foregroundColor(.black)
                                        .font(.system(size: 20, weight: .bold))
                                    
                                }
                            }
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .bold))
                            .pickerStyle(WheelPickerStyle())
                            .padding(0)
                        }
                        .frame(height: 40)
                        .padding(0)
                    }
                    Spacer()
                }
                
            }
            .padding(.horizontal, 16)
            .foregroundColor(.black)
            .font(.system(size: 20, weight: .bold))
            
            
            
            HStack{
                Spacer()
                Text("Pause: \(pause)sec.")
                Spacer()
                Text("Zeit: \(time)sec.")
                Spacer()
            }
            .padding(.horizontal, 16)
            .foregroundColor(.black)
        }
        .padding(.vertical, 8)
        
    }
}

struct LEReps_Previews: PreviewProvider {
    static var previews: some View {
        LEReps()
    }
}
