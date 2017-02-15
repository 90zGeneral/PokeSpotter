//
//  MainVC.swift
//  PokeSpotter
//
//  Created by Roydon Jeffrey on 2/13/17.
//  Copyright © 2017 Italyte. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class MainVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    //Outlet
    @IBOutlet weak var mapView: MKMapView!
    
    //LocationManager
    let locationManager = CLLocationManager()
    
    //State of the centering map
    var mapHasCenteredOnce = false
    
    //GeoFire object and reference
    var geoFire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Connection btw mapView and the VC thru the delegate
        mapView.delegate = self
        
        //Track the user based on their location
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        //Reference to the Firebase Database and initialize geoFire
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Function call everytime the view appears
        userLocationAuthStatus()
    }
    
    //Get the user's permission to access their location 
    func userLocationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            
        }else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //Call this function when the user decides whether to permit location access or not
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    //Re-center the map to the user's current location after the user zoom or pan on the map
    func mapCenteredOnUserLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //Update on the user's location
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if let locate = userLocation.location {
            
            //If the map has not been centered before, then center it on user's location and change the state of mapHasCenteredOnce
            if !mapHasCenteredOnce {
                mapCenteredOnUserLocation(location: locate)
                mapHasCenteredOnce = true
            }
        }
    }
    
    //To set a custom annotion for the user's location
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //Annotation Declaration
        var annotationView: MKAnnotationView!
        
        //Check if the annotation is of type MKUserLocation and set its image to my custom image
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView.image = UIImage(named: "ash")
        }
        
        return annotationView
    }
    
    //Function to call when a Pokemon is spotted
    func spottedPokemon(forLocation location: CLLocation, withPokemon pokeID: Int) {
        geoFire.setLocation(location, forKey: "\(pokeID)")
    }
    
    //Tap when you see a pokemon
    @IBAction func pokemonSpotted(_ sender: Any) {
        
    }

}

