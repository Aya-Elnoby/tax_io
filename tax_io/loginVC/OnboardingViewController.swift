//
//  ViewController.swift
//  tax_io
//
//  Created by Fatema Sherif on 6/4/22.
//

import UIKit

class OnboardingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    

    
    @IBOutlet weak var lst: UICollectionView!
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    var slides: [OnboardingSlide] = []
    
    var currentCellIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lst.delegate = self
        lst.dataSource = self
        


        pageControl.numberOfPages = slides.count
        
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        slides = [OnboardingSlide(title: "Order from your favourite stores or vendors", image: UIImage(named: "totalSlide1")!), OnboardingSlide(title: "Choose from a wide range of delicious meals", image: UIImage(named: "totalSlide2")!),OnboardingSlide(title: "Enjoy instant delivery and payment", image: UIImage(named: "totalSlide3")!)
        ]

        lst.reloadData()
//        lst.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
    
    
    @IBAction func btn_continue(_ sender: Any) {
        if currentCellIndex == slides.count-1{
            go_screen("home", "homev")
        }else{
            currentCellIndex += 1
            print(currentCellIndex)
            let indexPath = IndexPath(item: currentCellIndex, section: 0)
            self.lst.scrollToItem(at: indexPath, at: .centeredHorizontally , animated: true)
        }
        
//        print(currentCellIndex)
//        lst.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        
//        pageControl.currentPage = currentCellIndex
    }
    
    
    @IBAction func btn_skip(_ sender: Any) {
        go_screen("home", "homev")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = lst.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SlideCell
        
        cell.setup(slides[indexPath.row])
        return cell
        
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: lst.frame.width, height: lst.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentCellIndex = Int(scrollView.contentOffset.x / width)
    }
    
}
