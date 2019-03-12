//
//  MockCampaignManager.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import Foundation

public class MockCampaignManager: CampaignManagerProtocol {
    func fetchCampaign(completion: @escaping (CampaignInfo?, Data?, URL?, Error?) -> Void) {
        completion(nil, nil, nil, ARCampaignError.errorWithMessage("no data"))
    }
    
    
    public func fetchCampaignInfo(completion: @escaping (Result<CampaignInfo>) -> Void) {
        completion(Result.failure(ARCampaignError.errorWithMessage("orker ikke implementere dette")))
    }
}
