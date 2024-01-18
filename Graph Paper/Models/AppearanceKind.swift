//
//  AppearanceKind.swift
//  Graph Paper
//
//  Created by Livsy on 17.01.2024.
//

enum AppearanceKind: Int, CaseIterable {
    case system = 0
    case light = 1
    case dark = 2
}

extension AppearanceKind: Identifiable {
    var id: Self { self }
}
