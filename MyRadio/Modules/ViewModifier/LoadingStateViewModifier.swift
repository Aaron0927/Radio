//
//  LoadingStateViewMOdifier.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/17.
//

import SwiftUI

struct LoadingStateViewModifier: ViewModifier {
    @Binding var isLoading: Bool
    
    func body(content: Content) -> some View {
        if isLoading {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
        } else {
            content
        }
    }
}

extension View {
    func loadingState(_ isLoading: Binding<Bool>) -> some View {
        modifier(LoadingStateViewModifier(isLoading: isLoading))
    }
}
