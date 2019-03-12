//
//  ARCampaignApp.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import Foundation

public class ARCampaignApp {
    
    static let sharedInstance = ARCampaignApp()
    private init() { }
    
    static let baseURLKey: String = "BaseURL"
    static let campaignIdKey: String = "CampaignID"
    static let bundleIdKey: String = "BundleID"
    static let apiKey: String = "APIKey"
    
    static var databaseURLString: String!
    static var apiKeyString: String!
    static var campaignId: String!
    
    static var isConfigured = false
    
    public static func configure() {
        if let url = Bundle.main.url(forResource: "ARCampaign", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                let infoDictionary = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String:Any]
                guard let bundleID = infoDictionary[bundleIdKey] as? String else {
                    fatalError(ARCampaignError.missingBundle.errorMessage)
                }
                guard validateBundle(id: bundleID) else {
                    fatalError(ARCampaignError.invalidBundle.errorMessage)
                }
                guard let baseUrl = infoDictionary[baseURLKey] as? String else {
                    fatalError(ARCampaignError.missingBaseUrl.errorMessage)
                }
                guard let apiKey = infoDictionary[apiKey] as? String else {
                    fatalError(ARCampaignError.missingAPIKey.errorMessage)
                }
                guard let campaignId = infoDictionary[campaignIdKey] as? String else {
                    fatalError(ARCampaignError.missingCampaignId.errorMessage)
                }
                self.databaseURLString = baseUrl
                self.apiKeyString = apiKey
                self.campaignId = campaignId
                self.isConfigured = true
            } catch (let error) {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError(ARCampaignError.missingPlist.errorMessage)
        }
    }
    
    static func validateBundle(id: String) -> Bool{
        guard let projectBundleIdentifier = Bundle.main.bundleIdentifier else {
            print("ERROR: Need to set a bundle identifier for this project")
            return false
        }
        guard projectBundleIdentifier == id else {
            print("ERROR: Bundle identifier in plist needs to be the same as the project bundle identifier")
            return false
        }
        return true
    }
    
}
