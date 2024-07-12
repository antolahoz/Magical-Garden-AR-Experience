//
//  ModelState.swift
//  Magical Garden
//
//  Created by Antonio Lahoz on 09/07/24.
//

import Foundation

///It defines several possible states for a model, each represented by a case
enum ModelState{
    
    ///The model isn't placed yet
    case dormant
    ///The model is placed and starts its "growing" phase
    case growing
    ///The growing phase is finished: the timer has expired
    case timerExpired
    ///The model has been tapped and transforms to its complete growth
    case bloom
}
