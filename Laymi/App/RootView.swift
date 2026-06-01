//
//  RootView.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftUI
import SwiftData

struct RootView: View {
    @State private var rootViewModel: RootViewModel
    
    private var authService: AuthService
    private let profileStorage: UserProfileStorage
    private let journalStorage: JournalStorage
    private let quoteStorage: QuoteStorage
    
    init(
        authService: AuthService,
        profileStorage: UserProfileStorage,
        journalStorage: JournalStorage,
        quoteStorage: QuoteStorage
    ) {
        self.authService = authService
        self.profileStorage = profileStorage
        self.journalStorage = journalStorage
        self.quoteStorage = quoteStorage
        self._rootViewModel = State(initialValue: RootViewModel(authService: authService))
    }
    
    var body: some View {
        Group {
            switch rootViewModel.state {
            case .loading:
                LottieAnimationView(fileName: "Loading")
            case .unauthenticated:
                AuthView(authViewModel: AuthViewModel(authService: authService)) {
                    rootViewModel.showMainFlow()
                }
            case .authenticated(let user):
                TabBarView(
                    user: user,
                    journalStorage: journalStorage,
                    profileViewModel: ProfileViewModel(
                        authService: authService,
                        profileStorage: profileStorage
                    ),
                    homeViewModel: HomeViewModel(healthService: HealthKitService(), quoteService: RemoteQuoteService(), quoteStorage: quoteStorage),
                    exerciseViewModel: ExerciseViewModel(),
                    quotesViewModel: QuotesViewModel(
                        quoteService: RemoteQuoteService(),
                        quoteStorage: quoteStorage
                    ), chatViewModel: ChatViewModel(chatService: GeminiChatService())
                ) {
                    rootViewModel.showAuthFlow()
                }
            case .error:
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
            }
        }
        .task {
            rootViewModel.checkAuthState()
        }
        .alert("Something went wrong", isPresented: rootErrorPresented) {
            Button("OK") {
                rootViewModel.clearError()
            }
        } message: {
            Text(rootViewModel.errorMessage ?? "")
        }
    }
    
    private var rootErrorPresented: Binding<Bool> {
        Binding {
            rootViewModel.errorMessage != nil
        } set: { isPresented in
            if !isPresented {
                rootViewModel.clearError()
            }
        }
    }
}

#Preview {
    RootView(
        authService: FirebaseAuthService(),
        profileStorage: MockUserProfileStorage(),
        journalStorage: MockJournalStorage(),
        quoteStorage: MockQuoteStorage()
    )
}
