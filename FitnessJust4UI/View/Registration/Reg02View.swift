//
//  Reg02View.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 16.06.23.
//

import SwiftUI

struct Reg02View: View {
    var body: some View {
            NavigationStack{
                VStack{
                    
                    Spacer()
                    Text("Registrierung PART 2")
                    Spacer()
                    HStack{
                        
                        Spacer()
                        
                        NavigationLink("Next", destination: Reg02View())
                        
                    }
                    .padding(.trailing, 32)
                    
                }
                .navigationTitle("Registrierung")
                .navigationBarHidden(true)
            }
        }
}

struct Reg02View_Previews: PreviewProvider {
    static var previews: some View {
        Reg02View()
    }
}
