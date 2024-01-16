//
//  ContentView.swift
//  Graph Paper
//
//  Created by Livsy on 14.01.2024.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    private enum Appearance: Int {
        case system = 0
        case light = 1
        case dark = 2
        
        var title: String {
            switch self {
            case .system:
                Strings.system
            case .light:
                Strings.light
            case .dark:
                Strings.dark
            }
        }
        
        var imageName: String {
            switch self {
            case .system:
                "ellipsis.circle.fill"
            case .light:
                "sun.max.fill"
            case .dark:
                "moon.stars.fill"
            }
        }
    }
    
    @AppStorage("selectedAppearance") private var selectedAppearance = UserDefaults.standard.selectedAppearance ?? 0
    private var themeManager = ThemeManager()
    
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
                HStack {
                    Spacer()
                    
                    Text(Strings.mode)
                        .font(.caption2)
                        .padding(.top)
                    
                    Button {
                        switchAppearance()
                    } label: {
                        let appearance = Appearance(rawValue: selectedAppearance) ?? .system
                        Label(appearance.title, systemImage: appearance.imageName)
                    }
                    .tint(.buttonSecondary)
                    .controlSize(.small)
                    .buttonStyle(.bordered)
                    .padding([.trailing, .top])
                }
                .onChange(of: selectedAppearance) { _, _ in
                    themeManager.overrideDisplayMode()
                }
                .onAppear {
                    selectedAppearance = UserDefaults.standard.selectedAppearance ?? 0
                    themeManager.overrideDisplayMode()
                }
                
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
                    )
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
        .background(Color.background)
    }
    
    private func switchAppearance() {
        let appearance = Appearance(rawValue: selectedAppearance) ?? .system
        switch appearance {
        case .system:
            setSelectedAppearance(.light)
        case .light:
            setSelectedAppearance(.dark)
        case .dark:
            setSelectedAppearance(.system)
        }
    }
    
    private func setSelectedAppearance(_ value: Appearance) {
        UserDefaults.standard.selectedAppearance = value.rawValue
        selectedAppearance = value.rawValue
    }
    
}

#Preview {
    ContentView()
}
