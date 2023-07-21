//
//  HomeView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 31.05.23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var hvm = HomeViewModel()
    @State private var currentIndex: Int = 0
    
    
    var body: some View {
        VStack{
            GeometryReader { geometry in
                        ScrollView(.horizontal, showsIndicators: true) {
                            ScrollViewReader { scrollViewProxy in
                                HStack(spacing: 10) {
                                    ForEach(0..<10) { index in
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: geometry.size.width - 40, height: 200)
                                            .id(index)
                                    }
                                }
                                .onAppear {
                                    currentIndex = 0
                                }
                                .onChange(of: currentIndex) { newValue in
                                    withAnimation {
                                        scrollViewProxy.scrollTo(newValue, anchor: .center)
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(width: geometry.size.width)
                        .onAppear {
                            currentIndex = 0
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                            currentIndex = 0
                        }
                    }
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
