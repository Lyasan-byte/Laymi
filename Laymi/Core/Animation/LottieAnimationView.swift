//
//  LottieAnimationView.swift
//  Laymi
//
//  Created by Ляйсан
//

import Lottie
import SwiftUI

struct LottieAnimationView: View {
    let fileName: String
    
    var body: some View {
        LottieView(animation: .named(fileName))
            .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .loop)))
            .animationSpeed(0.7)
    }
}

#Preview {
    LottieAnimationView(fileName: "Loading")
}
