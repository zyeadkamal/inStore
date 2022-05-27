//
//  MyOrderTableViewCell.swift
//  InStore
//
//  Created by Mohamed Ahmed on 27/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak private var orderTotal: UILabel!
    
    @IBOutlet weak private var orderedAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(order:MockOrder) {
        orderTotal.text = String("\(order.currency ?? "$")\(order.current_total_price ?? "0")")
        orderedAt.text = order.created_at ?? "27-06-1998"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
