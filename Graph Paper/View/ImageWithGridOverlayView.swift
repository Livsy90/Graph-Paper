//
//  ImageWithGridOverlayView.swift
//  Graph Paper
//
//  Created by Livsy on 14.01.2024.
//

import SwiftUI

struct ImageWithGridOverlayView: View {
    
    @Binding var image: UIImage?
    @State private var isShowAlert = false
    @Environment(\.displayScale) private var displayScale
    
    var body: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .frame(maxWidth: .infinity)
                .scaledToFit()
                .overlay {
                    Image(.graphPaper)
                        .resizable(resizingMode: .tile)
                        .frame(maxWidth: .infinity)
                }
                .onTapGesture {
                    DispatchQueue.main.async {
                        isShowAlert.toggle()
                    }
                    
                    ImageSaver.saveToPhotoAlbum(view: self, scale: displayScale)
                }
                .alert("\(Strings.done) 👌", isPresented: $isShowAlert) {}
        }
    }
}
