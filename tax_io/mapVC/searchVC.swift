//
//  searchVC.swift
//  tax_io
//
//  Created by Fatema Sherif on 7/7/22.
//

import UIKit
import CoreLocation

class searchVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate {

    
    @IBOutlet weak var txt_srcAddress: UITextField!
    @IBOutlet weak var txt_destAddress: UITextField!
    @IBOutlet weak var lst_places: UICollectionView!
    

    var srcflag = false
    var destflag = false
    var srcName = ""
    var destName = ""
    var src = CLLocation()
    var dest = CLLocation()
    var location = [CLLocation]()
    var place_names = [String]()

//    var distance : String = ""
//    var time : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_srcAddress.delegate = self
        txt_destAddress.delegate = self
        lst_places.delegate = self
        lst_places.dataSource = self
        
        txt_srcAddress.text! = srcName
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let story = UIStoryboard(name: "home", bundle: nil)
        let vc = story.instantiateViewController(identifier: "bookingv") as! bookingVC
        
        vc.srcLocation = src
        vc.destLocation = dest
        
        vc.srcName = srcName
        vc.destName = destName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? bookingVC{
            vc.srcName = srcName
            vc.srcLocation = src
            vc.destName = destName
            vc.destLocation = dest
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
        print("did select")
        let inx = indexPath.row
        if srcflag == true{
            srcName = place_names[inx]
            src = location[inx]
            srcflag = false

        }
        if destflag == true{
            destName = place_names[inx]
            self .txt_destAddress.text = destName
            dest = location[inx]
            print("locationnnnnnnn\(dest)")
            destflag = false
        }

    }
    
    

    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        if (textField.tag == 1){
            srcflag = true
        }else if (textField.tag == 2){
            destflag = true
        }
        if let text = textField.text, !text.isEmpty {
            search(text)
            
        }
        return true
    }
    
    
    func search(_ destination: String) {
        
        place_names.removeAll()
        self.lst_places.isHidden = false
        
        let geocCoder = CLGeocoder()
        geocCoder.geocodeAddressString(destination) {places,error in
            guard let place = places, error == nil else {
                self.showAlert(msg: "no data to display")
                return}
            print(place)
            print("22222222 \(String(describing: place.first))")
            print("name \(place.first?.name ?? "not found")")
            
            for i in place{
                self.place_names.append(i.name!)
                self.location.append(i.location!)
                self.lst_places.reloadData()
            }
        }

        
    }
 
    
    func showAlert(msg: String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "close", style: .default))
        present(alert, animated: true, completion: nil)
    }
}


