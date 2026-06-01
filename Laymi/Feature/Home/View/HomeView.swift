//
//  HomeView.swift
//  Laymi
//
//  Created by Ляйсан
//

import Foundation
import SwiftUI
import UIKit

struct HomeView: View {
    private let user: AuthUser
    private let onAuthFinished: () -> ()
    @Bindable private var profileViewModel: ProfileViewModel
    @Bindable private var homeViewModel: HomeViewModel
    
    @State private var sheet: ArticleSheet?
    
    init(
        user: AuthUser,
        profileViewModel: ProfileViewModel,
        homeViewModel: HomeViewModel,
        onAuthFinished: @escaping () -> () = {
        }
    ) {
        self.user = user
        self.profileViewModel = profileViewModel
        self.homeViewModel = homeViewModel
        self.onAuthFinished = onAuthFinished
    }

    var body: some View {
        NavigationStack {
            if homeViewModel.isLoading {
                LottieAnimationView(fileName: "Loading")
            } else {
                content
            }
        }
        .sheet(item: $sheet) { sheet in
            switch sheet {
            case .steps:
                ArticleViewControllerRepresentable(article: Article.stepsArticle)
            case .heartRate:
                ArticleViewControllerRepresentable(article: Article.heartRateArticle)
            }
        }
        .alert("Something went wrong", isPresented: errorPresented, actions: {
            Button("OK") {
                homeViewModel.clearError()
            }
        }, message: {
            Text(homeViewModel.errorMessage ?? "")
        })
        .task {
            await loadContent()
        }
    }
    
    @ViewBuilder private var background: some View {
        Color(.secondarySystemBackground).ignoresSafeArea()
        DynamicGradientHeaderLayout(colors: Color.colorsForQuotesGradientBackground)
    }
    
    private var content: some View {
        ZStack(alignment: .top) {
            background
            ScrollView {
                VStack(spacing: 0) {
                    profileCard
                    quoteBlock
                    healthBlock
                }
                .padding()
                .padding(.top, 20)
            }
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder private var quoteBlock: some View {
        if let quote = homeViewModel.quoteOfTheDay {
            cardTitle("Daily Reflection")
                .padding(.top, 25)
            QuoteOfTheDayCard(quote: quote)
                .padding(.top)
        }
    }
    
    private var profileCard: some View {
        NavigationLink {
            ProfileView(profileViewModel: profileViewModel, user: user, onAuthFinished: onAuthFinished)
        } label: {
            ProfileCard(profileViewModel: profileViewModel)
        }
    }
    
    private var healthRequestButton: some View {
        HealthRequestButton {
            Task {
                await homeViewModel.requestAuthorization()
            }
        }
        .padding(.top)
    }
    
    @ViewBuilder private var healthBlock: some View {
        switch homeViewModel.healthState {
        case .needsAuthorization:
            cardTitle("Get More From Health")
                .padding(.top)
            healthRequestButton
        case .content:
            Group {
                cardTitle("Today’s Body Check")
                    .padding(.top)
                healthCards
            }
        case .unavailable:
            cardTitle("Health Data")
                .padding(.top)
            healthUnavailableCard
        }
    }
    
    private var healthUnavailableCard: some View {
        BackgroundLayer(height: 120)
            .overlay {
                VStack(spacing: 10) {
                    Button("Open Settings") {
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                        UIApplication.shared.open(url)
                    }
                    .buttonStyle(.glassProminent)
                    .tint(.green)
                    
                    Text("To review access, open Health in Settings, choose Data Access & Devices, then select Laymi.")
                        .font(.caption)
                        .foregroundStyle(Color(.secondaryLabel))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
    }
    
    private var healthCards: some View {
        VStack(spacing: 16) {
            HealthCellRepresentable(title: "Steps", textColor: .intenseOrange, value: homeViewModel.todaysSteps, unit: "steps")
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .onTapGesture {
                    sheet = .steps
                }
            
            HealthCellRepresentable(title: "Heart Rate", textColor: .intensePink, value: homeViewModel.recentHeartRate, unit: "BPM")
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .onTapGesture {
                    sheet = .heartRate
                }
        }
        .padding(.top)
    }
    
    private func cardTitle(_ text: String) -> some View {
        Text(text)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var errorPresented: Binding<Bool> {
        Binding {
            homeViewModel.errorMessage != nil
        } set: { isPresented in
            if !isPresented {
                homeViewModel.clearError()
            }
        }
    }
    
    private func loadContent() async {
        async let profileTask: Void = profileViewModel.configure(with: user)
        async let homeTask: Void = homeViewModel.loadHomeContent()
        
        await profileTask
        await homeTask
    }
}

#Preview {
    HomeView(
        user: AuthUser.mockUser,
        profileViewModel: ProfileViewModel(
            authService: FirebaseAuthService(),
            profileStorage: MockUserProfileStorage()
        ), homeViewModel: HomeViewModel(healthService: HealthKitService(), quoteService: RemoteQuoteService(), quoteStorage: MockQuoteStorage())
    )
}

enum ArticleSheet: Identifiable {
    case steps
    case heartRate
    
    var id: Self { self }
}
