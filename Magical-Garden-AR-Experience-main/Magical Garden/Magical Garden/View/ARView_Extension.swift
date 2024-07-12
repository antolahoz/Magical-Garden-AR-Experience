//
//  ARView_Extension.swift
//  Magical Garden
//
//  Created by Antonio Lahoz on 05/07/24.
//

import ARKit
import RealityKit

extension ARView: ARCoachingOverlayViewDelegate{
    
    ///This function activates the ARCoaching experience in order to instruct the user on gathering required info for the AR session
    func addCoaching(){
        let coachingOverlay = ARCoachingOverlayView()

        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(coachingOverlay)
    }
}
