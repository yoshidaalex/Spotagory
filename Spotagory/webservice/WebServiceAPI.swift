//
//  WebServiceAPI.swift
//  Tied
//
//  Created by Admin on 18/03/16.
//  Copyright © 2016 Ronnie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WebServiceAPI: NSObject {
    //GET Requests
    static func sendGetRequest(apiName:String, token: String?, params: [String : AnyObject]?, completion: (response: AnyObject?, error: NSError?) -> Void)
    {
        var headers:[String: String]? = nil
        if (token != nil) {
            headers = ["x-access-token": token!]
        }
        
        let url = Constants.WebServiceApi.ApiBaseUrl + apiName
        
        Alamofire.request(.GET, url, parameters: params, encoding: .URL, headers: headers).responseJSON {
            response in
            switch response.result {
            case .Success:
                completion(response: response.result.value, error: nil)
            case .Failure(let error):
                InterfaceManager.showToastView(Constants.NetWorkOfflineMessage)
                completion(response: nil, error: error)
            }
        }
    }

    //POST Requests
    static func sendPostRequest(apiName:String, token: String?, params: [String : AnyObject]?, completion: (response: AnyObject?, error: NSError?) -> Void)
    {
        var headers:[String: String]? = nil
        if (token != nil) {
            headers = ["Content-Type": "application/x-www-form-urlencoded",
                       "x-access-token": token!]
        }

        let url = Constants.WebServiceApi.ApiBaseUrl + apiName
        
        Alamofire.request(.POST, url, parameters: params, encoding: .URL, headers: headers).responseJSON {
            response in
            switch response.result {
            case .Success:
                completion(response: response.result.value, error: nil)
            case .Failure(let error):
                InterfaceManager.showToastView(Constants.NetWorkOfflineMessage)
                completion(response: nil, error: error)
            }
        }
    }

    static func sendPostRequestWithPhoto(apiName:String,
                                         token: String?,
                                         resourceData:NSData?,
                                         mimeType:String,
                                         attachParamName:String,
                                         params:[String : AnyObject]?,
                                         completion:(response: AnyObject?, error: NSError?) -> Void) {
        
        var headers:[String: String]? = nil
        if (token != nil) {
            headers = ["x-access-token": token!]
        }

        let url = Constants.WebServiceApi.ApiBaseUrl + apiName

        Alamofire.upload(.POST, url, headers: headers, multipartFormData: { multipartFormData in
            if resourceData != nil {
                multipartFormData.appendBodyPart(data: resourceData!, name: attachParamName, fileName: "image.jpeg", mimeType: mimeType)
            }
            
            if let params = params {
                for (key, value) in params {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
            }
            
            }, encodingMemoryThreshold: 10 * 1024 * 1024, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON(completionHandler: { response in
                        switch response.result {
                        case .Success:
                            completion(response: response.result.value, error: nil)
                        case .Failure(let error):
                            InterfaceManager.showToastView(error.description)
                            completion(response: nil, error: error)
                        }
                    })
                case .Failure(_):
                    InterfaceManager.showToastView(Constants.NetWorkOfflineMessage)
                    completion(response: nil, error: nil)
                }
        })
    }

    //PUT Requests
    static func sendPutRequest(apiName:String, token: String?, params: [String : AnyObject]?, completion: (response: AnyObject?, error: NSError?) -> Void)
    {
        var headers:[String: String]? = nil
        if (token != nil) {
            headers = ["Content-Type": "application/x-www-form-urlencoded",
                       "x-access-token": token!]
        }
        
        let url = Constants.WebServiceApi.ApiBaseUrl + apiName
        
        Alamofire.request(.PUT, url, parameters: params, encoding: .URL, headers: headers).responseJSON {
            response in
            switch response.result {
            case .Success:
                completion(response: response.result.value, error: nil)
            case .Failure(let error):
                InterfaceManager.showToastView(Constants.NetWorkOfflineMessage)
                completion(response: nil, error: error)
            }
        }
    }
    
    static func sendPutRequestWithPhoto(apiName:String,
                                        token: String?,
                                        resourceData:NSData?,
                                        mimeType:String,
                                        attachParamName:String,
                                        params:[String : AnyObject]?,
                                        completion:(response: AnyObject?, error: NSError?) -> Void) {
        var headers:[String: String]? = nil
        if (token != nil) {
            headers = ["x-access-token": token!]
        }

        let url = Constants.WebServiceApi.ApiBaseUrl + apiName
        
        Alamofire.upload(.PUT, url, headers: headers, multipartFormData: { multipartFormData in
            if resourceData != nil {
                multipartFormData.appendBodyPart(data: resourceData!, name: attachParamName, fileName: "image.jpg", mimeType: mimeType)
            }
            
            if let params = params {
                for (key, value) in params {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
            }
            
            }, encodingMemoryThreshold: 10 * 1024 * 1024, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON(completionHandler: { response in
                        switch response.result {
                        case .Success:
                            completion(response: response.result.value, error: nil)
                        case .Failure(let error):
                            InterfaceManager.showToastView(error.description)
                            completion(response: nil, error: error)
                        }
                    })
                case .Failure(_):
                    InterfaceManager.showToastView(Constants.NetWorkOfflineMessage)
                    completion(response: nil, error: nil)
                }
        })
    }
}
