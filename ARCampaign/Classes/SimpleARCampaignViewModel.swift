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
    let campaignManager: CampaignManagerProtocol = MockCampaignManager()
    private var campaignInfo: CampaignInfo?
    
    private var fetchImageError: Error?
    private var fetchedImageData: Data?
    private var fetchedModelError: Error?
    private var fetchedModelURL: URL?
    
    var modelURL: String? {
        return campaignInfo?.modelURL
    }
    
    var trackingImageURL: URL? {
        return URL(string: campaignInfo?.trackingImageInfo.url ?? "")
    }
    
    var trackingImageWidth: Float32? {
        return campaignInfo?.trackingImageInfo.width
    }
    
    func fetchProject(completion: @escaping (Data?, URL?, Error?) -> Void) {
        
        campaignManager.fetchCampaignInfo { (result) in
            switch result {
            case .success(let campaignInfo):
                self.campaignInfo = campaignInfo
                let group = DispatchGroup()
                
                group.enter()
                self.fetchTrackingImage(completion: { (imageData, error) in
                    self.fetchImageError = error
                    self.fetchedImageData = imageData
                    group.leave()
                })
                
                group.enter()
                self.fetchModel(completion: { (storageUrl, error) in
                    self.fetchedModelError = error
                    self.fetchedModelURL = storageUrl
                    group.leave()
                })
                
                group.notify(queue: DispatchQueue.main) {
                    if let imageError = self.fetchImageError {
                        completion(nil, nil, imageError)
                    } else if let modelURLError = self.fetchedModelError {
                        completion(nil, nil, modelURLError)
                    } else if let imageData = self.fetchedImageData, let url = self.fetchedModelURL {
                        completion(imageData, url, nil)
                    } else {
                        fatalError()
                    }
                }
            case .failure(let error): completion(nil, nil, error)
            }
        }
    }
    
    func fetchTrackingImage(completion: @escaping (Data?, Error?) -> Void) {
        let session = URLSession(configuration: .default)
        guard let url = trackingImageURL else {
            completion(nil, HTTPResponseError.responseErrorWith(message: "ERROR: Missing url"))
            return
        }
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
            if let e = error {
                completion(nil, e)
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
    
    
    func fetchModel(completion: @escaping (URL?, Error?) -> Void) {
        guard let urlString = campaignInfo?.modelURL, let url = URL(string: urlString) else {
            completion(nil, HTTPResponseError.responseErrorWith(message: "ERROR: Missing url"))
            return
        }
        
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
            catch {
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
