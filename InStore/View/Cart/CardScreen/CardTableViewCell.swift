//
//  CardTableViewCell.swift
//  InStore
//
//  Created by sandra on 5/25/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import Kingfisher

class CardTableViewCell: UITableViewCell {

    //MARK: -- IBOutlets
    @IBOutlet weak private var productCardTitle: UILabel!
    @IBOutlet weak private var productCardPrice: UILabel!
    @IBOutlet weak private var productCardImage: UIImageView!
    @IBOutlet weak private var productCardAmount: UILabel!
    @IBOutlet weak private var productMinusBtn: UIButton!
    @IBOutlet weak private var productPlusBtn: UIButton!
    
    
    //MARK: -- Properties
    var updateProduct : (( Int16 ) -> Void) = {amount in }
    var deleteProduct : (() -> ()) = {}
    var count : Int16 = 1
    var productTitle : String?{
        didSet{
            productCardTitle.text = productTitle
        }
    }
    
    var productPrice : String?{
        didSet{
            productCardPrice.text = productPrice
        }
    }
    var productAmount : String?{
        didSet{
            productCardAmount.text = productAmount
        }
    }
    
    var productImg : String?{
        didSet{
            productCardImage.kf.setImage(with: URL(string: productImg ?? "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png"))
        }
    }
    
    //MARK: -- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: -- IBActions
    @IBAction func didPressMinusBtn(_ sender: UIButton) {
        if count > 1{
            count -= 1
            self.updateProduct(count)
        }else{
            deleteProduct()
            productMinusBtn.isHidden = true
        }
    }
    
    
    
    @IBAction func didPressPlusBtn(_ sender: UIButton) {
        if count >= 1{
            count += 1
            self.updateProduct(count)
        }else{
            productMinusBtn.isHidden = true
        }
    }
    //MARK: -- Functions

}
