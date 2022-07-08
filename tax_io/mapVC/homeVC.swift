//
//  ViewController.swift
//  tax_io
//
//  Created by Fatema Sherif on 5/11/22.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class homeVC: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {
    
    
    @IBOutlet weak var lbl_userAddress: UILabel!
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    
    var srcName = ""
    var srclocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
// hide back button
        self.navigationItem.setHidesBackButton(true, animated: true)
//locationAuthorization
        map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if isLocationServiceEnabled() {
            checkAuthorization()
        }else{
            showAlert(msg: "Please enable location service")
        }
        
        
        
//end viewDidLoad
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? searchVC{
            vc.srcName = srcName
            vc.src = srclocation
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        getLocationInfo(location: CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
    }
    
    func getLocationInfo(location: CLLocation){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) {places,error in
            guard let place = places?.first, error == nil else {return}
            self.lbl_userAddress.text = place.name!
            self.srcName = place.name!
            self.srclocation = place.location!
            
            print(place.name ?? "not found")
            print("hhh\(place.name!)")

        }
    }
    
    func isLocationServiceEnabled() -> Bool{
        return CLLocationManager.locationServicesEnabled()
    }
    
    func checkAuthorization(){
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            map.showsUserLocation = true
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            map.showsUserLocation = true
            break
        case.denied:
            showAlert(msg: "Please authorize access to location")
            break
        case .restricted:
            showAlert(msg: "Authorization restricted")
            break
        default:
            print("default")
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
//            print("location: \(location.coordinate)")
            zoomToUserLocation(location: location)
//            self.getPlaceName(location.coordinate)
        }
    }
    
    func zoomToUserLocation(location: CLLocation){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            map.showsUserLocation = true
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            map.showsUserLocation = true
            break
        case.denied:
            showAlert(msg: "Please authorize access to location")
            break
        default:
            print("default")
            break
        }
    }
    
    func showAlert(msg: String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func btn_getUserAddress(_ sender: Any) {
        print("here")
        go_screen("home","searchv")

    }
    @IBAction func btn_settingsMenu(_ sender: Any) {
        print("setting menu pressed")
    }
    
    @IBAction func btn_center(_ sender: Any) {
        print("btn_center pressed ")
        
    }
    
}

