//
//  DetailViewController.swift
//  WeatherMap
//
//  Created by Aditya Vikram Godawat on 21/08/18.
//  Copyright © 2018 Aditya Vikram Godawat. All rights reserved.
//

import UIKit
import DataCache
import Alamofire
import SwiftyJSON
import SVProgressHUD

class DetailViewController: UIViewController {

    var city = String()
    
    @IBOutlet weak var cityWeatherLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = city
        
        getCityTemp()
    }
    
    func getCityTemp() {
        SVProgressHUD.show()
        let urlString = baseUrl+"?appId=4439b2b5134691e1b551d87ce4b1a0ce&units=metric&q="+city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(urlString)
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        return
                    }
                    DataCache.instance.write(data: data, forKey: urlString)
                    
                    do {
                        let json = try JSON(data: data)
                        print(json)
                        self.fillScreen(json: json)
                    } catch (_){
                    }
                case .failure(let error):
                    
                    if let data = DataCache.instance.readData(forKey: urlString) {
                        do {
                            let json = try JSON(data: data)
                            print(json)
                            self.fillScreen(json: json)
                        } catch (_){
                        }
                    }
                    SVProgressHUD.dismiss()
                    showAlertViewController(message: error.localizedDescription)
                }
        }
    }
    
    func fillScreen(json: JSON) {
        SVProgressHUD.dismiss()
        if let weather = json["weather"].arrayValue.first?.dictionaryValue {
            cityWeatherLabel.text = weather["description"]?.stringValue.capitalized
        }
        
         let main = json["main"].dictionaryValue
        currentTempLabel.text = "\(main["temp"]!.floatValue) °C"
    }
}
