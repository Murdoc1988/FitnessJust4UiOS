//
//  HintBubble.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 18.06.23.
//

import SwiftUI

struct HintBubble: View {
    
    var texts: [HintText]
    
    var body: some View {
        
        let frameheight = CGFloat(20+(texts.count*16))
        if(!texts.isEmpty){
            
            VStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                        .frame(width: 320, height: frameheight)


                    
                    VStack(alignment: .leading){
                        ForEach(0...texts.count-1, id: \.self) {
                            
                            switch texts[$0].color {
                            case "red":
                                Text("\(texts[$0].text)")
                                    .foregroundColor(Color(red: 1.0, green: 0.0, blue: 0.0))
                                    .font(.system(size: 12))
                            case "green":
                                Text("\(texts[$0].text)")
                                    .foregroundColor(Color(red: 0.0, green: 1.0, blue: 0.0))
                                    .font(.system(size: 12))
                            default:
                                Text("\(texts[$0].text)")
                                    .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.0))
                                    .font(.system(size: 12))
                            }
                        }
                        
                        
                    }
                    
                    
                }
            }
        }
    }
}
