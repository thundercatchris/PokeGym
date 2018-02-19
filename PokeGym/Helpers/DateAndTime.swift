//
//  DateAndTime.swift
//  PokemonGymTracker
//
//  Created by Cerebro on 02/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//

import Foundation

class DateAndTime {
    
    func dateStringFromDouble(dateDouble:Double) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dateDouble))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"//Set time style
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date as Date)
        return localDate
    }   
}
