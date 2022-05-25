//
//  CardTableViewCell.swift
//  InStore
//
//  Created by sandra on 5/25/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    //MARK: -- IBOutlets
    @IBOutlet weak var productCardTitle: UILabel!
    @IBOutlet weak var productCardPrice: UILabel!
    @IBOutlet weak var productCardImage: UIImageView!
    @IBOutlet weak var productCardAmount: UILabel!
    @IBOutlet weak var productMinusBtn: UIButton!
    @IBOutlet weak var productPlusBtn: UIButton!
    
    
    //MARK: -- Properties
    
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
    }
    
    
    
    @IBAction func didPressPlusBtn(_ sender: UIButton) {
    }
    //MARK: -- Functions

}
