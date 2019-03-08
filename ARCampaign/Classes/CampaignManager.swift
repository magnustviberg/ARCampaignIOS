//
//  CampaignManager.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import Foundation

public struct CampaignInfo: Codable {
    let modelURL: String
    let trackingImageInfo: TrackingImageResponse
}

protocol CampaignManagerProtocol {
    func fetchCampaignInfo(completion: @escaping (Result<CampaignInfo>) -> Void)
}

public class CampaignManager: CampaignManagerProtocol {
    
    public func fetchCampaignInfo(completion: @escaping (Result<CampaignInfo>) -> Void) {
        WebService.sharedInstance.request(CampaignEndpoint.getCampaign) { (result: Result<Data>) in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let campaignInfo = try decoder.decode(CampaignInfo.self, from: data)
                    completion(Result.success(campaignInfo))
                }
                catch {
                    completion(Result.failure(HTTPResponseError.cannotParse))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
}
