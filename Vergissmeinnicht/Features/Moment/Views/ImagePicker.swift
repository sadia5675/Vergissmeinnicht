//
//  ImagePicker.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 10.06.26.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image, dismiss: dismiss)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        @Binding var image: UIImage?
        let dismiss: DismissAction
        
        init(image: Binding<UIImage?>, dismiss: DismissAction) {
            self._image = image
            self.dismiss = dismiss
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            dismiss()
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.image = image as? UIImage
                }
            }
        }
    }
}
