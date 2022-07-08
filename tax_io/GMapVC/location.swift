//
//  location.swift
//  tax_io
//
//  Created by Fatema Sherif on 5/15/22.
//

import UIKit
import GoogleMaps
import Alamofire

class location: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate, GMSMapViewDelegate{

    @IBOutlet weak var map: GMSMapView!
    
    @IBOutlet weak var txt_srcAddress: UITextField!
    @IBOutlet weak var txt_destAddress: UITextField!
    @IBOutlet weak var lst_places: UICollectionView!
    
    var count = 0
    var src = CLLocationCoordinate2D()
    var dest = CLLocationCoordinate2D()
    
    var place_names = [String]()
    var place_ids = [String]()
    
    var distance : String = ""
    var time : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lst_places.delegate = self
        lst_places.dataSource = self
        map.delegate = self
        
        map.camera = GMSCameraPosition(latitude: 30.067496, longitude: 31.3300657, zoom: 16, bearing: 120, viewingAngle: 10)
    }
    
    @IBAction func btn_srcSearch(_ sender: Any) {
//        self.count = 0
        search(txt_srcAddress.text!)
    }
    
    
    @IBAction func btn_destSearch(_ sender: Any) {
        search(txt_destAddress.text!)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //map.clear()
        if(count != 2){
            addMarker(coordinate,count)
            getPlaceName(coordinate)
            count += 1
        }
    }
    
    
    func addMarker(_ coordinate: CLLocationCoordinate2D,_ count:Int){
        let marker = GMSMarker(position: coordinate)
        marker.map = map
        if count == 0 {
            marker.title  = "source"
            src = coordinate
//            marker.icon = UIImage(named: "taxi")

        }else{
            marker.title  = "destination"
            dest = coordinate
//            marker.icon = UIImage(named: "factory")

            DrawRoute()
        }
    }
    
    
    func getPlaceName(_ coordinate: CLLocationCoordinate2D) {
        let lat = coordinate.latitude
        let lng = coordinate.longitude
        
        AF.request("https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lng)&key=\(Config.api_key)&language=\(Config.language)",method: .get).responseJSON { (response) in
            if let result = response.value{
                if let d = result as? NSDictionary{
                    if let results = d.value(forKey: "results") as? NSArray {
                        let fplace = results[0] as! NSDictionary
                        let address = fplace["formatted_address"] as! String
//                        self.lbl_place.text = address
                        print(address)
                    }
                }
            }
        }
    }
    
    
    
    func DrawRoute() {
        let slat = src.latitude
        let slng = src.longitude
        
        let dlat = dest.latitude
        let dlng = dest.longitude
        
        AF.request("https://maps.googleapis.com/maps/api/directions/json?origin=\(slat),\(slng)&destination=\(dlat),\(dlng)&key=\(Config.api_key)",method: .get).responseJSON { (response) in
            if let result = response.value{
                if let d = result as? NSDictionary{
                    if let results = d.value(forKey: "routes") as? NSArray {
                        let fplace = results[0] as! NSDictionary
                        let legs = fplace["legs"] as! NSArray
                        let legs_data = legs[0] as! NSDictionary
                        let distance = legs_data["distance"] as! NSDictionary
                        self.distance = (distance["text"] as? String)!
                        
                        let time = legs_data["duration"] as! NSDictionary
                        self.time = (time["text"] as? String)!
                        
                        let overview_polyline = fplace["overview_polyline"] as! NSDictionary
                        let points = overview_polyline["points"] as! String
                        
                        let path = GMSPath(fromEncodedPath: points)
                        let route = GMSPolyline(path: path)
                        route.strokeWidth = 3
                        route.strokeColor = .black
                        route.map = self.map
                    }
                }
            }
        }
    }
    func search(_ word: String) {
        place_names.removeAll()
        place_ids.removeAll()
        self.lst_places.isHidden = false

        AF.request("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(word)&key=\(Config.api_key)&language=\(Config.language)",method: .get).responseJSON { (response) in
            if let result = response.value{
                if let d = result as? NSDictionary{
                    if let predictions = d["predictions"] as? NSArray {
                        for prediction in predictions {
                            let dd = prediction as! NSDictionary
                            let description = dd["description"] as! String
                            self.place_names.append(description)
                            self.place_ids.append(dd["place_id"] as! String)
                            self.lst_places.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func getLatLngFromPlaceID(_ placeid: String) {
        AF.request("https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeid)&key=\(Config.api_key)&language=\(Config.language)",method: .get).responseJSON { (response) in
            if let result = response.value{
                if let d = result as? NSDictionary{
                    if let result = d["result"] as? NSDictionary {
                        let geometry = result["geometry"] as! NSDictionary
                        let location = geometry["location"] as! NSDictionary
                        let lat = location["lat"] as! Double
                        let lng = location["lng"] as! Double
                        
                        self.map.camera = GMSCameraPosition(latitude: lat, longitude: lng, zoom: 16, bearing: 120, viewingAngle: 10)
                        
                        self.lst_places.isHidden = true
                        
                        self.map.clear()
                        
                        self.addMarker(CLLocationCoordinate2DMake(lat, lng), 1)
                        
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return place_names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = lst_places.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! placeCell
        cell.lbl.text = place_names[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let inx = indexPath.row
      getLatLngFromPlaceID(place_ids[inx])
    }
    
    

}
