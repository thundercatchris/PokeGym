//
//  GymTableViewCell.swift
//  PokemonGymTracker
//
//  Created by Cerebro on 30/01/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import UIKit
import Kingfisher

class GymCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var teamView: UIView!
    @IBOutlet weak var pokemonImage: UIImageView!
    
    var gym:gymObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func prepareForReuse() {
        
    }
    
    
    func setupCell() {
        let colour = GetColour().colour(colorInt: (gym?.team)!)
        nameLabel.text = gym?.name
        levelLabel.text = String(describing: (gym?.raid?.level)!)
        
        teamView.layer.borderWidth = 3
        teamView.layer.cornerRadius = teamView.frame.size.width / 2
        teamView.layer.borderColor = colour.cgColor
        

        
        
        if let start = gym?.raid?.startTime, let end = gym?.raid?.endTime {
            let dateTime = DateAndTime()
            let startDate = Date(timeIntervalSince1970: TimeInterval(start))
            let startString = dateTime.dateStringFromDouble(dateDouble: start)
            let endDate = Date(timeIntervalSince1970: TimeInterval(end))
            let endString = dateTime.dateStringFromDouble(dateDouble: end)
            let now = Date()
//            let now = Date(timeIntervalSince1970: TimeInterval(1517854781.0))
            
            startLabel.text = startString
            endLabel.text = endString
            
            startLabel.isHidden = !(now < startDate)
            endLabel.isHidden = !(now < endDate)
            teamView.isHidden = (now > endDate)
            pokemonImage.isHidden = !(now > startDate && now < endDate)
            levelLabel.isHidden = !(now < startDate)
            
            if now > endDate {
                nameLabel.textColor = UIColor.lightGray } else { nameLabel.textColor = UIColor.black
            }

            if let pokemonNumber = gym?.raid?.pokemon, pokemonNumber != 0 {
                let pokemonString:String = String(describing: pokemonNumber)
                let url = URL(string: ("https://gomaps.uk/static/icons/monster/\(pokemonString).png"))
                DispatchQueue.main.async {
                    self.pokemonImage.kf.indicatorType = .activity
                    self.pokemonImage.kf.setImage(with: url, completionHandler: {
                        (image, error, cacheType, imageUrl) in
                        self.pokemonImage.contentMode = UIViewContentMode.scaleAspectFill
                        self.levelLabel.isHidden = true
                        self.levelLabel.isHidden = false
                        if (error != nil) {
                        }
                    })
                }
            } else {
                levelLabel.isHidden = false
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
