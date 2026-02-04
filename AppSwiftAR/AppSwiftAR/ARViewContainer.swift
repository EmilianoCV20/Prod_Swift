//
//  ARViewContainer.swift
//  AppSwiftAR
//
//  Created by Emiliano Cepeda on 13/12/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer : UIViewRepresentable {
    @Binding var modelName: String
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            print( "ARWorldTrackingConfiguration is not supported")
            return arView
        }
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal,.vertical]
        config.environmentTexturing = .automatic
        
        arView.session.run(config)
        return arView
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {
        let anchorEntity = AnchorEntity(plane: .any)
        guard let modelEntity = try? Entity.loadModel(named: modelName) else { return }
        
        anchorEntity.addChild(modelEntity)
        
        uiView.scene.addAnchor(anchorEntity)
    }
}
