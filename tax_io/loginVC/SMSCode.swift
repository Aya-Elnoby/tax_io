//
//  SMSCode.swift
//  tax_io
//
//  Created by Fatema Sherif on 5/12/22.
//

import UIKit

class SMSCode: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var incorrectMsg: UIStackView!
    var SMSTimer: Timer?
    var second = 30
    var minute = 2
    var phoneNum = "hhh"
    
    
    @IBOutlet weak var lbl_timer: UILabel!
    @IBOutlet weak var txt_smsCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SMSTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)

        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        lbl_timer.text = "( \(minute):\(second) )"
        incorrectMsg.isHidden = true
        
        txt_smsCode.delegate = self
        
        print("\(phoneNum)")

    }
    
    @IBAction func txt_endEditing(_ sender: Any) {

    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SMSTimer?.invalidate()
    }
    
    
    @IBAction func close(_ sender: Any) {
        incorrectMsg.isHidden = true
    }
    
    
    @objc func runTimedCode(){
        if minute >= 0{
            if second > 0 {
                second -= 1
                lbl_timer.text = "( \(minute):\(second) )"
            }else if second == 0{
                minute -= 1
                second = 60
                if minute >= 0{
                    lbl_timer.text = "( \(minute):\(second) )"
                }
            }
            
        }

        
    }
    
    
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool{
            textField.resignFirstResponder()
    
            if let text = textField.text, !text.isEmpty {
                let code = text
                AuthManager.shared.verfiyCode(smsCode: code) {[weak self] success in
                    guard success else {
                        self?.incorrectMsg!.isHidden = false
                        return}
                    DispatchQueue.main.async {
                        self?.go_screen("login","onboarding")
                    }
    
                }
            }
            return true
        }
    
    @IBAction func btn_resendCode(_ sender: Any) {
        
        AuthManager.shared.startAuth(phoneNumber: self.phoneNum){[weak self] success in
            guard success else {
                print("failed to send code")
                return }
            DispatchQueue.main.async{
                
                print("send another code")
            }
        }
    }


}
