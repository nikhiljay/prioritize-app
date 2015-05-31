//
//  DetailViewController.swift
//  Prioritize
//
//  Created by Nikhil D'Souza on 2/8/15.
//  Copyright (c) 2015 Nikhil D'Souza. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var eventIndex: Int?
    var addressIndex: Int?
    var startTimeIndex: Int?
    var endTimeIndex: Int?
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var totalDriveTime: UILabel!
    @IBOutlet weak var storeOpenTime: UILabel!
    @IBOutlet weak var storeCloseTime: UILabel!
    @IBOutlet weak var appleMapsButton: UIButton!
    @IBOutlet weak var noAddressLabel: UILabel!
    
    var currentUser = PFUser.currentUser()
    let locationManager = CLLocationManager()
    var userLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(userLocation)
        
        appleMapsButton.layer.borderColor = UIColor.whiteColor().CGColor
        appleMapsButton.layer.borderWidth = 1
        appleMapsButton.layer.cornerRadius = 7

        //EVENT TITLE
        let event = currentUser["events"]![eventIndex!] as! String
        var eventTitle = "No Event Title"
        
        if let events = currentUser["events"] as? [String] {
            if eventIndex != nil {
                eventTitle = events[eventIndex!]

            }
        }

        //ADDRESS TITLE
        let address = currentUser["addresses"]![addressIndex!] as! String
        var addressTitle = "No Address"
        
        if let addresses = currentUser["addresses"] as? [String] {
            if address == "" {
                totalDriveTime.text = "n/a"
                appleMapsButton.hidden = true
            }
            if addressIndex != nil {
                addressTitle = addresses[addressIndex!]
            }
        }
        //END TIME TITLE
        let endTime = currentUser["endTimes"]![endTimeIndex!] as! String
        var endTimeTitle = "No End Time"
        
        if let endTimes = currentUser["endTimes"] as? [String] {
            if endTimeIndex != nil {
                endTimeTitle = endTimes[endTimeIndex!]
            }
        }
        //START TIME TITLE
        let startTime = currentUser["startTimes"]![startTimeIndex!] as! String
        var startTimeTitle = "No Start Time"
        
        if let startTimes = currentUser["startTime"] as? [String] {
            if startTimeIndex != nil {
                startTimeTitle = startTimes[startTimeIndex!]
            }
        }
        
        eventTitleLabel.text = eventTitle
        startTimeLabel.text = startTime
        endTimeLabel.text = endTime

        //MAPVIEW
        //If no address, then don't show the MapView.
        if address == "" {
            locationMapView.hidden = true
            appleMapsButton.hidden = true
            noAddressLabel.hidden = false
        } else {
            locationMapView.hidden = false
            appleMapsButton.hidden = false
            noAddressLabel.hidden = true
        }
        
        locationMapView.layer.cornerRadius = 5.0
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        locationMapView.showsUserLocation = true
        
        //GEOCODING OF POINT B!
        var geocodeAddress = addressTitle
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(geocodeAddress, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.locationMapView.addAnnotation(MKPlacemark(placemark: placemark))
            }
        })
        
        let currentLocation = MKMapItem.mapItemForCurrentLocation()
        geocoder.geocodeAddressString(geocodeAddress, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                let markLocation = MKPlacemark(coordinate: CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude), addressDictionary: nil)
                self.userLocation = currentLocation.placemark.location
                
                let location = MKMapItem(placemark: markLocation)
                
                location.name = address
                
                let array = NSArray(objects: currentLocation, location)
                
                var endPointLatitude = placemark.location.coordinate.latitude
                var endPointLongitude = placemark.location.coordinate.longitude
                var endPoint = placemark.location.coordinate
                
                //FIND THE DISTANCE BETWEEN POINT A (currentlocation) AND POINT B (endPoint)
            }
        })
        
//        let distance = userLocation.distanceFromLocation(destinationLocation)
//        println(distance)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                println("Error: " + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Error with the data.")
            }
        })
    }
    
    @IBAction func openInAppleMaps(sender: AnyObject) {
        let currentLocation = MKMapItem.mapItemForCurrentLocation()
        
        let address = currentUser["addresses"]![addressIndex!] as! String
        var addressTitle = "No Address"
        
        if let addresses = currentUser["addresses"] as? [String] {
            if address == "" {
                totalDriveTime.text = "n/a"
            }
            if addressIndex != nil {
                addressTitle = addresses[addressIndex!]
            }
        }
        
        var geocodeAddress = addressTitle
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(geocodeAddress, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                let markLocation = MKPlacemark(coordinate: CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude), addressDictionary: nil)
                
                let location = MKMapItem(placemark: markLocation)
                
                location.name = address
                
                let array = NSArray(objects: currentLocation, location)
                
                let parameter = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey)
                
                MKMapItem.openMapsWithItems(array as [AnyObject], launchOptions: parameter as [NSObject : AnyObject])
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        self.locationManager.stopUpdatingLocation()
        
        //USER'S CURRENT LOCATION!
//        println(placemark.subLocality)
//        println(placemark.locality)
//        println(placemark.postalCode)
//        println(placemark.administrativeArea)
//        println(placemark.country)
        println(placemark.location.coordinate.longitude)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var events = currentUser["events"] as? [String]
        var addresses = currentUser["addresses"] as? [String]
        var startTimes = currentUser["startTimes"] as? [String]
        var endTimes = currentUser["endTimes"] as? [String]
        
        if segue.identifier == "ShowEditEventSegue" {
            let vc = segue.destinationViewController as! EditEventViewController
            if let indexPath = eventIndex {
                vc.eventIndex = eventIndex
                vc.addressIndex = eventIndex
                vc.startTimeIndex = eventIndex
                vc.endTimeIndex = eventIndex
            }
        }
        
    }

}
