//
//  GymsAndRaids.swift
//  PokeGym
//
//  Created by Cerebro on 04/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import Foundation


class GymsAndRaids {
    
    func getGyms(gymIds: [Int], completionHandler: @escaping (_ returnedGyms: [gymObject]) -> Void) -> Void{
        var gymObjects = [gymObject]()
        NetworkRequest().dictionaryRequest(type: "gyms") { (dict) in
            if let gyms = dict["gyms"] as? NSArray {
                for index in 0...(gyms.count - 1) {
                    let gym = gyms[index] as! NSDictionary
                    if let id = Int((gym["id"] as? String)!) {
                        
                        for idIndex in 0...(gymIds.count - 1) {
                            let gymId = Int(gymIds[idIndex])
                            if gymId == id {
                                if let latDict = gym["lat"], let lat = (latDict as? NSString)?.doubleValue,
                                    let lonDict = gym["lon"], let lon = (lonDict as? NSString)?.doubleValue,
                                    let name = gym["name"] as? String,
                                    let teamDict = gym["team"] as? String,
                                    let url = gym["url"] as? String{
                                    let team = Int(teamDict)!
                                    let object = gymObject(lat: lat, lon: lon, name: name, id: id, team: team, url: url, raid: nil)
                                    gymObjects.append(object)
                                } else {
                                    // missing information such as name
                                }
                            }
                        }
                    }
                    if index == (gyms.count - 1){
                        self.getRaids(gymObjects: gymObjects, completionHandler: { (returnedGyms) in
                            completionHandler(returnedGyms)
                        })
                    }
                }
            }
        }
    }
    
    func getRaids(gymObjects: [gymObject], completionHandler: @escaping (_ returnedGyms: [gymObject]) -> Void) -> Void {
        NetworkRequest().dictionaryRequest(type: "raids") { (dict) in
            var gyms = gymObjects
            if let raids = dict["raids"] as? NSArray {
                for item in 0...(raids.count - 1) {
                    let raid = raids[item] as! NSDictionary
                    for i in 0...(gyms.count - 1) {
                        let gym = gyms[i]
                        let raidId = Int((raid["gym_id"] as? String)!)
                        if gym.id == raidId {
                            if let start = (raid["time_battle"] as? NSString)?.doubleValue,
                                let end = (raid["time_end"] as? NSString)?.doubleValue,
                                let spawn = (raid["time_spawn"] as? NSString)?.doubleValue,
                                let level = Int((raid["level"] as? String)!),
                                let move1 = Int((raid["move_1"] as? String)!),
                                let move2 = Int((raid["move_2"] as? String)!),
                                let pokemon = Int((raid["pokemon_id"] as? String)!),
                                let raidId = Int((raid["gym_id"] as? String)!),
                                let cp = Int((raid["cp"] as? String)!) {
                                
                                let object = raidObject(startTime: start, endTime: end, SpawnTime: spawn, gym: raidId, pokemon: pokemon, moveset1: move1, moveset2: move2, cp: cp, level: level)
                                gyms[i].raid = object
                            } else {
                                // missing information
                            }
                        }
                    }
                    if item == (raids.count - 1) {
                        completionHandler(gyms)
                    }
                }
            }
        }
    }
    
}
