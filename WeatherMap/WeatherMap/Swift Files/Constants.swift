//
//  Constants.swift
//  WeatherMap
//
//  Created by Aditya Vikram Godawat on 21/08/18.
//  Copyright © 2018 Aditya Vikram Godawat. All rights reserved.
//

import UIKit

let baseUrl = "http://api.openweathermap.org/data/2.5/weather"

func showAlertViewController(message: String) {
    let alertVC = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
    
    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    alertVC.addAction(ok)
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        topController.present(alertVC, animated: true, completion: nil)
    }
}
