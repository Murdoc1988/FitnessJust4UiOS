//
//  EntryPoint.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 31.05.23.
//

import SwiftUI

struct EntryPoint: View {
    @StateObject var svm = StarterViewModel()
    var body: some View {
        
        switch svm.starterID {
        case 0:
            LoginView()
        case 1:
            HomeView()
        case 3:
            ErrorView()
        default:
            ErrorView()
        }
    }
}

struct EntryPoint_Previews: PreviewProvider {
    static var previews: some View {
        EntryPoint()
    }
}
