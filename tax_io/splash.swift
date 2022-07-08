//
//  splash.swift
//  tax_io
//
//  Created by Fatema Sherif on 5/12/22.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius:CGFloat{
        get {
            return 0
        }
        set(value){
            self.layer.cornerRadius = value
        }
    }
    
}

extension UIViewController{
    func go_screen(_ storyboard:String,_ id:String){
        let story = UIStoryboard(name: storyboard, bundle: nil)
        let vc = story.instantiateViewController(identifier: id)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}




class splash: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        go_screen("login","onboarding")
//        go_screen("login","loginv")
        go_screen("home","homev")
//        go_screen("home","searchv")

//        go_screen("GMap","locationv")
        
    }
    


}
