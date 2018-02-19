//
//  CheckUpToDate.swift
//  PokeGym
//
//  Created by Cerebro on 04/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MovesAndPokemon {
    
    func check(completionHandler: @escaping (_ completed: Bool) -> Void) -> Void{
        var movesComplete = false
        var pokemonComplete = false
        
        checkUpToDate(entityType: "moves") { (moves) in
            movesComplete = moves
            self.checkUpToDate(entityType: "pokemon", completionHandler: { (pokemon) in
                pokemonComplete = pokemon
                if movesComplete && pokemonComplete {
                    completionHandler(true)
                }
            })
        }
    }
    
    func checkUpToDate(entityType: String, completionHandler: @escaping (_ completed: Bool) -> Void) -> Void{
        var entityName = "Move"
        if entityType == "pokemon" {
            entityName = "Pokemon"
        }
        let network = NetworkRequest()
        network.responseStringRequest(entityType: entityType, completionHandler: { (dict) in
            
            let count = dict.count
            var items: [NSManagedObject] = []
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            
            do {
                items = try managedContext.fetch(fetchRequest)
                if items.count != 0 && items.count == count {
                    completionHandler(true)
                } else {
                    var total = 0
                    if items.count != 0 {
                        CoreDataCalls().deleteAllRecords(entity: entityName)
                    }
                    for (key, value) in dict {
                        total += 1
                        let pokeDict = value as? NSDictionary
                        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
                        let move = NSManagedObject(entity: entity, insertInto: managedContext)
                        move.setValue(Int((key as? String)!)!, forKeyPath: "number")
                        move.setValue((pokeDict!["name"] as? String)!, forKeyPath: "name")
                        do {
                            try managedContext.save()
                            if total == count {
                                completionHandler(true)
                            }
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                            completionHandler(false)
                        }
                    }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        })
    }

}
