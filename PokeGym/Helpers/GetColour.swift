//
//  GetColour.swift
//  PokemonGymTracker
//
//  Created by Cerebro on 02/02/2018.
//  Copyright © 2018 thundercatchris. All rights reserved.
//
import UIKit

class GetColour {
    
    func colour(colorInt: Int) -> UIColor {
        var colorToReturn:UIColor?
        
        switch colorInt
        {
        case 1:
            colorToReturn = hexStringToUIColor(hex: "0677ED")
        case 2:
            colorToReturn = hexStringToUIColor(hex: "F3150A")
        case 3:
             colorToReturn = hexStringToUIColor(hex: "FBD206")
        default:
            colorToReturn = UIColor.lightGray
        }
        return colorToReturn!
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
