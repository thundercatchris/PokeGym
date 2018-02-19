//
//  SectionHeaderTableViewCell.swift
//  PokemonGymTracker
//
//  Created by Cerebro on 31/01/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var teamView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
