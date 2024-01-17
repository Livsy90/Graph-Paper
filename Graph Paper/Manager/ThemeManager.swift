//
//  ThemeManager.swift
//  Graph Paper
//
//  Created by Livsy on 16.01.2024.
//

import SwiftUI

final class ThemeManager {

    @AppStorage("selectedAppearance") var selectedAppearance: AppearanceKind = .system

    func overrideDisplayMode() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        window?.overrideUserInterfaceStyle = .init(rawValue: selectedAppearance.rawValue) ?? .unspecified
    }
    
}
