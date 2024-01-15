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
    @Binding var sideSize: CGFloat
    @Binding var scaleValue: ScaleValue
    
    var onFinishImageSaving: (() -> Void)?
    
    @State private var isShowAlert = false
    @State private var progressViewOpacity: CGFloat = 0
    
    @Environment(\.displayScale) private var displayScale
    private let imageSaver = ImageSaver()
    
    var body: some View {
        
        ZStack {
            if let image {
                imageView(image)
                    .overlay {
                        gridView()
                    }.onChange(of: didSave, { _, _ in
                        save()
                    })
                    .background(Color.white)
                    .alert("\(Strings.done) 👌", isPresented: $isShowAlert) {
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
            
            progresView()
        }
    }
    
    @ViewBuilder func progresView() -> some View {
        ProgressView()
            .padding()
            .scaleEffect(5)
            .opacity(progressViewOpacity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black).opacity(0.5)
                    .frame(width: 200, height: 200)
                    .opacity(progressViewOpacity)
            )
    }
    
    @ViewBuilder
    private func gridView() -> some View {
        let size = CGSize(width: sideSize, height: sideSize)
        let image = UIImage(resource: .graphPaper).resized(to: size)
        Image(uiImage: image)
            .resizable(resizingMode: .tile)
    }
    
    @ViewBuilder
    private func imageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .frame(maxWidth: .infinity)
            .scaledToFit()
    }
    
    @MainActor
    private func save() {
        sideSize *= CGFloat(scaleValue.rawValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            imageSaver.saveToPhotoAlbum(view: self, scale: displayScale) {
                progressViewOpacity = 0
                isShowAlert.toggle()
                onFinishImageSaving?()
            }
            sideSize /= CGFloat(scaleValue.rawValue)
            progressViewOpacity = 1
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
