//
//  MockCampaignManager.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import Foundation

public class MockCampaignManager: CampaignManagerProtocol {
    
    public func fetchCampaignInfo(completion: @escaping (Result<CampaignInfo>) -> Void) {
        completion(Result.success(CampaignInfo(modelURL: "https://api.geit.no/scene", trackingImageInfo: TrackingImageResponse(url: "https://i.imgur.com/k62s9en.jpg", width: 0.13))))
    }
}
