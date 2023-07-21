//
//  LEStats.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 18.07.23.
//

import SwiftUI

extension Color {
    static let deepPurple = Color(red: 89/255, green: 30/255, blue: 85/255)
}


struct LEStats: View {
    var body: some View {
        VStack{
            HStack{
                VStack{
                    HStack{
                        Text("Gewicht")
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                    }
                    HStack{
                        Text("100kg")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    
                }
                
                Spacer()
                
                Image(systemName: "plus.app.fill")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.deepPurple)
                
                
                
            }
            .padding([.leading, .trailing], 16)
            .padding([.bottom, .top], 4)
         
            Divider()
                .padding([.leading, .trailing], 16)
                .padding([.bottom, .top], 4)
        }
        
    }
}

struct LEStats_Previews: PreviewProvider {
    static var previews: some View {
        LEStats()
    }
}
