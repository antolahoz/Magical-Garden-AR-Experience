//
//  OnBoardingView.swift
//  Magical Garden
//
//  Created by Antonio Lahoz on 11/07/24.
//

import SwiftUI

///It is a view that shows an introduction experience with several pages through a TabView.
///Each page provides instructions on how to use the augmented reality (AR) experience.
struct OnboardingView: View {
    
    ///A boolean binding that controls whether onboarding should be shown or hidden.
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        TabView{
            PageView(title: "Coaching session",
                     message: "Set the AR space following the instructions",
                     imageName: "plus.viewfinder",
                     showsDismissButton: false,
                     shouldShowOnboarding: $shouldShowOnboarding)
            PageView(title: "Choose a plant",
                     message: "Click on it pointing at the space where you want to place the plant",
                     imageName: "leaf.fill",
                     showsDismissButton: false,
                     shouldShowOnboarding: $shouldShowOnboarding)
            PageView(title: "The Call",
                     message: "Wait as long as it takes for the plant to grow and click on it to watch it bloom!",
                     imageName: "timer",
                     showsDismissButton: false,
                     shouldShowOnboarding: $shouldShowOnboarding)
            PageView(title: "Play the experience!",
                     message: "Immerse yourself in this AR experience!",
                     imageName: "play.fill",
                     showsDismissButton: true,
                     shouldShowOnboarding: $shouldShowOnboarding)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
