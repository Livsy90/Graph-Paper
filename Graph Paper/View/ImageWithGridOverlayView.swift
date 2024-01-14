//
//  ImageWithGridOverlayView.swift
//  Graph Paper
//
//  Created by Livsy on 14.01.2024.
//

import SwiftUI

struct ImageWithGridOverlayView: View {
    
    @Binding var image: Image?
    @State private var isShowAlert = false
    @Environment(\.displayScale) private var displayScale
    
    var body: some View {
        image?
            .resizable()
            .frame(maxWidth: .infinity)
            .scaledToFit()
            .overlay {
                Image("grid")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .scaledToFill()
            }
            .onTapGesture {
                guard image != nil else { return }
                DispatchQueue.main.async {
                    isShowAlert.toggle()
                }
                
                ImageSaver.saveToPhotoAlbum(view: self, scale: displayScale)
            }
            .alert("Done 👌", isPresented: $isShowAlert) {}
    }
}

#Preview {
    ImageWithGridOverlayView(image: .constant(Image(systemName: "heart")))
}
