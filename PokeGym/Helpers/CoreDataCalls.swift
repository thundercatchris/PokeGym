//
//  DataCore.swift
//  PokeGym
//
//  Created by Cerebro on 04/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class CoreDataCalls {
    
    func getMyGyms(completionHandler: @escaping (_ gymIds: [Int]) -> Void) -> Void{
        var gyms: [NSManagedObject] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gym")
        do {
            gyms = try managedContext.fetch(fetchRequest) // get gym Ids from core data
            var gymIds = [Int]()
            if gyms.count > 0 { // checks some gyms exist
                for i in 0...(gyms.count - 1) {
                    let gym = (gyms as [NSManagedObject])[i]
                    gymIds.append(gym.value(forKey: "id")! as! Int)
                    if i == (gyms.count - 1) {
                        completionHandler(gymIds) // sends list of gym ids to get details
                    }
                }
            } else {
                completionHandler([])
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveGymiD(id: Int, completionHandler: @escaping (_ gym: NSManagedObject?) -> Void) -> Void{ // saves new gym to core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Gym", in: managedContext)!
        let gym = NSManagedObject(entity: entity, insertInto: managedContext)
        gym.setValue(id, forKeyPath: "id")
        do {
            try managedContext.save()
            completionHandler(gym)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func deleteAllRecords(entity: String) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func fetchSpecificPokemon(pokemonNumber: Int, completionHandler: @escaping (_ pokemonName: String?) -> Void) -> Void{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Pokemon")
        do {
            var pokemons: [NSManagedObject] = []
            pokemons = try managedContext.fetch(fetchRequest)
            if pokemons.count > 0 && pokemonNumber != 0 {
                for i in 0...(pokemons.count - 1) {
                    let pokemon = (pokemons as [NSManagedObject])[i]
                    if pokemon.value(forKey: "number")! as? Int == pokemonNumber {
                        completionHandler(pokemon.value(forKey: "name")! as? String)
                    }
                }
            } else {
                completionHandler("No raid information available")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchMoves(move1: Int, move2: Int, completionHandler: @escaping (_ move1: String, _ move2: String) -> Void) -> Void {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Move")
        var move_1 = ""
        var move_2 = ""
        do {
            var moves: [NSManagedObject] = []
            moves = try managedContext.fetch(fetchRequest)
            if moves.count > 0 {
                for i in 0...(moves.count - 1) {
                    let move = (moves as [NSManagedObject])[i]
                    if move.value(forKey: "number")! as? Int == move1 {
                        move_1 = (move.value(forKey: "name")! as? String)!
                    }
                    if move.value(forKey: "number")! as? Int == move2 {
                        move_2 = (move.value(forKey: "name")! as? String)!
                    }
                    if i == (moves.count - 1) {
                        completionHandler(move_1, move_2)
                    }
                }
            } else {
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteGym(gymID: Int, completionHandler: @escaping (_ deleted: Bool?) -> Void) -> Void{
        var gyms: [NSManagedObject] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Gym")
        do {
            gyms = try managedContext.fetch(fetchRequest) // get gym Ids from core data
            if gyms.count > 0 { // checks some gyms exist
                for i in 0...(gyms.count - 1) {
                    let gym = (gyms as [NSManagedObject])[i]
                    if gym.value(forKey: "id")! as! Int == gymID {
                        
                        managedContext.delete(gym)
                    }
                    if i == (gyms.count - 1) {
                        completionHandler(true) // sends list of gym ids to get details
                    }
                }
            } else {
                completionHandler(false)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
}
