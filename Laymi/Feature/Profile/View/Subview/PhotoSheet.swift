//
//  PhotoSheet.swift
//  Laymi
//
//  Created by Ляйсан
//

import PhotosUI
import SwiftUI
import UIKit

struct PhotoSheet: View {
    let selectedPhotoData: Data?
    let action: (Data?) -> ()
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var photoData: Data?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 22) {
                profileImage
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    PrimaryButton(backgroundColor: .brightPurple) {
                        Text("Choose Photo")
                    } action: {}
                    .allowsHitTesting(false)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    CheckmarkButton(color: .brightPurple) {
                        action(photoData)
                    }
                }
            }
            .task(id: selectedItem) {
                guard let selectedItem else { return }
                photoData = try? await selectedItem.loadTransferable(type: Data.self)
            }
        }
    }
    
    @ViewBuilder private var profileImage: some View {
        if let imageData = photoData ?? selectedPhotoData,
           let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 180, height: 180)
                .clipShape(.circle)
        } else {
            ImageView(photoUrl: nil, width: 180, height: 180)
        }
    }
}

#Preview {
    PhotoSheet(selectedPhotoData: nil, action: { _ in })
}
