//
//  ContentView.swift
//  Graph Paper
//
//  Created by Livsy on 14.01.2024.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var image: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var captionOpacity: CGFloat = .zero
    
    var body: some View {
        VStack {
            Spacer()
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label(Strings.selectAnImage, systemImage: "photo")
            }
            .tint(.purple)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            
            Text(Strings.tapToSave)
                .font(.callout)
                .multilineTextAlignment(.center)
                .opacity(captionOpacity)
                .padding()
            
            ImageWithGridOverlayView(image: $image)
                
            Spacer()
        }
        .onChange(of: selectedItem) {
            Task {
                guard let data = try? await selectedItem?.loadTransferable(type: Data.self),
                      let image = UIImage(data: data)
                else { return }
                
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
