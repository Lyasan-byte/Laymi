//
//  LaymiApp.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI
import SwiftData
import FirebaseCore
import GoogleSignIn

@main
struct LaymiApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfileEntity.self,
            JournalEntryEntity.self,
            QuoteEntity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView(
                authService: FirebaseAuthService(),
                profileStorage: SwiftDataUserProfileStorage(modelContainer: sharedModelContainer),
                journalStorage: SwiftDataJournalStorage(modelContainer: sharedModelContainer),
                quoteStorage: SwiftDataQuoteStorage(modelContainer: sharedModelContainer)
            )
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
