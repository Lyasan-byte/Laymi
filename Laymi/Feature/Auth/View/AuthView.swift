//
//  AuthView.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct AuthView: View {
    @Bindable private var authViewModel: AuthViewModel
    var onAuthSuccess: () -> ()
    
    @State private var isLogin = true
    
    init(authViewModel: AuthViewModel, onAuthSuccess: @escaping () -> () = {}) {
        self.authViewModel = authViewModel
        self.onAuthSuccess = onAuthSuccess
    }
    
    var body: some View {
        ZStack {
            background
            VStack {
                appName
                Spacer()
                title
                form
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 30)
        }
        .hideKeyboardOnTap()
        .alert("Something went wrong", isPresented: authErrorPresented) {
            Button("OK") {
                authViewModel.clearError()
            }
        } message: {
            Text(authViewModel.errorMessage ?? "")
        }
    }
    
    private var background: some View {
        TopGradientBackground(accentColor: isLogin ?  .backPurple.opacity(0.9) : .backOrange)
    }
    
    private var appName: some View {
        HStack {
            Image(systemName: "sparkles")
            Text("Laymi")
        }
        .font(.title2)
        .fontWeight(.bold)
        .foregroundStyle(.lightYellow)
    }
    
    @ViewBuilder private var title: some View {
        Text(isLogin ? "Login" : "Sign Up")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .foregroundStyle(Color(.label))
        Text(isLogin ? "Welcome back!" : "We are here to help!")
            .foregroundStyle(Color(.secondaryLabel))
    }
    
    private var form: some View {
        VStack(spacing: 16) {
            inputFields
            signUpButton
            divider
            googleButton
            description
                .font(.system(size: 15))
                .padding(.top)
        }
        .padding(18)
        .background {
            RoundedRectangle(cornerRadius: 35)
                .fill(Color(.tertiarySystemBackground))
        }
        .padding(.top, 25)
    }
    
    @ViewBuilder private var inputFields: some View {
        if !isLogin {
            FormField(title: "NAME", placeholder: "Laysan", input: $authViewModel.name)
        }
        FormField(title: "EMAIL", placeholder: "hello@laymi.com", input: $authViewModel.email)
            .keyboardType(.emailAddress)
            .textContentType(.emailAddress)
        FormField(title: "PASSWORD", placeholder: "••••••••", isSecure: true, input: $authViewModel.password)
        if !isLogin {
            FormField(title: "CONFIRM PASSWORD", placeholder: "••••••••", isSecure: true, input: $authViewModel.confirmPassword)
        }
    }
    
    private var signUpButton: some View {
        PrimaryButton(backgroundColor: isFormValid ? isLogin ? .brightPurple : .brightOrange : isLogin ? .backPurple : .backOrange, content: {
            ZStack {
                Text(isLogin ? "Login →" : "Sign Up →")
                    .opacity(authViewModel.isLoading ? 0 : 1)
                if authViewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
        }) {
            Task {
                let isSuccess = isLogin ? await authViewModel.signIn() : await authViewModel.signUp()
                if isSuccess {
                    onAuthSuccess()
                }
            }
        }
        .disabled(!isFormValid || authViewModel.isLoading)
    }
    
    private var divider: some View {
        HStack {
            DividerView()
            Text("OR")
                .foregroundStyle(Color(.secondaryLabel))
                .font(.caption)
                .fontWeight(.bold)
            DividerView()
        }
    }
    
    private var googleButton: some View {
        GoogleButton {
            Task {
                let isSuccess = await authViewModel.signInWithGoogle()
                if isSuccess {
                    onAuthSuccess()
                }
            }
        }
        .disabled(authViewModel.isLoading)
    }
    
    private var description: some View {
        FormDescription(isLogin: $isLogin) {
            authViewModel.clearInput()
        }
    }
    
    private var isFormValid: Bool {
        isLogin ? authViewModel.isLoginValid : authViewModel.isSignUpValid
    }
    
    private var authErrorPresented: Binding<Bool> {
        Binding {
            authViewModel.errorMessage != nil
        } set: { isPresented in
            if !isPresented {
                authViewModel.clearError()
            }
        }
    }
}

#Preview {
    AuthView(authViewModel: AuthViewModel(authService: FirebaseAuthService()))
}
