//
//  MockCampaignManager.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import Foundation

public class MockCampaignManager: CampaignManagerProtocol {
    public func fetchTrackingImage(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        completion(nil, nil)
    }
    
    public func fetchModel(from url: URL, completion: @escaping (URL?, Error?) -> Void) {
        completion(nil, nil)
    }
    
    public func fetchCampaign(completion: @escaping (CampaignInfo?, Data?, URL?, Error?) -> Void) {
        completion(nil, nil, nil, ARCampaignError.errorWithMessage("no data"))
    }
    
    public func fetchCampaignInfo(completion: @escaping (Result<CampaignInfo>) -> Void) {
        completion(Result.failure(ARCampaignError.errorWithMessage("orker ikke implementere dette")))
    }
}
