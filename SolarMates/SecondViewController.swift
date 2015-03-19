//
//  SecondViewController.swift
//  SolarMates
//
//  Created by Leighton Carmichael-Powell on 2015-03-13.
//  Copyright (c) 2015 Leighton Carmichael-Powell. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class SecondViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate{
    
    @IBOutlet weak var Solar_intesity: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var Weather: UILabel!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
    //mapView.delegate = self
        
        
        self.locationManager.delegate=self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true

//        loadTemperature()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadTemperature() {
        let url = NSURL(string: "https://developer.nrel.gov/api/solar/solar_resource/v1.json?api_key=mK5jEiyhgM41S67T0DqiEyP7BWugYwfnNHIBHkkR&lat=49&lon=-123")
        let request = NSURLRequest(URL: url!)
        self.Weather.text = "Loading..."
        
        
        // call the API
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            if error != nil {
                println("Request Error \(error.localizedDescription)")
                return;
            }
            var err: NSError?
            // parse the API response
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if err != nil {
                println("JSON Error \(err!.localizedDescription)")
            }
            println(jsonResult)
            if let  currenttemp: [NSNumber]  = jsonResult["avg_dni"] as? [NSNumber] {
                // Show the result
                self.Solar_intesity.text = String(format: "%.2f ", currenttemp[1].floatValue)
            }
        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark){
        
        self.locationManager.stopUpdatingLocation()
        
        println(placemark.locality)
        println(placemark.postalCode)
        println(placemark.administrativeArea)
        println(placemark.country)
        println(placemark.location)
    }
    
   func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    
    let regiontozoom = MKCoordinateRegionMake(manager.location.coordinate, MKCoordinateSpanMake(1,1))
    mapView.setRegion(regiontozoom, animated: true)
    
    CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks,error) -> Void in
        
        if error != nil{
            println("error" + error.localizedDescription)
            return
        }
        if placemarks.count > 0 {
            let pm =  placemarks[0] as CLPlacemark
            self.displayLocationInfo(pm)
        }else{
            println("Error with data")
        }
    })
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        
        println("Error: " + error.localizedDescription)
        
    }
}
}