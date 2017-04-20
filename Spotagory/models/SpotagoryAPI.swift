//
//  SpotagoryAPI.swift
//  Spotagory
//
//  Created by Messia Engineer on 9/23/16.
//  Copyright © 2016 Spotagory. All rights reserved.
//

import UIKit
import Alamofire

class SpotagoryAPI: NSObject {
    
//    static let apiInstance = SpotagoryAPI()
    
    static let serverBasicUrl = "http://spgapi.herokuapp.com/api"
//    static let apiBasicUrl = serverBasicUrl + "index.php/api/"
//    static let dataBasicUrl = serverBasicUrl + "data/"
    
//    var operationManager : AFHTTPSessionManager = AFHTTPSessionManager()
//    
//    override init() {
//        operationManager = AFHTTPSessionManager()
//        operationManager.requestSerializer = AFHTTPRequestSerializer()
//        operationManager.responseSerializer = AFJSONResponseSerializer()
//        operationManager.responseSerializer.acceptableContentTypes = ["text/plain", "text/html", "application/json"]
//    }
//    
//    static func serverMediaUrl(uri : String) -> NSURL {
//        return NSURL(string: dataBasicUrl + uri)!
//    }
//    
//    func httpGetTo(apiName : String, params : Dictionary<String, AnyObject>?, progressCallback : ((progress : Double) -> Void)?, successCallback : ((response : AnyObject?) -> Void)?, failedCallback : ((error : NSError?) -> Void)?) {
//        
//        print("api call : " + apiName)
//        print(params)
//        
//        operationManager.GET(SpotagoryAPI.apiBasicUrl + apiName,
//                             parameters: params,
//                             progress: { (progress) in
//                                    if progressCallback != nil {
//                                        progressCallback!(progress: progress.fractionCompleted)
//                                    }
//                                },
//                             success: { (urlSessionDataTask, response) in
//                                    if successCallback != nil {
//                                        successCallback!(response : response)
//                                    }
//                                },
//                             failure: { (urlSessionDataTask, error) in
//                                    if failedCallback != nil {
//                                        failedCallback!(error : error)
//                                    }
//                                })
//        
//    }
//    
//    func httpPostTo(apiName : String,
//                    files : [Dictionary<String, AnyObject>]?,
//                    params : Dictionary<String, AnyObject>?,
//                    progressCallback : ((progress : Double) -> Void)?,
//                    successCallback : ((response : AnyObject?) -> Void)?,
//                    failedCallback : ((error : NSError?) -> Void)?) {
//        
//        print("api call : " + apiName)
//        print(params)
//        
//        operationManager.POST(SpotagoryAPI.serverBasicUrl + apiName,
//                             parameters: params,
//                             constructingBodyWithBlock: { formData in
//                                
//                                    if files != nil {
//                                        for fileData in files! {
//                                            formData.appendPartWithFileData(fileData["data"] as! NSData, name: fileData["name"] as! String, fileName: fileData["filename"] as! String, mimeType: fileData["mimeType"] as! String)
//                                        }
//                                    }
//                                
//                                },
//                             progress: { (progress) in
//                                    if progressCallback != nil {
//                                        progressCallback!(progress: progress.fractionCompleted)
//                                    }
//                                },
//                             success: { (urlSessionDataTask, response) in
//                                    print("response \(response)")
//                                    if successCallback != nil {
//                                        successCallback!(response : response)
//                                    }
//                                },
//                             failure: { (urlSessionDataTask, error) in
//                                    print("error \(error)")
//                                    if failedCallback != nil {
//                                        failedCallback!(error : error)
//                                    }
//                                })
//        
//    }
    
    static func sendGetRequest(apiName:String, token: String?, params: [String : AnyObject]?, completion: (response: AnyObject?, error: NSError?) -> Void)
    {
        var headers:[String: String]? = nil
        if (token != nil) {
            headers = ["x-access-token": token!]
        }
        
        let url = SpotagoryAPI.serverBasicUrl + apiName
        
        Alamofire.request(.GET, url, parameters: params, encoding: .URL, headers: headers).responseJSON {
            response in
            switch response.result {
            case .Success:
                completion(response: response.result.value, error: nil)
            case .Failure(let error):
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
        
        let url = SpotagoryAPI.serverBasicUrl + apiName
        
        Alamofire.request(.POST, url, parameters: params, encoding: .URL, headers: headers).responseJSON {
            response in
            switch response.result {
            case .Success:
                completion(response: response.result.value, error: nil)
            case .Failure(let error):
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
        
        let url = SpotagoryAPI.serverBasicUrl + apiName
        
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
                            completion(response: nil, error: error)
                        }
                    })
                case .Failure(_):
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
        
        let url = SpotagoryAPI.serverBasicUrl + apiName
        
        Alamofire.request(.PUT, url, parameters: params, encoding: .URL, headers: headers).responseJSON {
            response in
            switch response.result {
            case .Success:
                completion(response: response.result.value, error: nil)
            case .Failure(let error):
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
        
        let url = SpotagoryAPI.serverBasicUrl + apiName
        
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
                            completion(response: nil, error: error)
                        }
                    })
                case .Failure(_):
                    completion(response: nil, error: nil)
                }
        })
    }

}
