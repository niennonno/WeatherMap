//
//  ViewController.swift
//  WeatherMap
//
//  Created by Aditya Vikram Godawat on 21/08/18.
//  Copyright © 2018 Aditya Vikram Godawat. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapKit: MKMapView!
    let manager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        //Diabling default doubletap
        if (mapKit.subviews[0].gestureRecognizers != nil){
            for gesture in mapKit.subviews[0].gestureRecognizers!{
                if (gesture.isKind(of: UITapGestureRecognizer.self)){
                    mapKit.subviews[0].removeGestureRecognizer(gesture)
                }
            }
        }
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubeTapped(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        mapKit.addGestureRecognizer(doubleTap)
        
        doubleTap.delegate = self
        
    }

    @objc func doubeTapped(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: mapKit)
        let touchCoordinate = mapKit.convert(touchPoint, toCoordinateFrom: self.mapKit)
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // City
            if let city = placeMark.subAdministrativeArea {
                print(city)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                vc.city = city
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                showAlertViewController(message: "Sorry! We can't find the nearby city!")
            }
            })

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let myLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: myLocation, span: span)
        mapKit.setRegion(region, animated: true)
        self.mapKit.showsUserLocation = true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

