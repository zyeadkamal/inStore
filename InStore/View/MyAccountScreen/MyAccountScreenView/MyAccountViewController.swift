//
//  MyAccountViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 27/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {

    @IBOutlet weak var noOrdersImage: UIImageView!
    @IBOutlet weak var ordersTableView: UITableView!
    
    let orders = [MockOrder(line_items: [OrderItem(variant_id: 1, quantity: 3, name: "nike shoes", price:"100"),OrderItem(variant_id: 1, quantity: 3, name: "nike shoes", price:"100"),OrderItem(variant_id: 1, quantity: 3, name: "nike shoes", price:"100"),OrderItem(variant_id: 1, quantity: 3, name: "nike shoes", price:"100")], customer: OrderCustomer(id: 0, first_name: "mohamed"), financial_status: "Paid", created_at: "27-06-2022", id: 1, currency: "$", current_total_price: "150"),MockOrder(line_items: [OrderItem(variant_id: 1, quantity: 3, name: "nike shoes", price:"100")], customer: OrderCustomer(id: 0, first_name: "mohamed"), financial_status: "Paid", created_at: "27-06-2022", id: 1, currency: "$", current_total_price: "150"),MockOrder(line_items: [OrderItem(variant_id: 1, quantity: 3, name: "nike shoes", price:"100")], customer: OrderCustomer(id: 0, first_name: "mohamed"), financial_status: "Paid", created_at: "27-06-2022", id: 1, currency: "$", current_total_price: "150")]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        configureCollectionViews()
        // Do any additional setup after loading the view.
    }
    private func configureCollectionViews(){
        registerCellsForTableView()
        setupTableViewDataSource()
    }
    
    private func setupTableViewDataSource(){
        ordersTableView.dataSource = self
        ordersTableView.delegate   = self
    }
    
    
    private func registerCellsForTableView(){
        let ordersNib = UINib(nibName: String(describing: MyOrderTableViewCell.self), bundle: nil)
        ordersTableView.register(ordersNib, forCellReuseIdentifier: String(describing: MyOrderTableViewCell.self))

    }
    
    @IBAction func logoutPressed(_ sender: Any) {
    }
    
    @IBAction func seeMoreOrdersPressed(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: MyOrdersViewController.self)) as! MyOrdersViewController
    
       // viewController.brand = brands[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func CurrencyPressed(_ sender: Any) {
    }

    @IBAction func AddressesPressed(_ sender: Any) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: MyAddressesViewController.self)) as! MyAddressesViewController
    
       // viewController.brand = brands[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}
extension MyAccountViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (orders.isEmpty){
            noOrdersImage.isHidden = false

            ordersTableView.isHidden = true
            return orders.count
        }
        noOrdersImage.isHidden = true
        ordersTableView.isHidden = false
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyOrderTableViewCell.self), for: indexPath) as! MyOrderTableViewCell
        cell.setupCell(order: orders[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((ordersTableView.frame.height/2))

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: OrderDetailsViewController.self)) as! OrderDetailsViewController
    
        viewController.order = orders[indexPath.row]
        ordersTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
}
