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
    
    static let downloadPlistUrl: String = "https://www.geit.no"
    static let databaseURLKey: String = "Database URL"
    static let projectIdKey: String = "Project id"
    static let bundleIdKey: String = "Bundle id"
    static let apiKey: String = "API Key"
    
    static var databaseURLString: String!
    static var apiKeyString: String!
    
    public static func configure() {
        
        if let url = Bundle.main.url(forResource:"ARCampaignInfo", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                let infoDictionary = try PropertyListSerialization.propertyList(from: data, format: nil) as! [String:Any]
                
                // validate bundle ID
                guard let bundleID = infoDictionary[bundleIdKey] as? String else { return }
                guard validateBundle(id: bundleID) else { return }
                print("BUNDLE IS VALID!!")
                guard let baseUrl = infoDictionary[databaseURLKey] as? String else { print("no database url"); return }
                databaseURLString = baseUrl
                print(databaseURLString)
                guard let apiKey = infoDictionary[apiKey] as? String else { print("no api key"); return }
                apiKeyString = apiKey
            } catch {
                print(error)
            }
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
