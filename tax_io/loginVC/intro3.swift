//
//  intro3.swift
//  tax_io
//
//  Created by Fatema Sherif on 5/12/22.
//

import UIKit

class intro3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func btn_continue(_ sender: Any) {
        go_screen("home","homev")
    }
    

    @IBAction func btn_skip(_ sender: Any) {
        go_screen("home","homev")
    }
    
}
