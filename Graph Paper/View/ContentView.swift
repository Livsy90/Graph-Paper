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
    @State private var isButtonsDisabled: Bool = false
    @State private var additionalUiOpacity: CGFloat = .zero
    @State private var patternColor: Color = .black
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Label(Strings.imageSettings, systemImage: "wrench.fill")
                    .opacity(additionalUiOpacity)
            
                ImageWithGridOverlayView(
                    image: $image,
                    didSave: $didSave,
                    patternElementSideSize: $patternElementSideSize,
                    patternColor: $patternColor
                ) {
                    withAnimation {
                        isButtonsDisabled = false
                        additionalUiOpacity = 1
                    }
                }
                
                Label("\(Strings.size): \(Int(image?.size.width ?? 0)) / \(Int(image?.size.height ?? 0))", systemImage: "arrow.up.left.and.arrow.down.right")
                    .opacity(additionalUiOpacity)
                
                Divider()
                    .opacity(additionalUiOpacity)
                    .padding()
                
                VStack {
                    
                    HStack {
                        Label("\(Strings.gridColor): ", systemImage: "paintbrush.fill")
                            .multilineTextAlignment(.leading)
                        ColorPicker("", selection: $patternColor)
                            .labelsHidden()
                        Spacer()
                    }
                    
                    HStack {
                        Label("\(Strings.gridSize): \(Int(patternElementSideSize))", systemImage: "rectangle.split.3x3.fill")
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    
                    Slider(
                        value: $patternElementSideSize,
                        in: 10...150,
                        step: 1
                    )
                    .padding(.horizontal)
                    .accentColor(.purple)
                }
                .opacity(additionalUiOpacity)
                
                Divider()
                    .opacity(additionalUiOpacity)
                    .padding()
                
                Button {
                    didSave.toggle()
                } label: {
                    Label(Strings.save, systemImage: "tray.and.arrow.down")
                        .frame(maxWidth: .infinity)
                }
                .disabled(isButtonsDisabled)
                .tint(.green)
                .opacity(additionalUiOpacity)
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label(Strings.selectAnImage, systemImage: "photo")
                        .frame(maxWidth: .infinity)
                }
                .disabled(isButtonsDisabled)
                .tint(.purple)
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .padding([.bottom, .horizontal])
            }
            
            Image(systemName: "photo.fill.on.rectangle.fill")
                .renderingMode(.template)
                .foregroundColor(.purple)
                .opacity(image == nil ? 1 : 0)
                .font(.system(size: 150))

        }
        .onChange(of: selectedItem) {
            Task {
                guard let data = try? await selectedItem?.loadTransferable(type: Data.self),
                      let image = UIImage(data: data)
                else { return }
                
                withAnimation {
                    additionalUiOpacity = 1
                    self.image = image
                }
            }
        }
        .onChange(of: didSave) { _, _ in
            isButtonsDisabled = true
            additionalUiOpacity = 0
        }
    }
    
}

#Preview {
    ContentView()
}
