//
//  ViewController.swift
//  ARCampaign
//
//  Created by magnustviberg on 03/08/2019.
//  Copyright (c) 2019 magnustviberg. All rights reserved.
//

import UIKit
import ARCampaign

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let simpleVC = SimpleARCampaignViewController()
        present(simpleVC, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

