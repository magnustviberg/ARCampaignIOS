//
//  TrackingImageResponse.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import Foundation

public struct TrackingImageResponse {
    var url: String
    var width: Float32
    
    enum CodingKeys: String, CodingKey {
        case url = "imageUrl"
        case width
    }
}

extension TrackingImageResponse: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decode(String.self, forKey: .url)
        width = try values.decode(Float32.self, forKey: .width)
    }
}
