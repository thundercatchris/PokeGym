//
//  NetworkRequest.swift
//  PokeGym
//
//  Created by Cerebro on 04/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import Foundation
import Alamofire

class NetworkRequest {
    
    func dictionaryRequest(type: String, completionHandler: @escaping (_ returnedDict: NSDictionary) -> Void) -> Void{
        DispatchQueue.global(qos: .background).async {
        let parameters = ["api-key": "128lhwm5ouw7k73rcj62", "area": "leeds", "type": type, "fields": "all"]
        Alamofire.request("https://gomaps.services/api", method: .post, parameters: parameters).responseJSON { response in
            if let data = response.data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    completionHandler(json)
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    return
                }
            }
            }
        }
    }
    
    func responseStringRequest(entityType: String, completionHandler: @escaping (_ returnedDict: NSDictionary) -> Void) -> Void{
         DispatchQueue.global(qos: .background).async {
        Alamofire.request("https://gomaps.uk/static/data/\(entityType).min.json").responseString { response in
            if response.result.isSuccess {
                let dict = (self.convertToDictionary(text: response.result.value!)! as NSDictionary) as! [String : Any] as NSDictionary
                completionHandler(dict)
            } else {
                print("Failed to load: \(String(describing: response.error))")
                return
            }
        }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
