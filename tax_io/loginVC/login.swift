//
//  login.swift
//  tax_io
//
//  Created by Fatema Sherif on 5/12/22.
//

import UIKit
//import Firebase
import FirebaseAuth
import DialCountries

class login: UIViewController,DialCountriesControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var btn_continue: UIButton!
    
    @IBOutlet weak var btn_title: UIButton!
    @IBOutlet weak var txt_phone: UITextField!
    
    var phone = ""
    var value = false
    var dailCode = "+1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        btn_title.setTitle("🇺🇸 +1", for: .normal)
        txt_phone.delegate = self
 
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SMSCode{
            vc.phoneNum = phone
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            
            print("login \(self.phone)")
            let number = "\(dailCode)\(text)"
            self.phone = number
            AuthManager.shared.startAuth(phoneNumber: number){[weak self] success in
                guard success else { return }
                DispatchQueue.main.async {
                    self!.btn_continue.isEnabled = true
//                    self?.go_screen("login","codev")
                }
                
            }
        }
        return true
    }
 
//    @IBAction func btn_continue(_ sender: Any) {
//        value = textFieldShouldReturn(txt_phone)
//        print (value)
//    }
    
    @IBAction func getDailCode(_ sender: Any) {
        DispatchQueue.main.async {
            let controller = DialCountriesController(locale: Locale(identifier: "En"))
                controller.delegate = self
                controller.show(vc: self)
        }
    }
    
    func didSelected(with country: Country) {
        btn_title.setTitle("\(country.flag) \(country.dialCode!)", for: .normal)
        dailCode = country.dialCode!
    }


}
