//
//  SlideCell.swift
//  tax_io
//
//  Created by Fatema Sherif on 6/5/22.
//

import UIKit

class SlideCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    
    func setup(_ slide: OnboardingSlide) {
        img.image = slide.image
        lbl.text = slide.title
    }
    
}
