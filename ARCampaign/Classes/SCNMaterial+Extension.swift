//
//  SCNMaterial+Extension.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import Foundation
import SceneKit

extension SCNMaterial {
    convenience init(diffuse: Any?) {
        self.init()
        self.diffuse.contents = diffuse
        isDoubleSided = true
        lightingModel = .physicallyBased
    }
}

