//
//  ProfileView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 24.07.23.
//

import SwiftUI

struct ProfileView: View {
    @State var pageIndex = 0
    var body: some View {
        VStack{
            VStack {
                Divider()
                
                
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.horizontal) {
                        
                            HStack(spacing: 10) {
                                ForEach(0..<10, id: \.self) { index in
                                    /*
                                    Text("\(index) Test Test Test")
                                        .onTapGesture {
                                            pageIndex = index
                                            withAnimation{
                                                scrollViewProxy.scrollTo(index, anchor: .leading)
                                            }
                                        }
                                        .font(.largeTitle)
                                     */
                                    CategoryRider()
                                        .onTapGesture {
                                            pageIndex = index
                                            withAnimation{
                                                scrollViewProxy.scrollTo(index, anchor: .leading)
                                            }
                                        }
                                    
                                }
                            }.padding()
                        
                    }
                    .frame(height: 100)
                    .onChange(of: pageIndex) { newValue in
                        print(newValue)
                        withAnimation {
                            scrollViewProxy.scrollTo(newValue, anchor: .leading)
                        }
                    }
                    Divider()
                }
                
                
                
                VStack{
                    Text("Page \(pageIndex)")
                        .font(.title)
                    TextEdit()
                    TextEdit()
                    ToggleView()
                    ToggleView()
                    Stepper(
                                   onIncrement: {
                                       pageIndex += 1
                                   },
                                   onDecrement: {
                                       pageIndex -= 1
                                   }
                                   )
                    {
                                    EmptyView()
                                }
                                .labelsHidden()
                    Spacer()
                    
                    
                    
                }
                .padding(0)
            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
