//
//  AddressesTableViewCell.swift
//  InStore
//
//  Created by sandra on 5/26/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class AddressesTableViewCell: UITableViewCell {
    
    //MARK: -- IBOutlets
    @IBOutlet weak var selectAddressBtn: UIButton!
    @IBOutlet weak var addressTitle: UILabel!
    
    //MARK: -- Properties
    
    
    //MARK: -- Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //viewCellUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: -- IBActions
    @IBAction func didSelectAddress(_ sender: Any) {
        setOptionSelection(true)
    }
    
    //MARK: -- Functions
    func setOptionSelection(_ isSelected : Bool){
        if isSelected{
            self.selectAddressBtn.isSelected = true
        }else{
            self.selectAddressBtn.isSelected = false
        }
    }
    
    func viewCellUI(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        //for actual cell
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.50
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        self.clipsToBounds = false
        self.contentView.layer.masksToBounds = true
    }

}
