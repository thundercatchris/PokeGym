//
//  ListViewController.swift
//  PokeGym
//
//  Created by Cerebro on 04/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import UIKit
import Foundation

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let single = Singleton.sharedInstance
    var gyms = [gymObject]()
    var myList = false
    @objc let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(update), for: .valueChanged)
        tableView.refreshControl = refreshControl // set refresh control
        getInitialData()
    }
    
    func getInitialData() {
        self.refreshControl.beginRefreshing()
        single.initialUpdate { (gymsReturned) in
            self.gyms = gymsReturned
            self.updateMapView()
            DispatchQueue.main.async() {
                self.refreshControl.endRefreshing()
            }
            self.tableView.reloadData()
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gyms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gymCell", for: indexPath) as! GymCell
        cell.gym = gyms[indexPath.row]
        cell.setupCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
            let nextScene = segue.destination as? DetailViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            nextScene.gym = gyms[indexPath.row] // pass whole object to detail view
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataCalls().deleteGym(gymID: gyms[indexPath.row].id) { (deleted) in
                if deleted! {
                    self.update()
                } else {
                    
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Gym Name", message: "Please enter the name EXACTLY", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            FindGymId().getGymID(nameString: textField.text!, completionHandler: { (id) in
                let save = CoreDataCalls()
                save.saveGymiD(id: id, completionHandler: { (gym) in
                    self.update()
                })
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField) in textField.placeholder = "Enter gym name EXACTLY" }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.present(alert, animated:true, completion: nil)
    }
    
    
    @objc func update() {
        DispatchQueue.main.async() {
            self.refreshControl.beginRefreshing()
        }
        single.update { (gyms) in
            self.gyms = gyms
            self.updateMapView()
            DispatchQueue.main.async() {
                self.refreshControl.endRefreshing()
            }
            self.tableView.reloadData()
        }
    }
    
    func updateMapView() {
        let navController = self.tabBarController?.viewControllers![1] as! UINavigationController
        let vc = navController.topViewController as! MapViewController
        vc.gyms = gyms
        vc.getLocation()
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Error Deleting", message: "Please try again and refresh the table", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated:true, completion: nil)
    }
    
}
