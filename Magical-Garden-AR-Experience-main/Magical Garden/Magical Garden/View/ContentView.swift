//
//  ContentView.swift
//  Magical Garden
//
//  Created by Antonio Lahoz on 02/07/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    
    ///This property manages the persistent state of the indicator to show or hide the onboarding screen.
    ///It uses @AppStorage to maintain the state even after the application is closed.
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding = true
    
    ///This property creates and maintains an instance of ARViewModel as a state object.
    ///ARViewModel is responsible for handling data and interactions related to augmented reality.
    @StateObject private var viewModel = ARViewModel()
    
    var body: some View {
        
        NavigationStack{
            ZStack(alignment: .bottom) {
                ARViewContainer(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
                
                HStack {
                    ForEach(viewModel.models) { model in
                        Button(action: {
                            viewModel.selectModel(model)
                        }) {
                            Text(model.name)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
                OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
                .preferredColorScheme(.dark)

            })
    }
}

#Preview {
    ContentView()
}
