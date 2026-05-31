//
//  ProfileView.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftUI
import SwiftData
import UIKit

struct ProfileView: View {
    @Bindable private var profileViewModel: ProfileViewModel
    let user: AuthUser
    let onAuthFinished: () -> ()
    
    @State private var activeSheet: ProfileSheet?
    @State private var isSignOutConfirmationPresented = false
    @State private var isDeleteConfirmationPresented = false
    
    init(profileViewModel: ProfileViewModel, user: AuthUser, onAuthFinished: @escaping () -> () = {}) {
        self.profileViewModel = profileViewModel
        self.user = user
        self.onAuthFinished = onAuthFinished
    }
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground).ignoresSafeArea()
            BackgroundCircle(color: .pinkGrad)
            VStack {
                photoButton
                email
                userInfo
                Spacer()
                signOutButton
                deleteAccountButton
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await profileViewModel.configure(with: user)
        }
        .alert("Something went wrong", isPresented: profileErrorPresented) {
            Button("OK") {
                profileViewModel.clearError()
            }
        } message: {
            Text(profileViewModel.errorMessage ?? "")
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .photo:
                PhotoSheet(selectedPhotoData: profileViewModel.selectedPhotoData) { data in
                    Task {
                        await profileViewModel.updatePhoto(data)
                    }
                }
                .presentationDetents([.height(360)])
            case .name:
                NameSheet(name: $profileViewModel.name) {
                    Task {
                        await profileViewModel.saveProfile()
                    }
                }
                .presentationDetents([.height(220)])
            case .birthday:
                BirthdaySheet(date: $profileViewModel.birthday) {
                    Task {
                        await profileViewModel.saveProfile()
                    }
                }
            case .gender:
                GenderSheet(gender: $profileViewModel.gender) {
                    Task {
                        await profileViewModel.saveProfile()
                    }
                }
                .presentationDetents([.height(220)])
            }
        }
    }
    
    private var photoButton: some View {
        Button {
            activeSheet = .photo
        } label: {
            profileImage
        }
        .buttonStyle(.plain)
    }
    
    private var email: some View {
        Subtitle(text: profileViewModel.email, alignment: .center)
            .padding(.top, 8)
    }
    
    private var userInfo: some View {
        VStack {
            ProfileRow(name: "Name", value: profileViewModel.name) {
                activeSheet = .name
            }
            ProfileRow(name: "Birthday", value: profileViewModel.birthdayText) {
                activeSheet = .birthday
            }
            ProfileRow(name: "Gender", value: profileViewModel.gender.name, divider: false) {
                activeSheet = .gender
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(.tertiarySystemBackground))
        }
        .padding(.top, 25)
    }
    
    private var signOutButton: some View {
        PrimaryButton(textColor: Color(.systemRed), backgroundColor: Color(.tertiarySystemBackground)) {
            Text("Sign Out")
        } action: {
            isSignOutConfirmationPresented = true
        }
        .disabled(profileViewModel.isLoading)
        .confirmationDialog("Sign out of Laymi?", isPresented: $isSignOutConfirmationPresented, titleVisibility: .visible) {
            Button("Sign Out", role: .destructive) {
                if profileViewModel.signOut() {
                    onAuthFinished()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private var deleteAccountButton: some View {
        PrimaryButton(textColor: Color(.systemRed), backgroundColor: .lightRed) {
            ZStack {
                Text("Delete Account")
                    .opacity(profileViewModel.isLoading ? 0 : 1)
                if profileViewModel.isLoading {
                    ProgressView()
                        .tint(Color(.systemRed))
                }
            }
        } action: {
            isDeleteConfirmationPresented = true
        }
        .padding(.top, 5)
        .disabled(profileViewModel.isLoading)
        .confirmationDialog("Delete your account?", isPresented: $isDeleteConfirmationPresented, titleVisibility: .visible) {
            Button("Delete Account", role: .destructive) {
                Task {
                    let isDeleted = await profileViewModel.deleteAccount()
                    if isDeleted {
                        onAuthFinished()
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete your Laymi account and profile data.")
        }
    }
    
    @ViewBuilder private var profileImage: some View {
        if let selectedPhotoData = profileViewModel.selectedPhotoData,
           let image = UIImage(data: selectedPhotoData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 180, height: 180)
                .clipShape(.circle)
        } else {
            ImageView(photoUrl: nil, width: 180, height: 180)
        }
    }
    
    private var profileErrorPresented: Binding<Bool> {
        Binding {
            profileViewModel.errorMessage != nil
        } set: { isPresented in
            if !isPresented {
                profileViewModel.clearError()
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: UserProfileEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    ProfileView(
        profileViewModel: ProfileViewModel(
            authService: FirebaseAuthService(),
            profileStorage: SwiftDataUserProfileStorage(modelContainer: container)
        ),
        user: AuthUser.mockUser
    )
}
