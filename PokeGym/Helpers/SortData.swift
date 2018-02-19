//
//  SortData.swift
//  PokeGym
//
//  Created by Cerebro on 04/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import Foundation

class SortData {
    
    
    
    func selectedList(gyms:[gymObject], completionHandler: @escaping (_ returnedAllRaids: [gymObject]) -> Void) -> Void{
        let allStartToFin = gyms.sorted(by: {Date(timeIntervalSinceNow:($0.raid?.startTime)!).timeIntervalSinceNow < Date(timeIntervalSinceNow:($1.raid?.startTime)!).timeIntervalSinceNow})
        
        var allRaids = [gymObject]()
        var gymsPastRaids = [gymObject]()

        for item in 0...(allStartToFin.count - 1) {
            if (Date(timeIntervalSince1970: TimeInterval((allStartToFin[item].raid?.endTime)!))) > Date() {
                allRaids.append(allStartToFin[item])
            } else {
                gymsPastRaids.append(allStartToFin[item])
            }
            if item == (allStartToFin.count - 1) {
                allRaids = allRaids + gymsPastRaids
                completionHandler(allRaids)
            }
        }
    }
    
    
    
    
    
}
