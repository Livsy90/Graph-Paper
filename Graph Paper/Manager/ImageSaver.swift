//
//  ImageSaver.swift
//  Graph Paper
//
//  Created by Livsy on 14.01.2024.
//

import SwiftUI

struct ImageSaver {
    
    private init() {}
    
    @MainActor
    static func saveToPhotoAlbum(view: some View, scale: CGFloat) {
        let uiImage: UIImage?
        
        if #available(iOS 16, *) {
            uiImage = view.render(scale: scale)
        } else {
            uiImage = view.snapshot()
        }
        
        guard let uiImage else { return }
        UIImageWriteToSavedPhotosAlbum(uiImage, self, nil, nil)
    }
}

fileprivate extension View {
    @MainActor
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
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

