//
//  CategoryRider.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 24.07.23.
//

import SwiftUI

struct CategoryRider: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.deepPurple, lineWidth: 4)
                )
            
            Text("Category")
                .foregroundColor(Color.deepPurple)
                .font(.headline)
                .padding()
        }
        .frame(width: 200, height: 50)
        .padding(8)
    }
}

struct CategoryRider_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRider()
    }
}
