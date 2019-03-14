//
//  ViewController.swift
//  ARCampaign
//
//  Created by magnustviberg on 03/08/2019.
//  Copyright (c) 2019 magnustviberg. All rights reserved.
//

import UIKit
import ARCampaign
import ARKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let simpleVC = SimpleARCampaignViewController()
        present(simpleVC, animated: true, completion: nil)
        
        let manager = CampaignManager()
        manager.fetchCampaign { (campaignInfo, imageData, modelURL, error) in
            if error != nil {
                // Handle error
            } else {
                // get the tracking image width
                guard let width = campaignInfo?.trackingImageInfo.width else { return }
                
                // get tracking image
                guard let imageData = imageData else { return }
                guard let image = UIImage(data: imageData) else { return }
                
                // create a ARReferenceImage
                let arImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(width))
                
                // get the 3D model
                guard let url = modelURL else { return }
                guard let scene = try? SCNScene.init(url: url, options: nil) else { return }
                let modelNode = scene.rootNode
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

