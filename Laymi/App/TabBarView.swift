//
//  TabBarView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct TabBarView: View {
    private let user: AuthUser
    private let journalStorage: JournalStorage
    private let onAuthFinished: () -> Void

    @Bindable private var profileViewModel: ProfileViewModel
    @Bindable private var homeViewModel: HomeViewModel
    @Bindable private var exerciseViewModel: ExerciseViewModel
    @Bindable private var quotesViewModel: QuotesViewModel
    @Bindable private var chatViewModel: ChatViewModel

    init(
        user: AuthUser,
        journalStorage: JournalStorage,
        profileViewModel: ProfileViewModel,
        homeViewModel: HomeViewModel,
        exerciseViewModel: ExerciseViewModel,
        quotesViewModel: QuotesViewModel,
        chatViewModel: ChatViewModel,
        onAuthFinished: @escaping () -> Void
    ) {
        self.user = user
        self.journalStorage = journalStorage
        self.profileViewModel = profileViewModel
        self.homeViewModel = homeViewModel
        self.exerciseViewModel = exerciseViewModel
        self.quotesViewModel = quotesViewModel
        self.chatViewModel = chatViewModel
        self.onAuthFinished = onAuthFinished
    }

    var body: some View {
        TabView {
            Tab("", systemImage: "house.fill") {
                HomeView(user: user, profileViewModel: profileViewModel, homeViewModel: homeViewModel, onAuthFinished: onAuthFinished)
            }

            Tab("", systemImage: "sparkles") {
                ChatView(chatViewModel: chatViewModel)
            }

            Tab("", systemImage: "figure.mind.and.body") {
                MeditationView(
                    exerciseViewModel: exerciseViewModel,
                    quotesViewModel: quotesViewModel
                )
            }

            Tab("", systemImage: "pencil.and.outline") {
                JournalView(journalViewModel: JournalViewModel(journalStorage: journalStorage))
            }
        }
    }
}

#Preview {
    TabBarView(
        user: AuthUser.mockUser,
        journalStorage: MockJournalStorage(),
        profileViewModel: ProfileViewModel(
            authService: FirebaseAuthService(),
            profileStorage: MockUserProfileStorage()
        ), homeViewModel: HomeViewModel(healthService: HealthKitService(), quoteService: RemoteQuoteService(), quoteStorage: MockQuoteStorage()),
        exerciseViewModel: ExerciseViewModel(),
        quotesViewModel: QuotesViewModel(quoteService: RemoteQuoteService(), quoteStorage: MockQuoteStorage()), chatViewModel: ChatViewModel(chatService: GeminiChatService())
    ) {}
}
