//
//  ImageWithGridOverlayView.swift
//  Graph Paper
//
//  Created by Livsy on 14.01.2024.
//

import SwiftUI

struct ImageWithGridOverlayView: View {
    
    @Binding var image: UIImage?
    @Binding var didSave: Bool
    @Binding var patternElementSideSize: CGFloat
    @Binding var patternColor: Color
    
    var onFinishImageSaving: (() -> Void)?
    
    @State private var isShowAlert = false
    @State private var imageSize: CGSize = .zero
    @State private var progressViewOpacity: CGFloat = 0
    
    @Environment(\.displayScale) private var displayScale
    private let imageSaver = ImageSaver()
    
    var body: some View {
        
        ZStack {
            if let image {
                overlayedImage(image)
                    .onChange(of: didSave, { _, _ in
                        save()
                    })
                    .alert("\(Strings.done) 👌", isPresented: $isShowAlert) {
                        alertMenu()
                    }
            }
            
            progresView()
        }
    }
    
    @ViewBuilder
    private func overlayedImage(_ image: UIImage) -> some View {
        imageView(image)
            .overlay {
                gridView()
            }
    }
    
    @ViewBuilder
    private func progresView() -> some View {
        ProgressView()
            .padding()
            .scaleEffect(2)
            .opacity(progressViewOpacity)
            .tint(.white.opacity(0.9))
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black).opacity(0.8)
                    .frame(width: 60, height: 60)
                    .opacity(progressViewOpacity)
            )
    }
    
    @ViewBuilder
    private func gridView() -> some View {
        let size = CGSize(width: patternElementSideSize, height: patternElementSideSize)
        let image = UIImage(resource: .graph).resized(to: size)
        Image(uiImage: image)
            .resizable(resizingMode: .tile)
            .renderingMode(.template)
            .foregroundColor(patternColor)
    }
    
    @ViewBuilder
    private func gridViewToSave(_ image: UIImage) -> some View {
        let sideSizeDiff = sizeDiff(image)
        let actualSideSize = patternElementSideSize * sideSizeDiff
        let image = UIImage(resource: .graph).resized(to: .init(width: actualSideSize, height: actualSideSize))
        Image(uiImage: image)
            .resizable(resizingMode: .tile)
    }
    
    @ViewBuilder
    private func rectReader() -> some View {
        GeometryReader { geometry -> Color in
            let imageSize = geometry.size
            DispatchQueue.main.async {
                self.imageSize = imageSize
            }
            return .clear
        }
    }
    
    @ViewBuilder
    private func imageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .frame(maxWidth: .infinity)
            .scaledToFit()
            .background(rectReader())
    }
    
    @ViewBuilder
    private func imageViewToSave(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: image.size.width, height: image.size.height)
            .scaledToFit()
            .overlay {
                gridViewToSave(image)
            }
    }
    
    @MainActor
    private func save() {
        guard let image else { return }
        let view = imageViewToSave(image)
        imageSaver.saveToPhotoAlbum(view: view, scale: displayScale) {
            progressViewOpacity = 0
            isShowAlert.toggle()
            onFinishImageSaving?()
        }
        progressViewOpacity = 1
    }
    
    @ViewBuilder
    private func alertMenu() -> some View {
        VStack {
            Button {
                UIApplication.shared.open(URL(string:"photos-redirect://")!)
            } label: {
                Text(Strings.openPhotos)
            }
            
            Button {
                isShowAlert.toggle()
            } label: {
                Text("OK")
            }
        }
    }
    
    private func sizeDiff(_ image: UIImage) -> CGFloat {
        if imageSize.width == UIScreen.width && UIScreen.width < image.size.width {
            image.size.width / UIScreen.width
        } else if imageSize.height < image.size.height && UIScreen.width > imageSize.width {
            image.size.height / imageSize.height
        } else {
            1
        }
    }
    
}

fileprivate extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
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
