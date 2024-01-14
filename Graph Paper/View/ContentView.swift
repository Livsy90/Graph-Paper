//
//  ContentView.swift
//  Graph Paper
//
//  Created by Livsy on 14.01.2024.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var image: Image?
    @State private var selectedItem: PhotosPickerItem?
    @State private var captionOpacity: CGFloat = .zero
    
    var body: some View {
        VStack {
            Spacer()
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label("Select an image", systemImage: "photo")
            }
            .tint(.purple)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            
            Text("Tap on the image to save it to the album")
                .font(.callout)
                .multilineTextAlignment(.center)
                .opacity(captionOpacity)
                .padding()
            
            ImageWithGridOverlayView(image: $image)
                
            Spacer()
        }
        .onChange(of: selectedItem) {
            Task {
                let image = try? await selectedItem?.loadTransferable(type: Image.self)
                withAnimation {
                    captionOpacity = 1
                    self.image = image
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
