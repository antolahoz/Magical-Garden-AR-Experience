//
//  ARmodel.swift
//  Magical Garden
//
//  Created by Antonio Lahoz on 03/07/24.
//

import Foundation
import RealityKit

///It represents a 3D model.
struct ARModel: Identifiable {
    
    ///Unique model identifier, generated as a UUID
    let id = UUID()
    ///The name of the model
    let name: String
    ///Name of the file that contains the original 3D model.
    ///This is the file used to load the model into the AR scene.
    let fileName: String
    ///Name of the file containing the transformed 3D model.
    let transformedFileName: String // File name for the transformed state
    
    ///Current state of the model
    var state: ModelState = .dormant
    ///Timer to handle the state change
    var timer: Timer?
    ///Time interval for the timer
    var timeInterval: TimeInterval
}
