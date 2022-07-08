//
//  pageContainer.swift
//  tax_io
//
//  Created by Fatema Sherif on 6/4/22.
//

import UIKit

class pageContainer: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    var vcs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


//        let vc1 = getVcFromStory("intro1v") as! intro1
//        vc1.pageTitle = "Order from your favourite stores or vendors"
//        vc1.pageImg = UIImage(named: "totalSlide1")!
//
//        let vc2 = getVcFromStory("intro1v") as! intro1
//        vc2.pageTitle = "Choose from a wide range of delicious meals"
//        vc2.pageImg = UIImage(named: "totalSlide2")!
//
//        let vc3 = getVcFromStory("intro1v") as! intro1
//        vc3.pageTitle = "Enjoy instant delivery and payment"
//        vc3.pageImg = UIImage(named: "totalSlide3")!
//
//
//        vcs.append(vc1)
//        vcs.append(vc2)
//        vcs.append(vc3)

        
//        vcs.append( getVcFromStory("intro1v"))
//        vcs.append( getVcFromStory("intro2v"))
//        vcs.append( getVcFromStory("intro3v"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        let pages = UIPageViewController(transitionStyle: .scroll,
                                         navigationOrientation: .horizontal,
                                         options: nil)
        pages.delegate = self
        pages.dataSource = self
        pages.modalPresentationStyle = .fullScreen
        pages.setViewControllers([vcs.first!],
                                 direction: .forward,
                                 animated: true,
                                 completion: nil)
        
        present(pages, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController), index > 0 else{
            return nil
        }
        let before = index - 1
        return vcs[before]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.firstIndex(of: viewController), index < vcs.count-1 else{
            return nil
        }
        let after = index + 1
        return vcs[after]
    }
    
    
    func getVcFromStory(_ id:String) -> UIViewController{
        return UIStoryboard(name: "login", bundle: nil).instantiateViewController(withIdentifier: id)
    }

}
