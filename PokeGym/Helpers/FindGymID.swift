//
//  FindGymID.swift
//  PokeGym
//
//  Created by Cerebro on 05/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import Foundation

class FindGymId {
    
    
    func getGymID(nameString: String, completionHandler: @escaping (_ gymId: Int) -> Void) -> Void{
        let request = NetworkRequest()
        request.dictionaryRequest(type: "gyms") { (allGyms) in
            self.findID(dict: allGyms, nameString: nameString, completionHandler: { (id) in
                if id != nil {
                    completionHandler(id!)
                }
            })
        }
    }
    
    func findID(dict: NSDictionary, nameString:String, completionHandler: @escaping (_ returnedId: Int?) -> Void) -> Void{
        if let gyms = dict["gyms"] as? NSArray {
            var idFound = false
            for i in 0...(gyms.count - 1) {
                if let gym = (gyms[i] as? NSDictionary), let name = (gym["name"] as? String) {
                    
                    if name.lowercased().range(of:nameString.lowercased()) != nil { // takes into account spaces or symbols before or after
                        idFound = true
                        completionHandler(Int(gym["id"] as! String)!)
                    }
                }
                if i == (gyms.count - 1) && idFound == false {
                    completionHandler(nil)
                }
            }
        }
    }
    
    
}
