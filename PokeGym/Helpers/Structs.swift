//
//  Gym.swift
//  LocationApp
//
//  Created by Cerebro on 30/01/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//
import UIKit
import Foundation

struct gymObject {
    let lat: Double
    let lon: Double
    let name: String
    let id: Int
    let team: Int
    let url: String
    var raid: raidObject?
}

struct raidObject {
    let startTime: Double
    let endTime: Double
    let SpawnTime: Double
    let gym: Int
    let pokemon: Int
    let moveset1: Int
    let moveset2: Int
    let cp: Int
    let level: Int
}


