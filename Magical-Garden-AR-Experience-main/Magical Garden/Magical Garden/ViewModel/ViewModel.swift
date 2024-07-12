//
//  ViewModel.swift
//  Magical Garden
//
//  Created by Antonio Lahoz on 03/07/24.
//

import SwiftUI
import Combine
import RealityKit

///This class  manage the business logic and state of AR models within the application
class ARViewModel: ObservableObject {
    
    ///An ARModel array representing the AR models managed by the application.
    ///It is annotated with @Published to ensure that changes made to it are automatically propagated to observers, such as the SwiftUI view that uses it
    @Published var models: [ARModel] = [
        ARModel(name: "Plant 1", fileName: "Plant_01_Growth", transformedFileName: "Plant_01_Bloom", timeInterval: Double.random(in: 30...180)),
        ARModel(name: "Plant 2", fileName: "Plant_02_Growth", transformedFileName: "Plant_02_Bloom", timeInterval: Double.random(in: 30...180)),
        ARModel(name: "Plant 3", fileName: "Plant_03_Growth", transformedFileName: "Plant_03_Bloom", timeInterval: Double.random(in: 30...180))
    ]
    
    ///Un modello AR opzionale che rappresenta il modello attualmente selezionato dall'utente.
    ///È annotato con @Published per rendere visibile il cambiamento dello stato del modello selezionato agli observer.
    @Published var selectedModel: ARModel?
    
    
    ///It sets the AR model selected by the user.
    ///When a model is selected, it can trigger specific actions or display additional details in the UI.
    ///
    /// - Parameters:
    ///   - model: The AR model to be selected.
    func selectModel(_ model: ARModel) {
        selectedModel = model
    }
    
    ///It is designed to load a 3D model represented by a ModelEntity object.
    ///
    /// - Parameters:
    ///   - modelName: Represents the name of the 3D model to be loaded.
    ///                It is essential that this name exactly matches the name of the model file in the application bundle.
    func loadModel(named modelName: String) -> ModelEntity? {
        do {
            let modelEntity = try ModelEntity.loadModel(named: modelName)
            print("Model \(modelName) loaded successfully.")
            return modelEntity
        } catch {
            print("Failed to load model \(modelName): \(error)")
            return nil
        }
    }
    
    ///It is used to update the state of a model within an instance of ARViewModel.
    ///
    /// - Parameters:
    ///   - model: An instance of ARModel representing the model to be updated.
    ///   - newState: A value of type ModelState representing the new state to be assigned to the model.
    func updateModelState(_ model: ARModel, to newState: ModelState){
        
        if let i = models.firstIndex(where: { $0.id == model.id }) {
            models[i].state = newState
        }
    }
    
    ///It starts a timer for a specific model within an ARViewModel instance.
    ///When the timer expires, the state of the model is updated to .timerExpired
    ///
    /// - Parameters:
    ///   - model: An instance of ARModel for which you want to start the timer.
    func startTimer(for model: ARModel){
        if let i = models.firstIndex(where: { $0.id == model.id}) {
            models[i].timer = Timer.scheduledTimer(withTimeInterval: model.timeInterval, repeats: false){ [weak self] _ in
                self?.updateModelState(model, to: .timerExpired)
                print("Timer scaduto")
                print("\(model.state)")
            }
        }
    }
}

