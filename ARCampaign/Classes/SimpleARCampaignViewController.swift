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
    
    lazy var sceneView: ARSCNView = {
        let view = ARSCNView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var testImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tutorialView: TutorialView = {
        let view = TutorialView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var model: SCNNode?
    private var modelUrl: URL?
    private let viewModel: SimpleARCampaignViewModel = SimpleARCampaignViewModel()
    private var customReferenceSet = Set<ARReferenceImage>()
    
    /// View Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        setupViews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchCampaign { (campaignInfo, imageData, modelUrl, error) in
            if error != nil {
                guard let error = error as? ARCampaignError else { fatalError() }
                self.presentAlert(campaignError: error)
            } else {
                guard let imageData = imageData else { fatalError() }
                guard let width = campaignInfo?.trackingImageInfo.width else { fatalError() }
                let image = UIImage(data: imageData)!
                let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(width))
                self.customReferenceSet.insert(arImage)
                self.setupImageTracking()
                
                /*self.view.addSubview(self.testImageView)
                NSLayoutConstraint.activate([
                    self.testImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
                    self.testImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                    self.testImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                    self.testImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                    ])
                
                self.testImageView.image = UIImage(data: imageData)*/
                
                guard let url = modelUrl else {
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
    
    func setupViews() {
        self.view.addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: self.view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        /*self.view.addSubview(tutorialView)
        NSLayoutConstraint.activate([
            tutorialView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tutorialView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tutorialView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tutorialView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])*/
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
        configuration.maximumNumberOfTrackedImages = 4
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func getModel(from url: URL) -> SCNNode?{
        guard let shipScene = try? SCNScene.init(url: url, options: nil) else { return nil }
        //let modelScene = SCNScene(named: "art.scnassets/trophy.scn")!
        //let shipNode: SCNNode = modelScene.rootNode.childNode(withName: "Cube", recursively: true)!
        return shipScene.rootNode // shipNode
    }
    
}
