//
//  MyOrdersViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 27/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController {
    @IBOutlet weak var noOrdersImage: UIImageView!
    @IBOutlet weak var ordersTableView: UITableView!
    
    let orders = [MockOrder(line_items: [OrderItem(variant_id: 1, quantity: 3, name: "nike shoes", price:"100")], customer: OrderCustomer(id: 0, first_name: "mohamed"), financial_status: "Paid", created_at: "27-06-2022", id: 1, currency: "$", current_total_price: "150"),MockOrder(line_items: [OrderItem(variant_id: 1, quantity: 3, name: "nike shoes", price:"100")], customer: OrderCustomer(id: 0, first_name: "mohamed"), financial_status: "Paid", created_at: "27-06-2022", id: 1, currency: "$", current_total_price: "150"),MockOrder(line_items: [OrderItem(variant_id: 1, quantity: 3, name: "bata shoes", price:"100")], customer: OrderCustomer(id: 0, first_name: "mohamed"), financial_status: "Paid", created_at: "27-06-2022", id: 1, currency: "$", current_total_price: "150")]
    
    
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
        ordersTableView.dataSource = self
        ordersTableView.delegate   = self
    }
    
    
    private func registerCellsForTableView(){
        let ordersNib = UINib(nibName: String(describing: MyOrderTableViewCell.self), bundle: nil)
        ordersTableView.register(ordersNib, forCellReuseIdentifier: String(describing: MyOrderTableViewCell.self))

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MyOrdersViewController : UITableViewDataSource,UITableViewDelegate{
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (orders.isEmpty){
            noOrdersImage.isHidden = false
            ordersTableView.isHidden = true
        }else{
            noOrdersImage.isHidden = true
            ordersTableView.isHidden = false
        }
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyOrderTableViewCell.self), for: indexPath) as! MyOrderTableViewCell
        cell.setupCell(order: orders[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((ordersTableView.frame.height/8))

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier: String(describing: GetStartedViewController.self)) as! GetStartedViewController
    
       // viewController.brand = brands[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
}

