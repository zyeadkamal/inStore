//
//  OrderDetailsViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 27/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OrderDetailsViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var orderID: UILabel!
    @IBOutlet weak var orderedAtLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var orderDetailsTableView: UITableView!
    
    
    //MARK: - Properties
    
    private var orderViewModel:MyAccountViewModelType
    private var bag = DisposeBag()
    private var index : Int
    
    //MARK: - Init
    
    
    init?(coder: NSCoder ,orderViewModel:MyAccountViewModelType, index :IndexPath ) {
        self.orderViewModel = orderViewModel
        self.index = index.row
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavControllerTransparent()
        configureTableView()
        setOrderDetails()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Methodes

    private func configureTableView(){
        registerCellsForTableView()
        setupTableViewDataSource()
    }
    
    private func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupTableViewDataSource(){
        orderDetailsTableView.dataSource = self
        orderDetailsTableView.delegate   = self
    }
    
    private func setOrderDetails(){
        
        orderID.text = String("\((orderViewModel.orderList[index].id)!)")
        orderedAtLabel.text = orderViewModel.orderList[index].created_at?.getNamedDayNamedMonthYear()
        if(MyUserDefaults.getValue(forKey: .currency) as! String == "USD"){
            totalAmountLabel.text = String("\(orderViewModel.orderList[index].current_total_price ?? "0") $")
        }else{
            totalAmountLabel.text = String("\(Constants.convertPriceToEGP(priceToConv:orderViewModel.orderList[index].current_total_price ?? "0")) EGP")
           
        }
       
    }

    private func registerCellsForTableView(){
        let ordersNib = UINib(nibName: String(describing: OrderDetailsTableViewCell.self), bundle: nil)
        orderDetailsTableView.register(ordersNib, forCellReuseIdentifier: String(describing: OrderDetailsTableViewCell.self))

    }

}

//MARK: - UITableViewDelegate

extension OrderDetailsViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderViewModel.orderList[index].line_items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderDetailsTableViewCell.self), for: indexPath) as! OrderDetailsTableViewCell
        cell.setupCell(orderItem: (orderViewModel.orderList[index].line_items[indexPath.row]))
    
    
        return cell
    }
    
}

