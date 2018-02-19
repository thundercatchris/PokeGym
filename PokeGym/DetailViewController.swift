//
//  DetailViewController.swift
//  PokemonGymTracker
//
//  Created by Cerebro on 01/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var gymImage: UIImageView!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet weak var move1: UILabel!
    @IBOutlet weak var move2: UILabel!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelView: UIView!
    @IBOutlet weak var pokeBallImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backCircleView: UIView!
    
    var gym:gymObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        let dateEnd = Date(timeIntervalSince1970: TimeInterval((gym?.raid?.endTime)!))
        let now = Date()
        let colour = GetColour().colour(colorInt: (gym?.team)!)
        
        if let imageString = gym?.url {
            setupImage(imageView: gymImage, imageString: imageString)
            self.gymImage.layer.cornerRadius = self.gymImage.frame.size.width / 2
            self.gymImage.clipsToBounds = true
        }
        
        if let name = gym?.name {
            nameLabel.text = name
        }
        
        if let pokemonNumber = gym?.raid?.pokemon, pokemonNumber != 0 && now < dateEnd {
            var pokemonString:String = String(describing: pokemonNumber)
            if pokemonNumber < 100 && pokemonNumber > 9 {
                pokemonString = "0\(pokemonString)"
            } else if pokemonNumber < 10 {
                pokemonString = "00\(pokemonString)"
            }
            let imageString = ("https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(pokemonString).png")
            setupImage(imageView: pokemonImage, imageString: imageString)
        } else {
            if let team = gym?.team {
            self.pokemonImage.image = UIImage(named: "\(String(describing: team)).png")
            }
        }
        
        let pokemonAndMoves = CoreDataCalls()
        if gym?.raid?.pokemon != nil && now < dateEnd  {
            let nameID = gym?.raid?.pokemon
            pokemonAndMoves.fetchSpecificPokemon(pokemonNumber: nameID!, completionHandler: { (name) in
                self.pokemonLabel.text = name
            })
        } else {
            self.pokemonLabel.text = "No raid information available"
        }
        
        if gym?.raid?.moveset1 != nil && gym?.raid?.moveset2 != nil && now < dateEnd  {
            let move1 = gym?.raid?.moveset1
            let move2 = gym?.raid?.moveset2
            pokemonAndMoves.fetchMoves(move1: move1!, move2: move2!, completionHandler: { (move_1, move_2) in
                self.move1.text = move_1
                self.move2.text = move_2
            })
        } else {
            self.move1.text = ""
            self.move2.text = ""
        }
        
        if let level = gym?.raid?.level, level != 0 && now < dateEnd {
            levelView.isHidden = false
            levelLabel.text = String(describing: level)
            self.levelView.layer.borderWidth = 3
            self.levelView.layer.cornerRadius = self.levelView.frame.size.width / 2
            self.levelView.layer.borderColor = colour.cgColor
            self.levelView.clipsToBounds = true
        } else { levelView.isHidden = true }
        
        if let team = gym?.team, team != 0 {
            self.pokeBallImage.image = UIImage(named: "PokeBallTran\(team).png")
        }
        
        if let lon = gym?.lon, let lat = gym?.lat {
            locationLabel.text = "Lat: \(lat), Lon: \(lon)"
        }
        
        getDirectionsButton.layer.borderWidth = 3
        getDirectionsButton.layer.cornerRadius = 17
        getDirectionsButton.layer.borderColor = colour.cgColor
        getDirectionsButton.setTitleColor(colour, for: .normal)
        
    }
    
    func setupImage(imageView:UIImageView, imageString: String) {
        let url = URL(string: imageString)
        DispatchQueue.main.async {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: url, completionHandler: {
                (image, error, cacheType, imageUrl) in
                imageView.contentMode = UIViewContentMode.scaleAspectFill
                if (error != nil) {
                }
            })
        }
    }
    
    @IBAction func getDirectionsAction(_ sender: Any) {
        let coordinate = CLLocationCoordinate2DMake((gym?.lat)!, (gym?.lon)!)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = (gym?.name)!
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
