//
//  FirstViewController.swift
//  SolarMates
//
//  Created by Leighton Carmichael-Powell on 2015-03-13.
//  Copyright (c) 2015 Leighton Carmichael-Powell. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class FirstViewController: UIViewController,CLLocationManagerDelegate{
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    @IBOutlet weak var ctemp: UILabel!


    
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var cpower: UILabel!
    var chargep = 0.0
   
    @IBOutlet weak var charge: UIProgressView!
  
    
    
    @IBAction func Reload(sender: AnyObject) {
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector ("updateUI"), userInfo: nil, repeats: true)
        
        
    }
    
    
    @IBOutlet weak var progressLabel: UILabel!
    var timer = NSTimer()
    
    let locationManager = CLLocationManager()
    
  /*  var pcharge:Int = 0 {
        didSet {
            let fractionalProgress = Float(chargep)/100
            let animated = chargep != 0
            
            charge.setProgress(fractionalProgress, animated: animated)
            percentage.text = ("\(pcharge)%")
        }
    }*/
       override func viewDidLoad() {
        

        super.viewDidLoad()
        charge.setProgress(0, animated: true)
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector ("updateUI"), userInfo: nil, repeats: true)

        
                // Do any additional setup after loading the view, typically from a nib.
        //self.charge.setProgress(0, animated: true)
        }

    
    
    
    
    
    private func reloadTemperature() {
        let url = NSURL(string: "https://api.spark.io/v1/devices/sucky/temperature?access_token=61d387b8d6e7207bc818f1b06cb575ad5f65ab1c")
        let request = NSURLRequest(URL: url!)
        //ctemp.text = "Loading..."
        
        
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
            if let currenttemp = jsonResult["result"] as? NSNumber {
                // Show the result
                println("\(currenttemp)")
                self.ctemp.text = String(format: "%.2f°C", currenttemp.floatValue)
            }
        }
    }
    
    private func reloadPower() {
        let url = NSURL(string: "https://api.spark.io/v1/devices/sucky/currentpower?access_token=61d387b8d6e7207bc818f1b06cb575ad5f65ab1c")
        let request = NSURLRequest(URL: url!)
        
    
        //cpower.text = "Loading..."
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
            if let currentpower = jsonResult["result"] as? NSNumber {
                // Show the result
                self.cpower.text = String(format: "%.2f W", currentpower.floatValue)
            }
        }
    }
    
    private func chargepercentage12() {
        let url = NSURL(string: "https://api.spark.io/v1/devices/sucky/charge1?access_token=61d387b8d6e7207bc818f1b06cb575ad5f65ab1c")
        let request = NSURLRequest(URL: url!)
        
       // percentage.text = "Loading..."
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
            if let charge1 = jsonResult["result"] as? Double {
               self.chargep = charge1
                // Show the result
                self.percentage.text = String(format: "%3.0f %%", charge1)
            }
        }
    }
    
    func updateUI()
    {
        reloadTemperature()
        reloadPower()
        chargepercentage12()
        let fractionalProgress = Float(chargep)/100
        let animated = chargep != 0
        
        charge.setProgress(fractionalProgress, animated: animated)
        //percentage.text = ("\(chargep)%")
    }
}




