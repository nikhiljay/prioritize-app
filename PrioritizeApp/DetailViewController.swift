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
import Parse

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
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    var currentUser = PFUser.currentUser()
    let transitionManager = TransitionManager()
    let locationManager = CLLocationManager()
    var userLocation: CLLocation!
    var allDayStart: Bool!
    var allDayEnd: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(userLocation)
        
        appleMapsButton.layer.borderColor = UIColor.whiteColor().CGColor
        appleMapsButton.layer.borderWidth = 1
        appleMapsButton.layer.cornerRadius = 7
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //EVENT TITLE
        var eventTitle = "No Event Title"
        
        if let events = currentUser["events"] as? [String] {
            if eventIndex != nil {
                eventTitle = events[eventIndex!]
                
            }
        }
        
        //END TIME TITLE
        let endTime = (currentUser["endTimes"]as! [String])[endTimeIndex!]
        if endTime == "None" {
            allDayEnd = true
        } else {
            allDayEnd = false
        }
        var endTimeTitle = "No End Time"
        
        if let endTimes = currentUser["endTimes"] as? [String] {
            if endTimeIndex != nil {
                endTimeTitle = endTimes[endTimeIndex!]
            }
        }
        //START TIME TITLE
        let startTime = (currentUser["startTimes"]as! [String])[startTimeIndex!]
        if startTime == "None" {
            allDayStart = true
        } else {
            allDayStart = false
        }
        var startTimeTitle = "No Start Time"
        
        if let startTimes = currentUser["startTime"] as? [String] {
            if startTimeIndex != nil {
                startTimeTitle = startTimes[startTimeIndex!]
            }
        }
        
        if allDayEnd == true && allDayStart == true {
            toLabel.text = "All Day"
            fromLabel.text = "Scheduled"
            startTimeLabel.hidden = true
            endTimeLabel.hidden = true
        } else  {
            toLabel.text = "to"
            fromLabel.text = "Scheduled from"
            startTimeLabel.hidden = false
            endTimeLabel.hidden = false
        }
        
        //ADDRESS TITLE
        let address = (currentUser["addresses"]as! [String])[addressIndex!]
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
        
        locationMapView.delegate = self
        locationMapView.layer.cornerRadius = 5.0
        locationMapView.removeAnnotations(locationMapView.annotations)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        locationMapView.showsUserLocation = true
        
        //GEOCODING OF POINT B!
        let geocodeAddress = addressTitle
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(geocodeAddress, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let placemark = placemarks?[0] {
                self.destinationPlacemark = placemark
                
                let pin = MKPlacemark(placemark: placemark)
                self.locationMapView.addAnnotation(pin)
                self.recenterMap()
            }
        })
        
        
        if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse {
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            if #available(iOS 9.0, *) {
                self.locationManager.requestLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateDistanceToPlace()
    }
    
    func updateDistanceToPlace() {
        if let userLocation = locationManager.location {
            if let place = destinationPlacemark {
                let distance = userLocation.distanceFromLocation(place.location!)
                totalDriveTime.text = "\(Int((floor(distance/1609.34))))"
            }
            
            locationManager.stopUpdatingLocation()
        }
    }

    func recenterMap() {
        let mapView = self.locationMapView
        
        var annotations = mapView.annotations
        
        if annotations.count > 1 {
            annotations.append(mapView.userLocation)
            self.locationMapView.showAnnotations(annotations, animated: true)
        }

    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        recenterMap()
    }
    
    var destinationPlacemark: CLPlacemark? {
        didSet {
            updateDistanceToPlace()
        }
    }
    
    @IBAction func openInAppleMaps(sender: AnyObject) {
        let currentLocation = MKMapItem.mapItemForCurrentLocation()
        
        let address = (currentUser["addresses"] as! [String])[addressIndex!]
        var addressTitle = "No Address"
        
        if let addresses = currentUser["addresses"] as? [String] {
            if address == "" {
                totalDriveTime.text = "n/a"
            }
            if addressIndex != nil {
                addressTitle = addresses[addressIndex!]
            }
        }
        
        let geocodeAddress = addressTitle
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(geocodeAddress, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let placemark = placemarks![0] as CLPlacemark! {
                self.destinationPlacemark = placemark
                
                let markLocation = MKPlacemark(coordinate: CLLocationCoordinate2DMake(placemark.location!.coordinate.latitude, placemark.location!.coordinate.longitude), addressDictionary: nil)
                
                let location = MKMapItem(placemark: markLocation)
                
                location.name = address
                
                let array = NSArray(objects: currentLocation, location)
                
                let parameter = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey)
                
                MKMapItem.openMapsWithItems(array as! [MKMapItem], launchOptions: parameter as? [String : AnyObject])
            }
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: " + error.localizedDescription)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowEditEventSegue" {
            let vc = segue.destinationViewController as! EditEventTableViewController
            if let _ = eventIndex {
                vc.eventIndex = eventIndex
                vc.addressIndex = eventIndex
                vc.startTimeIndex = eventIndex
                vc.endTimeIndex = eventIndex
                vc.transitioningDelegate = transitionManager
            }
        }
        
    }

}
