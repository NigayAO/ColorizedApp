//
//  ModelColor.swift
//  ColorizedApp
//
//  Created by Alik Nigay on 05.11.2021.
//

import Foundation
import UIKit


struct ChooseColor {
    var red: Float
    var green: Float
    var blue: Float
    
    func getColor() -> UIColor {
        UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
}
