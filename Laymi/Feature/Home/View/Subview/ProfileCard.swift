//
//  ProfileCard.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI
import SwiftData
import UIKit

struct ProfileCard: View {
    @Bindable private var profileViewModel: ProfileViewModel
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
    }
    
    var body: some View {
        HStack {
            VStack {
                LargeTitle(text: profileViewModel.name)
                Subtitle(text: currentDate(), color: .gradText)
            }
            profileImage
        }
    }
    
    @ViewBuilder private var profileImage: some View {
        if let selectedPhotoData = profileViewModel.selectedPhotoData,
           let image = UIImage(data: selectedPhotoData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(.circle)
        } else {
            ImageView(photoUrl: nil, width: 70, height: 70)
        }
    }
    
    func currentDate() -> String {
        "\(Date().formatted(.dateTime.weekday(.wide).month(.wide).day()))"
    }
}

#Preview {
    let container = try! ModelContainer(for: UserProfileEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    ProfileCard(profileViewModel: ProfileViewModel(
        authService: FirebaseAuthService(),
        profileStorage: SwiftDataUserProfileStorage(modelContainer: container)
    ))
}
