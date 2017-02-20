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
    
    //Ask the user's permission to access their location
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
    
    //Center the map on the user's location
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
        
        let annoIdentifier = "Pokemon"
        
        //Check if the annotation is of type MKUserLocation and set its image to my custom image
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView.image = UIImage(named: "ash")
            
        }else if let dequeueAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            //To reuse custom annotation if needed
            annotationView = dequeueAnno
            annotationView.annotation = annotation
            
        }else {
            //Create an annotation if dequeue fails or not reusable
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            annoView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = annoView
        }
        
        //To customize the annotation with pokemon image regardless of which condition case fall thru
        if let annotationView = annotationView, let anno = annotation as? PokeAnnotation {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.pokemonID)")
            
            //Create a button then set it to the annotationView
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
    
    //Function to call when a Pokemon is spotted
    func spottedPokemon(forLocation location: CLLocation, withPokemon pokeID: Int) {
        
        //Store location in Firebase
        geoFire.setLocation(location, forKey: "\(pokeID)")
    }
    
    //Show the sighting of pokemons on the map
    func showSightingsOnMap(location: CLLocation) {
        let circleQuery = geoFire.query(at: location, withRadius: 2.0)
        
        //Firebase call back function executes whenever a location is set from the spottedPokemon method
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            
            //Make sure both key and location exist
            if let key = key, let location = location {
                
                //New Instance of Annotation
                let newAnno = PokeAnnotation(coordinate: location.coordinate, pokemonID: Int(key)!)
                self.mapView.addAnnotation(newAnno)

            }
        })
    }
    
    //Update the map when region changes
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        //Get the latitude and longitude for where the user is panning/scrolling
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        //Pass the location into the function call
        showSightingsOnMap(location: loc)
    }
    
    //To get the directions to a Pokemon when the user taps on the map within the pop-up of a pokemon annotation image 
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let anno = view.annotation as? PokeAnnotation {
            let place = MKPlacemark(coordinate: anno.coordinate)
            let destination = MKMapItem(placemark: place)
            destination.name = "\(anno.pokemonName)'s Location"
            let regionDistance: CLLocationDistance = 700
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] as [String: Any]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }
    
    //Tap to see a random pokemon in the center of the map
    @IBAction func pokemonSpotted(_ sender: Any) {
        
        //Create a location for random pokemon
        let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        //Random pokemon ID generator between 1 and 151 inclusive of both 1 & 151
        let rand = arc4random_uniform(151) + 1
        
        //Call spottedPokemon using the values above
        spottedPokemon(forLocation: loc, withPokemon: Int(rand))
        
    }
    
    //To re-center the map on the user's current location after zooming, panning or scrolling
    @IBAction func goBackToCurrentLocation(_ sender: Any) {
        
        //Get the user's current latitude and longitude location
        let relocate = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        //Function call
        mapCenteredOnUserLocation(location: relocate)
    }

}



