//
//  PhotoPicker.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 17/11/2022.
//

import Foundation
import PhotosUI
import SwiftUI

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
// import FirebaseStorage

struct PhotoPicker: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @Binding var selectedImageData: Data?
    @Binding var isAddingPhoto: Bool

    var body: some View {
        VStack {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Select a profile picture")
                    .foregroundColor(.black)
                    .padding(5)
                    .background(.white)
                    .cornerRadius(5)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        }
        .background(.black)
    }
}
