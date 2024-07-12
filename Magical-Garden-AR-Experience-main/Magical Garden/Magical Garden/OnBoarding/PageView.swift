//
//  PageView.swift
//  Magical Garden
//
//  Created by Antonio Lahoz on 11/07/24.
//

import Foundation
import SwiftUI

///It is a view that represents a single page in the onboarding of an application.
///Each page contains an image, a title, a descriptive message, and a button to close the onboarding.
struct PageView: View {
    
    ///The title of the page
    let title: String
    ///The descriptive message of the page.
    let message: String
    ///The name of the system image to be displayed.
    let imageName: String
    ///A boolean indicating whether the page should show a button to close onboarding.
    let showsDismissButton: Bool
    ///A boolean binding that controls whether onboarding should be shown or hidden.
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        VStack{
            
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundStyle(.blue)
                .padding()
            
            Text(title)
                .font(.system(size: 32))
                .padding()
            
            Text(message)
                .font(.system(size: 24))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding()
            
            if showsDismissButton{
                Button(action: {
                    shouldShowOnboarding.toggle()
                }, label: {
                    Text("Get started")
                        .bold()
                        .foregroundStyle(.white)
                        .frame(width: 200, height: 50)
                        .background(.blue)
                        .cornerRadius(6)
                })
            }
        }
    }
}
