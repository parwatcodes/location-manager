//
//  UIHelper.swift
//  Locations-Final Project
//
//  Created by Parwat Kunwar on 2022-09-20.
//

import Foundation
import UIKit

func getAlertController(_ message: String) -> UIAlertController {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    alert.view.layer.cornerRadius = 15
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(okAction)
    
    return alert;
}
