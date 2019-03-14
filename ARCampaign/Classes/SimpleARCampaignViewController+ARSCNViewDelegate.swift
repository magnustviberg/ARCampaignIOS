//
//  SimpleARCampaignViewController+ARSCNViewDelegate.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import ARKit

// MARK: - ARSCNViewDelegate
@available(iOS 12.0, *)
extension SimpleARCampaignViewController: ARSCNViewDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor =  anchor as? ARImageAnchor {
            let imageSize = imageAnchor.referenceImage.physicalSize
            
            let plane = SCNPlane(width: CGFloat(imageSize.width), height: CGFloat(imageSize.height))
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let imageHightingAnimationNode = SCNNode(geometry: plane)
            imageHightingAnimationNode.eulerAngles.x = -.pi / 2
            imageHightingAnimationNode.opacity = 1
            imageHightingAnimationNode.setNodeToOccluder()
            
            guard let model = model else { fatalError("No Model") }
            
            // create and add a light to the scene
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light!.type = .omni
            lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
            model.addChildNode(lightNode)
            
            // create and add an ambient light to the scene
            let ambientLightNode = SCNNode()
            ambientLightNode.light = SCNLight()
            ambientLightNode.light!.type = .ambient
            ambientLightNode.light!.color = UIColor.darkGray
            model.addChildNode(ambientLightNode)
            
            model.position.x = imageHightingAnimationNode.position.x
            model.position.y = imageHightingAnimationNode.position.y
            model.position.z = imageHightingAnimationNode.position.z + (model.boundingBox.max.z - model.boundingBox.min.z)/2
            
            imageHightingAnimationNode.addChildNode(model)
            
            node.addChildNode(imageHightingAnimationNode)
            
            /*
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let alert = UIAlertController(title: "🎉 Gratulerer du vant! 🎉", message: "Skriv inn epostadressen din for å motta premien din😀", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "Jippi!", style: UIAlertAction.Style.cancel, handler: { (_) in
                    
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: {
                    
                })
            }*/
        }
    }
    
    private func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Error didFailWithError: \(error.localizedDescription)")
    }
    
    private func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("Error sessionWasInterrupted: \(session.debugDescription)")
    }
    
    private func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("Error sessionInterruptionEnded : \(session.debugDescription)")
    }
}

@available(iOS 12.0, *)
extension SimpleARCampaignViewController: ARSessionDelegate {
    public func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .notAvailable:
            print(".notAvailable")
        case .limited(_):
            print("limited")
        case .normal:
            print("normal")
        }
    }
}
