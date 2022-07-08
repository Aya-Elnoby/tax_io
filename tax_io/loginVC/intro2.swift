//
//  intro2.swift
//  tax_io
//
//  Created by Fatema Sherif on 5/12/22.
//

import UIKit

class intro2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btn_continue(_ sender: Any) {
        go_screen("login","intro3v")
    }
    

    @IBAction func btn_skip(_ sender: Any) {
        go_screen("home","homev")
    }
}
