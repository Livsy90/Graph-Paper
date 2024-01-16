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
    @State private var patternElementSideSize: CGFloat = 50
    @State private var didSave: Bool = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var saveButtonOpacity: CGFloat = .zero
    @State private var sliderOpacity: CGFloat = .zero
    @State private var patternColor: Color = .black
    
    var body: some View {
        VStack {
            Spacer()
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                Label(Strings.selectAnImage, systemImage: "photo")
            }
            .tint(.purple)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .padding()
            
            Button {
                didSave.toggle()
            } label: {
                Label(Strings.save, systemImage: "tray.and.arrow.down")
            }
            .opacity(saveButtonOpacity)
            .tint(.green)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .padding()
            
            Divider()
                .opacity(saveButtonOpacity)
                .padding([.bottom, .horizontal])
            
            VStack {
                HStack {
                    Spacer()
                    Text(Strings.gridColor)
                    ColorPicker("", selection: $patternColor)
                        .labelsHidden()
                    Spacer()
                }
                .padding(.bottom)
                
                Text(Strings.gridSize)
                Slider(
                    value: $patternElementSideSize,
                    in: 10...150,
                    step: 10
                )
                .padding(.horizontal)
            }
            .opacity(sliderOpacity)
            .onChange(of: didSave) { _, _ in
                sliderOpacity = 0
            }
            .padding(.bottom)
            
            ImageWithGridOverlayView(
                image: $image,
                didSave: $didSave,
                patternElementSideSize: $patternElementSideSize, 
                patternColor: $patternColor
            ) {
                withAnimation {
                    sliderOpacity = 1
                }
            }
            
            Spacer()
        }
        .onChange(of: selectedItem) {
            Task {
                guard let data = try? await selectedItem?.loadTransferable(type: Data.self),
                      let image = UIImage(data: data)
                else { return }
                
                withAnimation {
                    saveButtonOpacity = 1
                    sliderOpacity = 1
                    self.image = image
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
