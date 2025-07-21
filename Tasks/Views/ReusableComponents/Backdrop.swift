//
//  Backdrop.swift
//  Tasks
//
//  Created by Rahul Serodia on 21/07/25.
//

import SwiftUI

struct FullScreenBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Image(ImageConstants.backdrop)
                .resizable()
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func fullScreenBackground() -> some View {
        self.modifier(FullScreenBackground())
    }
}
