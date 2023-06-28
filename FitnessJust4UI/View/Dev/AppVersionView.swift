//
//  AppVersionView.swift
//  FitnessJust4U
//
//  Created by Robert Krautchick on 05.06.23.
//

import SwiftUI

struct AppVersionView: View {
    var body: some View {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            Text("App-Version: \(appVersion)")
        } else {
            Text("Versionsnummer nicht gefunden")
        }
    }
}

struct AppVersionView_Previews: PreviewProvider {
    static var previews: some View {
        AppVersionView()
    }
}
