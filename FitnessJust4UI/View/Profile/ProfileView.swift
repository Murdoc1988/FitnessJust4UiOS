//
//  ProfileView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 24.07.23.
//

import SwiftUI

struct ProfileView: View {
    @State var pageIndex = 0
    @State var pfname: String = UserDefaults.standard.string(forKey: "firstname") ?? ""
    @State var plname: String = UserDefaults.standard.string(forKey: "lastname") ?? ""
    @State var mail: String = UserDefaults.standard.string(forKey: "mail") ?? ""
    @State var categories = ["User", "Mesurement", "Settings"]
    var body: some View {
        VStack{
            VStack {
                Divider()
                
                
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.horizontal) {
                        
                        HStack(spacing: 10) {
                            ForEach(categories.indices, id: \.self) { index in
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
                                CategoryRider(category: categories[index])
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
                    //Text("Page \(pageIndex)")
                    //    .font(.title)
                    switch categories[pageIndex] {
                    case "User":
                        TextEdit(labelText: "Firstname", userDefault: "pfname")
                        
                        TextEdit(labelText: "Lastname", userDefault: "plname")
                        
                        TextEdit(labelText: "Mail", userDefault: "pmail")
                        
                        Button(action: {
                            //TODO: Logout Funktion implementieren
                        }) {
                            Text("Logout")
                                .padding()
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        
                        
                    case "Mesurement":
                        ToggleView(labelText: "Weight", userDefault: "isWeight", periodOneUD: "periodOneWeight", periodTwoUD: "periodTwoWeight")
                        ToggleView(labelText: "Water", userDefault: "isWater", periodOneUD: "periodOneWater", periodTwoUD: "periodTwoWater")
                        ToggleView(labelText: "Muscle", userDefault: "isMuscle", periodOneUD: "periodOneMuscle", periodTwoUD: "periodTwoMuscle")
                        
                    case "Settings":
                        ToggleSettingsView(labelText: "Show News", userDefault: "showNews")
                        ToggleSettingsView(labelText: "Set Reminder", userDefault: "isReminding")
                        
                    default:
                        Text("Bitte wähle eine Kategorie!")
                    }
                    
                    Spacer()
                    
                    
                    
                }
                .padding(0)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.width > 0 {
                                if pageIndex != 0 {
                                    pageIndex -= 1
                                }
                            } else if value.translation.width < 0 {
                                if pageIndex < categories.count - 1 {
                                    pageIndex += 1
                                }
                            }
                            
                        }
                )
            }
            
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
