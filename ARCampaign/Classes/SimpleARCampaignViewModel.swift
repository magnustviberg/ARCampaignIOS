//
//  SimpleARCampaignViewModel.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import Foundation
import Zip

@available(iOS 12.0, *)
class SimpleARCampaignViewModel {
    let campaignManager: CampaignManagerProtocol = CampaignManager()
    private var campaignInfo: CampaignInfo?
    
    var modelURL: String? {
        return campaignInfo?.modelURL
    }
    
    var trackingImageURL: URL? {
        return URL(string: campaignInfo?.trackingImageInfo.url ?? "")
    }
    
    var trackingImageWidth: Float32? {
        return campaignInfo?.trackingImageInfo.width
    }
    
    func fetchCampaign(completion: @escaping (CampaignInfo?, Data?, URL?, Error?) -> Void) {
        campaignManager.fetchCampaign { (info, data, url, error) in
            completion(info, data, url, error)
        }
    }
    
    init() {
        print("")
    }
    
}
