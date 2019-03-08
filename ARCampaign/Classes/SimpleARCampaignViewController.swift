//
//  SimpleARCampaignViewController.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import UIKit
import SceneKit
import SceneKit.ModelIO
import ARKit

@available(iOS 12.0, *)
public class SimpleARCampaignViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var model: SCNNode?
    private var modelUrl: URL?
    private let viewModel: SimpleARCampaignViewModel = SimpleARCampaignViewModel()
    private var customReferenceSet = Set<ARReferenceImage>()
    
    /// View Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchProject { (data, url, error)  in
            if error != nil {
                guard let error = error as? ARCampaignError else { fatalError() }
                self.presentAlert(campaignError: error)
            } else {
                guard let imageData = data else { fatalError() }
                guard let width = self.viewModel.trackingImageWidth else { fatalError() }
                let image = UIImage(data: imageData)!
                let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(width))
                self.customReferenceSet.insert(arImage)
                self.setupImageTracking()
                
                guard let url = url else {
                    self.presentAlert(campaignError: ARCampaignError.localModelUrlMissing)
                    return
                }
                guard let model = self.getModel(from: url) else {
                    self.presentAlert(campaignError: ARCampaignError.localModelUrlMissing)
                    return
                }
                self.model = model
            }
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @available(iOS 12.0, *)
    private func setupImageTracking(){
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = self.customReferenceSet
        configuration.maximumNumberOfTrackedImages = 1
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func getModel(from url: URL) -> SCNNode?{
        //guard let shipScene = try? SCNScene.init(url: url, options: nil) else { return }
        let modelScene = SCNScene(named:
            "art.scnassets/trophy.scn")!
        
        let shipNode: SCNNode = modelScene.rootNode.childNode(withName: "Cube", recursively: true)!
        return shipNode //shipScene.rootNode
    }
    
}

/*
 let campaignVC = ARCampaignViewController()
 campaignVC.config(campaignName: "julekampanje")
 campaingVC.detectHandler = {
 
 }
 
 let vc = ViewController()
 present(vc)
 }
 
 import ARKit
 class ÆCampaignVC: ViewController, ARSCNViewDelegate {
 
 override func viewDidAppear(_ animated: Bool) {
 ARCampaignManager.triggerImage ( images, error ) {
 let config = ARImageTrackingConfiguration().trackingImages = images
 config.run()
 }
 }
 
 func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
 ARCampagnManager.modelForWinner{
 modelNode.childNode(withName: "ship")
 }
 }
 
 */
