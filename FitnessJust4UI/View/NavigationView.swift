//
//  NavigationView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 08.08.23.
//

import SwiftUI

struct NavigationView: View {
    @State private var selectedTab = 2
    @StateObject var tvm = TrainingsViewModel()

       var body: some View {
           VStack(spacing: 0) {
               switch selectedTab {
               case 0:
                   VStack{
                       TrainingsView()
                           .padding(0)
                           .environmentObject(tvm)
                   }
                   .padding(0)
               case 1:
                   VStack{
                       MeasurementView()
                           .padding(0)
                   }
                   .padding(0)
                   Spacer()
               case 2:
                   VStack{
                       HomeView()
                           .padding(0)
                   }
                   .padding(0)
               case 3:
                   VStack{
                       ProfileView()
                           .padding(0)
                   }
                   .padding(0)
               default:
                   EmptyView()
               }
               
               Divider()
               
               HStack {
                   ForEach(0..<4) { index in
                       Button(action: {
                           selectedTab = index
                       }) {
                           VStack {
                               Image(systemName: tabImageName(index))
                               //Text(tabTitle(index))
                           }
                           .foregroundColor(selectedTab == index ? .blue : .gray)
                       }
                       .frame(maxWidth: .infinity)
                   }
               }
               .padding(8)
           }
           .navigationBarBackButtonHidden(true)
           .navigationTitle(tabTitle(selectedTab))
       }
       
       func tabImageName(_ index: Int) -> String {
           switch index {
           case 0: return "figure.strengthtraining.traditional"
           case 1: return "lines.measurement.horizontal"
           case 2: return "house"
           case 3: return "person"
           default: return ""
           }
       }
       
       func tabTitle(_ index: Int) -> String {
           switch index {
           case 0: return "Training"
           case 1: return "Mesurement"
           case 2: return "Home"
           case 3: return "Profile"
           default: return ""
           }
       }
   }
