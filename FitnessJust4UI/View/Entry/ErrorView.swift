//
//  ErrorView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 31.05.23.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack{
            Text("Es ist ein Fehler aufgetreten.")
                .foregroundColor(.red)
            Text("Bitte starten Sie die App neu!")
                .foregroundColor(.red)
        }
        
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
