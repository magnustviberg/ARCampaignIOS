//
//  CampaignManager.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import Foundation
import Zip

public protocol CampaignManagerProtocol {
    func fetchCampaign(completion: @escaping (CampaignInfo?, Data?, URL?, Error?) -> Void)
    func fetchCampaignInfo(completion: @escaping (Result<CampaignInfo>) -> Void)
    func fetchTrackingImage(from url: URL, completion: @escaping (Data?, Error?) -> Void)
    func fetchModel(from url: URL, completion: @escaping (URL?, Error?) -> Void)
}

public class CampaignManager: CampaignManagerProtocol {
    
    private var fetchImageError: Error?
    private var fetchedImageData: Data?
    private var fetchedModelError: Error?
    private var fetchedModelURL: URL?
    
    public init() {
        guard ARCampaignApp.isConfigured else { fatalError(ARCampaignError.missingConfiguration.errorMessage)}
    }
    
    public func fetchCampaign(completion: @escaping (CampaignInfo?, Data?, URL?, Error?) -> Void) {
        WebService.sharedInstance.request(CampaignEndpoint.getCampaign) { (result: Result<Data>) in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                do {
                    let campaignInfo = try decoder.decode(CampaignInfo.self, from: data)
                    let group = DispatchGroup()
                    
                    group.enter()
                    self.fetchTrackingImage(from: campaignInfo.trackingImageInfo.url, completion: { (imageData, error) in
                        self.fetchImageError = error
                        self.fetchedImageData = imageData
                        group.leave()
                    })
                    
                    group.enter()
                    self.fetchModel(from: campaignInfo.modelURL, completion: { (storageUrl, error) in
                        self.fetchedModelError = error
                        self.fetchedModelURL = storageUrl
                        group.leave()
                    })
                    
                    group.notify(queue: DispatchQueue.main) {
                        if let imageError = self.fetchImageError {
                            completion(nil, nil, nil, imageError)
                        } else if let modelURLError = self.fetchedModelError {
                            completion(nil, nil, nil, modelURLError)
                        } else if let imageData = self.fetchedImageData, let url = self.fetchedModelURL {
                            completion(campaignInfo ,imageData, url, nil)
                        } else {
                            fatalError()
                        }
                    }
                }
                catch {
                    completion(nil, nil, nil, HTTPResponseError.cannotParse)
                }
            case .failure(let error):
                completion(nil, nil, nil, ARCampaignError.errorWithMessage(error.localizedDescription))
            }
        }
    }
    
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
    
    func fetchTrackingImage(from urlString: String?, completion: @escaping (Data?, Error?) -> Void) {
        guard let urlString = urlString else { fatalError() }
        let newString = urlString.replacingOccurrences(of: "http://localhost:8000", with: "http://e8e979d2.ngrok.io")
        
        guard let url = URL(string: newString) else {
            completion(nil, HTTPResponseError.responseErrorWith(message: "ERROR: Could not make URL from urlString"))
            return
        }
        
        fetchTrackingImage(from: url) { (data, error) in
            completion(data, error)
        }
    }
    
    public func fetchTrackingImage(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        completion(imageData, nil)
                    } else {
                        completion(nil, HTTPResponseError.responseErrorWith(message: "ERROR: No data"))
                    }
                } else {
                    completion(nil, HTTPResponseError.responseErrorWith(message: "ERROR: Couldn't get response code for some reason"))
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
    func fetchModel(from urlString: String?, completion: @escaping (URL?, Error?) -> Void) {
        guard let urlString = urlString else {
            fatalError()
        }
        
        let newString = urlString.replacingOccurrences(of: "http://localhost:8000", with: "http://e8e979d2.ngrok.io")
            
        guard let url = URL(string: newString) else {
            completion(nil, HTTPResponseError.responseErrorWith(message: "ERROR: Could not make URL from urlString"))
            return
        }
        fetchModel(from: url) { (url, error) in
            completion(url, error)
        }
    }
    
    public func fetchModel(from url: URL, completion: @escaping (URL?, Error?) -> Void) {
        
        let modelTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                guard let error = error else {
                    completion(nil, ARCampaignError.errorWithMessage("No data"))
                    return
                }
                completion(nil, ARCampaignError.errorWithMessage(error.localizedDescription))
                return
            }
            let url = self.store(data: dataResponse)
            
            do {
                let unzipDirectory = try Zip.quickUnzipFile(url) // Unzip
                let fileManager = FileManager()
                let enumerator = fileManager.enumerator(at: unzipDirectory, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey, URLResourceKey.localizedNameKey])
                guard let emr = enumerator else {
                    completion(nil, ARCampaignError.unzipFromURLFailed)
                    return
                }
                
                guard let filePaths = emr.allObjects as? [URL] else {
                    completion(nil, ARCampaignError.unzipFromURLFailed)
                    return
                }
                let scnFiles = filePaths.filter{URL(fileURLWithPath: $0.absoluteString, relativeTo: unzipDirectory).path.hasSuffix(".scn")}
                guard let scnFile = scnFiles.first else {
                    completion(nil, ARCampaignError.unzipFromURLFailed)
                    return
                }
                completion(scnFile, nil)
            }
            catch (let error) {
                print(error.localizedDescription)
                completion(nil, ARCampaignError.unzipFromURLFailed)
            }
        }
        modelTask.resume()
    }
    
    private func store(data: Data) -> URL {
        
        let tempDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        let targetURL = tempDirectoryURL.appendingPathComponent("scnTemp.zip")
        
        do {
            try data.write(to: targetURL)
        } catch let error {
            NSLog("Unable to copy file: \(error)")
        }
        
        return targetURL
    }
    
}
