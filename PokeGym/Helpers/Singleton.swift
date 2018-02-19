//
//  Singleton.swift
//  singletonExample
//
//  Created by Cerebro on 15/03/2017.
//  Copyright © 2017 Thundercatchris. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class Singleton {
    
    var gyms:[gymObject]?
    static let sharedInstance: Singleton = Singleton()
    
    // Can't init is singleton
    private init() {}
    
    
    func initialUpdate(completionHandler: @escaping (_ returnedGyms: [gymObject]) -> Void) -> Void{
        MovesAndPokemon().check { (complete) in
            if complete {
                self.update(updateCompletionHandler: { (returnedGyms) in
                    completionHandler(returnedGyms)  // called multiple times
                })
            } else {
                print("error updating moves and pokemon")
            }
        }
    }
    
    func update(updateCompletionHandler: @escaping (_ returnedGyms: [gymObject]) -> Void) -> Void{
        CoreDataCalls().getMyGyms { (gymIds) in
            if gymIds.count != 0 {
                self.getGyms(gymIds: gymIds, gymsCompletionHandler: { (returnedGyms) in
                    updateCompletionHandler(returnedGyms)
                })
            } else {
                updateCompletionHandler([])
            }
        }
    }
    
    func getGyms(gymIds: [Int], gymsCompletionHandler: @escaping (_ returnedGyms: [gymObject]) -> Void) -> Void{
        GymsAndRaids().getGyms(gymIds: gymIds) { (returnedGyms) in
            //            self.gyms = returnedGyms
            SortData().selectedList(gyms: returnedGyms, completionHandler: { (allGymsAndRaids) in
                self.gyms = allGymsAndRaids
                gymsCompletionHandler(allGymsAndRaids)
            })
        }
    }
    
    
    
}















