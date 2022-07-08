//
//  getCarController.swift
//  tax_io
//
//  Created by Fatema Sherif on 7/8/22.
//

import UIKit
import NVActivityIndicatorView
import MapKit
import Firebase
import CoreLocation

class getCarController: UIViewController,MKMapViewDelegate {
    @IBOutlet weak var loading: NVActivityIndicatorView!
    
    @IBOutlet weak var map: MKMapView!
    
    private var dbRef : DatabaseReference?
    
    private var driverAnnotation : MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)
        
        loading.startAnimating()
        
        driverAnnotation = MKPointAnnotation()
        
        dbRef = Database.database().reference()
        
        dbRef?.child("driver_points").observe(.value, with: { (data) in
            let postDict = data.value as? [String : Double] ?? [:]
            let latitude = postDict["latitude"]
            let longitude = postDict["longitude"]
            
            let cordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            self.setLocation(currentDriverPoints: cordinate)
        })
        loading.stopAnimating()
        loading.isHidden = true
        
        self.map.delegate = self
    }


    
    private var isDriverMarkerSet = false
    
    private func setLocation(currentDriverPoints : CLLocationCoordinate2D){
        print("location : \(currentDriverPoints.latitude), \(currentDriverPoints.longitude)")
        if !isDriverMarkerSet {
            driverAnnotation?.coordinate = currentDriverPoints
            isDriverMarkerSet = true
            map.addAnnotation(driverAnnotation!)
        } else {
            let angle = angleFromCoordinate(firstCoordinate: driverAnnotation!.coordinate, secondCoordinate: currentDriverPoints)
            
            UIView.animate(withDuration: 2) {
                self.driverAnnotation?.coordinate = currentDriverPoints
            }
            
            //Getting the MKAnnotationView
            let annotationView = self.map.view(for: driverAnnotation!)
            
            //Angle for moving the driver
            UIView.animate(withDuration: 1) {
                annotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            }
            
        }
        
        
        self.zoomOnAnnotation()
    }
    
    private func zoomOnAnnotation(){
        let region = MKCoordinateRegion(center: driverAnnotation!.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
        map.setRegion(region, animated: true)
    }
    
    func angleFromCoordinate(firstCoordinate: CLLocationCoordinate2D,
                             secondCoordinate: CLLocationCoordinate2D) -> Double {
        
        let deltaLongitude: Double = secondCoordinate.longitude - firstCoordinate.longitude
        let deltaLatitude: Double = secondCoordinate.latitude - firstCoordinate.latitude
        let angle = (Double.pi * 0.5) - atan(deltaLatitude / deltaLongitude)
        
        if (deltaLongitude > 0) {
            return angle
        } else if (deltaLongitude < 0) {
            return angle + Double.pi
        } else if (deltaLatitude < 0) {
            return Double.pi
        } else {
            return 0.0
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        let pinImage = UIImage(named: "ic_driver")
        annotationView!.image = pinImage
        return annotationView
    }
    
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.map.setRegion(region, animated: true)
    }

}
