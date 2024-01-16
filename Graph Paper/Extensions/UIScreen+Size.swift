//
//  UIScreen+Size.swift
//  Graph Paper
//
//  Created by Livsy on 16.01.2024.
//

import UIKit

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
    
    static var width: CGFloat {
        UIWindow.current?.screen.bounds.width ?? 0
    }
    
    static var height: CGFloat {
        UIWindow.current?.screen.bounds.height ?? 0
    }
}

fileprivate extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}
