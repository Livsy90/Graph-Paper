//
//  ScaleValue.swift
//  Graph Paper
//
//  Created by Livsy on 15.01.2024.
//

enum ScaleValue: Double {
    case big = 10
    case medium = 3
    case small = 0.5
    
    static func getValue(from value: Double) -> ScaleValue {
        if value > 1000.0 && value < 2000 {
            .medium
        } else if value < 1000 {
            .small
        } else {
            .big
        }
    }
}
