//
//  PhotoPicker.swift
//  RealMusic
//
//  Created by Joel Wolinsky on 17/11/2022.
//

import Foundation
import SwiftUI
import PhotosUI

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct PhotoPicker: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @Binding var selectedImageData: Data?
    
    @Binding var isAddingPhoto: Bool
    
    
    var body: some View {
        VStack {
            
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        // Retrieve selected asset in the form of Data
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                            
                            // Data in memory
                            let data = selectedImageData
                            print("select photo")
                            let storage = Storage.storage()
                            let storageRef = storage.reference()
                            // Create a reference to the file you want to upload
                            let riversRef = storageRef.child("images/\(UserDefaults.standard.value(forKey: "uid")!).heic")
                            print(UserDefaults.standard.value(forKey: "uid"))
                            // Upload the file to the path "images/rivers.jpg"
                            let uploadTask = riversRef.putData(data!, metadata: nil) { (metadata, error) in
                                guard let metadata = metadata else {
                                    // Uh-oh, an error occurred
                                    print(error)
                                    //                              fatalError()
                                    return
                                }
                                
                                // Metadata contains file metadata such as size, content-type.
                                let size = metadata.size
                                // You can also access to download URL after upload.
                                riversRef.downloadURL { (url, error) in
                                    guard let downloadURL = url else {
                                        // Uh-oh, an error occurred!
                                        //  fatalError()
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
            
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                Button {
                    isAddingPhoto.toggle()
                    
                } label: {
                    Text("Upload")
                }
                .padding(20)            }
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}
