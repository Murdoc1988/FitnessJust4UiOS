//
//  DiagrammItem.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 03.07.23.
//

import SwiftUI

struct DiagrammItem: View {
    var body: some View {
        Image("exampleGraph")
            .resizable()
            .frame(width: 300, height:200)
            .padding(0)
    }
}

struct DiagrammItem_Previews: PreviewProvider {
    static var previews: some View {
        DiagrammItem()
    }
}
