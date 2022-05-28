//
//  OnBoardingCollectionViewCell.swift
//  InStore
//
//  Created by Mohamed Ahmed on 25/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class OnBoardingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var onBoardingImage: UIImageView!
    
    @IBOutlet weak var onBoardingTitle: UILabel!
    
    @IBOutlet weak var onBoardingDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(_ slide:OnboardingSlide){
        self.onBoardingImage.image = slide.image
        self.onBoardingTitle.text = slide.title
        self.onBoardingDescription.text = slide.description
    }
    
    

}
