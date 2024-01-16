//
//  UserDefaults+Theme.swift
//  Graph Paper
//
//  Created by Livsy on 16.01.2024.
//

import Foundation

extension UserDefaults {
    
    private enum Key {
        static let selectedAppearance = "selectedAppearance"
    }
    
    var selectedAppearance: Int? {
        get {
            return integer(forKey: Key.selectedAppearance)
        }
        set {
            set(newValue, forKey: Key.selectedAppearance)
        }
    }
}
