//
//  ARViewContainer.swift
//  Magical Garden
//
//  Created by Antonio Lahoz on 05/07/24.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit
import Combine

///This struct implements SwiftUI's UIViewRepresentable protocol to integrate an ARView into a SwiftUI interface.
///It manages the configuration of the ARView, including plane detection, environmental texturing, and scene reconstruction.
struct ARViewContainer: UIViewRepresentable {
    
    ///An observable instance of the visualization model (ARViewModel) that contains the data and logic to manage the 3D models.
    @ObservedObject var viewModel: ARViewModel
    
    ///It creates and configures an augmented reality view used in a SwiftUI interface.
    ///It configures the AR session with plane detection, environment texturing, and scene reconstruction.
    ///It also adds a coaching manager and a touch gesture recognizer.
    ///
    /// - Parameters:
    ///   - context: The context that provides information and coordinates to create and manage the view.
    /// - Returns: A configured augmented reality view.
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic

        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
            config.sceneReconstruction = .meshWithClassification
        }

        arView.session.run(config)
        arView.addCoaching()
        context.coordinator.arView = arView

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTapGesture(_:)))

        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    ///It is a part of SwiftUI's UIViewRepresentable protocol.
    ///This function is called when SwiftUI detects that the represented view needs to be updated.
    ///
    /// - Parameters:
    ///   - uiView: The augmented reality view (ARView) that needs to be updated.
    ///   - context: The context that provides useful information for updating the view, such as the coordinator.
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    ///It is part of the UIViewRepresentable protocol in SwiftUI.
    ///This function is used to create a coordinator that acts as a bridge between the UIView and SwiftUI, allowing for event handling and coordination of interactions.
    ///
    /// - Returns: An instance of the Coordinator class that is used to handle events and coordinate interactions between the UIView and SwiftUI.
    func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel: viewModel)
    }
    
    ///This class handles the interactions between the view model (viewModel) and the augmented reality view (ARView).
    ///It is responsible for loading and transforming 3D models, handling user gestures, and updating model states.
    class Coordinator: NSObject {
        
        ///The visualization model that contains the data and logic to manage the 3D models.
        var viewModel: ARViewModel
        
        ///The augmented reality view in which the 3D models are displayed
        var arView: ARView?
        
        ///A set of erasable objects used to manage Combine type combiner subscriptions.
        private var cancellables = Set<AnyCancellable>()
        
        init(viewModel: ARViewModel) {
            self.viewModel = viewModel
            super.init()
            self.setupBindings()
        }


        ///It is used to configure bindings between the viewModel and the AR view (arView).
        ///This function observes changes to the selected model in the viewModel and, in response, places the updated model in the AR view.
        func setupBindings() {
            viewModel.$selectedModel
                .sink { [weak self] selectedModel in
                    guard let self = self, let arView = self.arView, let selectedModel = selectedModel else { return }
                    self.placeModel(named: selectedModel.fileName, in: arView)
                    print("Updated model state to: \(selectedModel.state)")

                }
                .store(in: &cancellables)
        }
        
        ///It is used to load a 3D model into an augmented reality (AR) view and manage interactions related to the model.
        ///
        ///- Parameters:
        ///  - modelName: The name of the 3D model to be uploaded
        ///  - arView: The augmented reality view in which the model will be placed
        func placeModel(named modelName: String, in arView: ARView) {
            
            guard let modelEntity = viewModel.loadModel(named: modelName) else {
                print("Failed to load model \(modelName)")
                return
            }
            
            print("Placing model \(modelName) in AR view.")
            modelEntity.name = modelName
            
            let anchorEntity = AnchorEntity(plane: .horizontal)
            anchorEntity.addChild(modelEntity)
            modelEntity.generateCollisionShapes(recursive: true)
            arView.installGestures([.all], for: modelEntity as Entity & HasCollision)
            arView.scene.anchors.append(anchorEntity)
            
            print("Model \(modelName) added to the scene.")
            
            if let model = viewModel.models.first(where: { $0.fileName == modelName }) {
                viewModel.updateModelState(model, to: .growing)
                viewModel.startTimer(for: model)
            }
        }
        
        ///It is used to find, remove, and replace an existing 3D model in an AR view with a transformed version of that model, updating the model state.
        ///
        ///- Parameters:
        /// - model: An instance of ARModel that contains the necessary information about the original model and the transformed model.
        /// - arView: The augmented reality view in which the existing model needs to be transformed.
        func transformModel(_ model: ARModel, in arView: ARView) {
            guard let anchorEntity = arView.scene.anchors.first(where: { anchor in
                anchor.children.compactMap { $0 as? ModelEntity }.contains { $0.name == model.fileName }
            }) else { return }
            anchorEntity.children.removeAll()
            guard let transformedModelEntity = viewModel.loadModel(named: model.transformedFileName) else {
                print("Failed to load transformed model \(model.transformedFileName)")
                return
            }
            anchorEntity.addChild(transformedModelEntity)
            
            viewModel.updateModelState(model, to: .bloom)
        }
        
        ///It handles touch gesture (tap) recognition on an augmented reality view.
        ///It checks whether a model entity  has been tapped and, based on the model state, performs a transformation and updates the model state.
        ///
        /// - Parameters:
        ///   - recognizer: An optional touch gesture recognizer that detects taps within the view.
        @objc
        func handleTapGesture(_ recognizer: UITapGestureRecognizer? = nil) {
            guard let view = arView else { return }
            let tapLocation = recognizer!.location(in: view)
            if let entity = view.entity(at: tapLocation) as? ModelEntity {
                print("Entity tapped")
                
                if let model = viewModel.models.first(where: { $0.fileName == entity.name }) {
                    if model.state == .timerExpired {
                        viewModel.updateModelState(model, to: .bloom)
                        self.transformModel(model, in: view)
                        print("Updated model state to: \(model.state)")
                    }
                }
            }
        }
    }
}
