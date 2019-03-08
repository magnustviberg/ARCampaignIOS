//
//  ARCampaignError.swift
//  ARCampaign
//
//  Created by Magnus Tviberg on 08/03/2019.
//

import UIKit

enum ARCampaignError: Error {
    case invalidBundle
    case localModelUrlMissing
    case unableToCreateModelFromURL
    case unzipFromURLFailed
    case errorWithMessage(String)
    case networkingError(HTTPResponseError)
}

extension ARCampaignError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidBundle:
            return "The Bundle Identifier for this campaign does not match the Bundle Identifier for this project"
        case .localModelUrlMissing:
            return "Missing local model URL"
        case .unableToCreateModelFromURL:
            return "Unable to create model from URL"
        case .unzipFromURLFailed:
            return "Unable to unzip data from url"
        case .errorWithMessage(let message):
            return message
        case .networkingError(let responseError):
            return responseError.errorDescription
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidBundle:
            return "Check that the Bundle Identifier in the ARCampaignInfo.plist is the same as for the project"
        case .networkingError(let responseError):
            return responseError.recoverySuggestion
        case .localModelUrlMissing, .unableToCreateModelFromURL, .unzipFromURLFailed, .errorWithMessage(_):
            return "Do something"
        }
    }
}

// MARK: - Alert dialog text
extension ARCampaignError {
    
    var alertMessage: String {
        guard let errorDescription = errorDescription else { return "Ukjent nettverksfeil" }
        
        if let recoverySuggestion = recoverySuggestion {
            return "\(errorDescription). \(recoverySuggestion)"
        } else {
            return errorDescription
        }
    }
}

extension UIViewController {
    
    func presentAlert(campaignError: ARCampaignError, handler: ((UIAlertAction) -> Void)? = nil) {
        let message = campaignError.alertMessage
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Lukk", style: .cancel, handler: handler))
        present(alertController, animated: true, completion: nil)
    }
}
