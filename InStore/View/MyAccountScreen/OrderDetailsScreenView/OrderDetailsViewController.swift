//
//  OrderDetailsViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 27/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var orderedAtLabel: UILabel!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var orderDetailsTableView: UITableView!
    
    var order: MockOrder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    private func configureTableView(){
        registerCellsForTableView()
        setupTableViewDataSource()
    }
    
    private func setupTableViewDataSource(){
        orderDetailsTableView.dataSource = self
        orderDetailsTableView.delegate   = self
    }
    

    private func registerCellsForTableView(){
        let ordersNib = UINib(nibName: String(describing: OrderDetailsTableViewCell.self), bundle: nil)
        orderDetailsTableView.register(ordersNib, forCellReuseIdentifier: String(describing: OrderDetailsTableViewCell.self))

    }

    
}
extension OrderDetailsViewController : UITableViewDataSource,UITableViewDelegate{
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.line_items.count ?? 0
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderDetailsTableViewCell.self), for: indexPath) as! OrderDetailsTableViewCell
        cell.setupCell(orderItem: (order?.line_items[indexPath.row])!)
    
    
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return ((orderDetailsTableView.frame.height/8))
//
//
//    }
    
}

