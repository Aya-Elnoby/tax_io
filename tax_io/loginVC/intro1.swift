//
//  intro.swift
//  tax_io
//
//  Created by Fatema Sherif on 5/12/22.
//

import UIKit

class intro1: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        go_screen("login","intro2v")

        
    }
    
    @IBAction func btn_skip(_ sender: Any) {
        go_screen("home","homev")
        

    }
    
    @IBAction func btn_continue(_ sender: Any) {
//        go_screen("login","intro2v")
        let vc = UIStoryboard(name: "login", bundle: nil).instantiateViewController(withIdentifier: "intro2v")
        navigationController?.pushViewController(vc, animated: true)
    }
}
