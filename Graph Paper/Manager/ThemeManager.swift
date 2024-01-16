//
//  ThemeManager.swift
//  Graph Paper
//
//  Created by Livsy on 16.01.2024.
//

import SwiftUI

final class ThemeManager {

    @AppStorage("selectedAppearance") var selectedAppearance = UserDefaults.standard.selectedAppearance ?? 0

    func overrideDisplayMode() {
        var userInterfaceStyle: UIUserInterfaceStyle

        if selectedAppearance == 2 {
            userInterfaceStyle = .dark
        } else if selectedAppearance == 1 {
            userInterfaceStyle = .light
        } else {
            userInterfaceStyle = .unspecified
        }
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.overrideUserInterfaceStyle = userInterfaceStyle
    }
}
