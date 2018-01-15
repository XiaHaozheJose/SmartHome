//
//  NetWorkRequest.swift
//  iOT_Pract2
//
//  Created by 浩哲 夏 on 2017/11/28.
//  Copyright © 2017年 浩哲 夏. All rights reserved.
//

import Alamofire
import Foundation
import UIKit

private let shared = NetWorkRequest()

class NetWorkRequest{
    class var sharedInstance: NetWorkRequest{
        return shared
    }
}
enum MethodType: String {
    case GET = "GET"
    case POST = "POST"
}

extension NetWorkRequest{
    
    
    // For Image
    func postRequest(urlString : String, params:[String:AnyObject], data: [Data]?, name: [String]?, success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        
        // let Imageheaders = ["content-type":"multipart/form-data"]      // if data
        request(urlString, method: .post, parameters: params).responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                }
            case .failure(let error):
                failture(error)
            }
        })
    }
    
    // Form return Any
    func postRequestForm(urlString: String,params: [String: String], success:@escaping ((_ response: Any)->()), failed: @escaping ((_ error: Error)->())){
        request(urlString, method: .post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                success(value)
            case .failure(let error):
                failed(error)
            }
        }
    }
    
    //Form return [String: AnyObject]
    func postRequestFormToDict(urlString : String, params:[String:String], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        
        request(urlString, method: .post, parameters: params).responseJSON(completionHandler: { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                }
            case .failure(let error):
                failture(error)
            }
        })
    }
    
    func getRequestToAny(urlString: String, success : @escaping (_ response : Any)->(), failture : @escaping (_ error : Error)->()) {
        
        request(urlString, method: .get)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    success(value)
                case .failure(let error):
                    failture(error)
                }
        }
        
    }
    
    func getRequestToAnyObject(urlString: String, success : @escaping (_ response : [String: AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        
        request(urlString, method: .get)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    success(value as! [String : AnyObject])
                case .failure(let error):
                    failture(error)
                }
        }
        
    }
    
    
    func upLoadImageRequest(urlString : String, params:[String:String], data: [Data], name: [String],success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()){
        
        let headers = ["content-type":"multipart/form-data"]
        
        upload(
            multipartFormData: { multipartFormData in
                //multiImage
                let flag = params["flag"]
                let userId = params["userId"]
                
                multipartFormData.append((flag?.data(using: String.Encoding.utf8)!)!, withName: "flag")
                multipartFormData.append( (userId?.data(using: String.Encoding.utf8)!)!, withName: "userId")
                
                for i in 0..<data.count {
                    multipartFormData.append(data[i], withName: "appPhoto", fileName: name[i], mimeType: "image/png")
                }
        },
            to: urlString,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            success(value)
                        }
                    }
                case .failure(let encodingError):
                    failture(encodingError)
                }
        }
        )
    }
}

