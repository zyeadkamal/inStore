//
//  OrderDetailsTableViewCell.swift
//  InStore
//
//  Created by Mohamed Ahmed on 27/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak private var productName: UILabel!
    
    @IBOutlet weak private var productPrice: UILabel!
    
    @IBOutlet weak private var productQty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(orderItem:OrderItem){
        productName.text = String("\(orderItem.name ?? "")")
        if(MyUserDefaults.getValue(forKey: .currency) as! String == "USD"){
            productPrice.text = String("\(orderItem.price ?? "0") $")
        }else{
            productPrice.text = String("\(Constants.convertPriceToEGP(priceToConv: orderItem.price ?? "0")) EGP")
            
        }
        productQty.text = String("\(orderItem.quantity!)")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
