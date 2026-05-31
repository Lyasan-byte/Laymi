//
//  FormDescription.swift
//  Laymi
//
//  Created by Ляйсан
//

import SwiftUI

struct FormDescription: View {
    @Binding var isLogin: Bool
    var action: () -> ()
    
    var body: some View {
        HStack {
            Text(isLogin ? "Don't have an account?" : "Already have an account?")
            Text(isLogin ? "Sign Up" : "Login")
                .fontWeight(.semibold)
                .foregroundStyle(isLogin ? .brightPurple : .brightOrange)
                .onTapGesture {
                    action()
                    withAnimation {
                        isLogin.toggle()
                    }
                }
        }
    }
}
