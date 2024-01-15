//
//  ImageSaver.swift
//  Graph Paper
//
//  Created by Livsy on 14.01.2024.
//

import SwiftUI

final class ImageSaver: NSObject {
        
    private var completion: (() -> Void)?
    
    @MainActor
    func saveToPhotoAlbum(view: some View, scale: CGFloat, _ completion: (() -> Void)?) {
        guard let uiImage = view.render(scale: scale) else { return }
        
        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc
    private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        completion?()
    }
}

fileprivate extension View {
    /// `@Environment(\.displayScale) var displayScale`
    @MainActor
    func render(scale displayScale: CGFloat = 1.0) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = displayScale
        
        return renderer.uiImage
    }
    
}

