//
//  ImageView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct ImageView: View {
    let photoUrl: String?
    let width: Double
    let height: Double
    
    var body: some View {
        AsyncImage(url: URL(string: photoUrl ?? "")) { image in
            image
                .resizable()
                .frame(width: width, height: height)
                .clipShape(.circle)
        } placeholder: {
            Image("profileImagePlaceholder")
                .resizable()
                .frame(width: width, height: height)
                .clipShape(.circle)
        }
    }
}

#Preview {
    ImageView(photoUrl: "", width: 70, height: 70)
}
