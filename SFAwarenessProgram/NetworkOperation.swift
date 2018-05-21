//
//  NetworkOperation.swift
//  SFAwarenessProgram
//
//  Created by Ahyathreah Effi-yah on 3/3/16.
//  Copyright © 2016 TrhUArrayLUV. All rights reserved.
//

import Foundation
enum NetworkRequestError: ErrorType {
    case InvalidHTTPResponse
    case UnableToConnect
}

protocol NetworkDelegate {
    func catchNetworkError(errorType: ErrorType)
}

class NetworkOperation {
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session:NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    typealias JSONArrayCompletion = ([[String: AnyObject]]?) -> ()
    
    init(url: NSURL) {
        self.queryURL = url
    }
    
    var delegate: NetworkDelegate?
    
    func downloadJSONFromURL(completion: JSONArrayCompletion) {
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
        let dataTask = session.dataTaskWithRequest(request) {(let data, let response, let error) in
            
            guard let httpResponse = response as? NSHTTPURLResponse else {
                self.delegate?.catchNetworkError(NetworkRequestError.InvalidHTTPResponse)
                return
            }
            switch httpResponse.statusCode {
            case 200, 202:
                do {
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [[String: AnyObject]]
                    completion(jsonArray)
                } catch { completion(nil) }
            default:
                break
            }
        }
        dataTask.resume()
    }
}