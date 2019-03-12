//
//  CampaignEndpoint.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import Foundation

//MARK: - UserEndpoints
public enum CampaignEndpoint: Endpoint{
    case getCampaign
    
    var baseUrl: URL {
        return URL(string: ARCampaignApp.databaseURLString)!
    }
    
    var apiKey: String {
        return ARCampaignApp.apiKeyString
    }
    
    var httpMethod: HTTPMethod{
        switch self {
        case .getCampaign: return .get
        }
    }
    
    var request: URLRequest{
        let path: String
        switch self{
        case .getCampaign: path = "/campaign/\(ARCampaignApp.campaignId!)"
        }
        
        return try! requestforEndpoint(path)
    }
    
    var body: Data?{
        switch self{
        case .getCampaign: return nil
        }
    }
}
