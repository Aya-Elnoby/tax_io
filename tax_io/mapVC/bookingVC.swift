//
//  bookingVC.swift
//  tax_io
//
//  Created by Fatema Sherif on 7/7/22.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseFirestore

class bookingVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var lbl_src: UILabel!
    @IBOutlet weak var lbl_dest: UILabel!
    
    var count = 0
    var srcName = ""
    var destName = ""
    var srcLocation = CLLocation()
    var destLocation = CLLocation()
    
    let srcAnnotation = MKPointAnnotation()
    let destAnnotation = MKPointAnnotation()

    
//    var ref: DatabaseReference!

    var docRef: DocumentReference!
//    var rideListener: FIRL
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        lbl_src.text = srcName
        lbl_dest.text = destName

        
        srcAnnotation.coordinate = srcLocation.coordinate
        srcAnnotation.title = "location"
        destAnnotation.coordinate = destLocation.coordinate
        destAnnotation.title = "destination"
        
        map.addAnnotations([srcAnnotation,destAnnotation])
        
        zoomToUserLocation(location: srcLocation)
        DrawRoute()
        
        
        
//        ref = Database.database().reference()
        docRef = Firestore.firestore().document("user/order")

        
    }
    
    func zoomToUserLocation(location: CLLocation){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        map.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "myCustomPin")
        switch annotation.title{
        case "location":
            annotationView.markerTintColor = .blue
//            annotationView.glyphImage = UIImage(named: "blueCircle")
            break
        case "destination":
            annotationView.markerTintColor = .lightGray
//            annotationView.glyphImage = UIImage(named: "grayCircle")
            break
        default:
            break
        }
        
        return annotationView
    }

    
    func DrawRoute() {
        let sourcePlaceMark = MKPlacemark(coordinate: srcLocation.coordinate, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: destLocation.coordinate, addressDictionary: nil)
        
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        let direction = MKDirections(request: directionRequest)
        
        
        direction.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("ERROR FOUND : \(error.localizedDescription)")
                    self.showAlert(msg: "sorry can't draw the route right now")
                }
                return
            }
            let route = response.routes[0]
            self.map.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            self.map.setRegion(MKCoordinateRegion(route.polyline.boundingMapRect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 4
        rendere.strokeColor = .darkGray
        
        return rendere
    }
    
    @IBAction func btn_getRide(_ sender: Any) {
        let srcLat: Double = srcLocation.coordinate.latitude
        let srcLng: Double = srcLocation.coordinate.longitude
        let destLat: Double = destLocation.coordinate.latitude
        let destLng: Double = destLocation.coordinate.longitude
        
//        ref.child("ride").setValue(["destlat" : destLat, "destLng" : destLng , "destName" : destName , "srcLat" : srcLat,"srcLng" : srcLng , "srcName" : srcName])
        let dataToSave: [String: Any] = ["destlat" : destLat, "destLng" : destLng , "destName" : destName , "srcLat" : srcLat,"srcLng" : srcLng , "srcName" : srcName]
        
        docRef.setData(dataToSave) { (error) in
            if let error = error {
                print("ERROR FOUND : \(error.localizedDescription)")
            }else{
                print("data saved")
            }
        }
        go_screen("home", "getCarV")
    }
    
    func showAlert(msg: String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default))
        present(alert, animated: true, completion: nil)
    }

}





