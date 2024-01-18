//
//  ContentView.swift
//  Graph Paper
//
//  Created by Livsy on 14.01.2024.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @AppStorage("selectedAppearance") private var selectedAppearance: AppearanceKind = .system
    @AppStorage("defaultPatternElementSideSize") private var defaultPatternElementSideSize: Int = 40
    
    @State private var image: UIImage?
    @State private var patternElementSideSize: CGFloat = 40
    @State private var didSave: Bool = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var isButtonsDisabled: Bool = false
    @State private var additionalUiOpacity: CGFloat = .zero
    @State private var patternColor: Color = .black
    @State private var isEditingGridSize: Bool = false
    
    private var themeManager = ThemeManager()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    
                    Menu {
                        ForEach(AppearanceKind.allCases) { appearance in
                            Button {
                                selectedAppearance = appearance
                            } label: {
                                HStack {
                                    Text(appearance.title)
                                    Image(systemName: appearance.imageName)
                                        .renderingMode(.template)
                                        .foregroundColor(appearance.color)
                                }
                            }
                        }
                    } label: {
                        Image(systemName: selectedAppearance.imageName)
                            .renderingMode(.template)
                            .font(.system(size: 25))
                            .foregroundColor(selectedAppearance.color)
                    }
                    .padding()
                    .symbolEffect(.bounce, value: selectedAppearance)
                }
                .onChange(of: selectedAppearance) { _, _ in
                    themeManager.overrideDisplayMode()
                }
                .onAppear {
                    themeManager.overrideDisplayMode()
                }
                
                Spacer()
                
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
                            .padding(.leading)
                        ColorPicker("", selection: $patternColor)
                            .labelsHidden()
                        Spacer()
                    }
                    
                    HStack {
                        Label("\(Strings.gridSize): \(Int(patternElementSideSize))", systemImage: "rectangle.split.3x3.fill")
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    Slider(
                        value: $patternElementSideSize,
                        in: 10...150,
                        step: 1
                    ) { isEditing in
                        isEditingGridSize = isEditing
                    }
                    .padding(.horizontal)
                    .accentColor(.buttonPrimary)
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
                        .padding(.horizontal)
                }
                .disabled(isButtonsDisabled)
                .tint(.buttonSecondary)
                .opacity(additionalUiOpacity)
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label(Strings.selectAnImage, systemImage: "photo")
                        .frame(maxWidth: .infinity)
                }
                .disabled(isButtonsDisabled)
                .tint(.buttonPrimary)
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .padding([.bottom, .horizontal])
            }
            
            Image(systemName: "photo.fill.on.rectangle.fill")
                .renderingMode(.template)
                .foregroundColor(Color.gray.opacity(0.3))
                .opacity(image == nil ? 1 : 0)
                .font(.system(size: 100))
            
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
        .onAppear {
            patternElementSideSize = CGFloat(defaultPatternElementSideSize)
        }
        .onChange(of: isEditingGridSize, { _, newValue in
            guard !newValue else { return }
            defaultPatternElementSideSize = Int(patternElementSideSize)
        })
        .background(Color.background)
    }
    
}

#Preview {
    ContentView()
}

fileprivate extension AppearanceKind {
    var title: String {
        switch self {
        case .system: Strings.systemMode
        case .light: Strings.lightMode
        case .dark: Strings.darkMode
        }
    }
    
    var imageName: String {
        switch self {
        case .system: "sun.haze.fill"
        case .light: "sun.max.fill"
        case .dark: "moon.stars.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .system: .buttonSecondary
        case .light: .orange
        case .dark: .purple
        }
    }
}
