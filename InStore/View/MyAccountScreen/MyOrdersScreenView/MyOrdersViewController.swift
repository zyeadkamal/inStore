//
//  MyOrdersViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 27/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyOrdersViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var noOrdersImage: UIImageView!
    @IBOutlet weak var ordersTableView: UITableView!
    
    //MARK: - Properties
    private var myOrdersViewModel:MyAccountViewModelType
    private var bag = DisposeBag()
    
    
    
    //MARK: - Init
    
    init?(coder: NSCoder ,myOrdersViewModel:MyAccountViewModelType ) {
        self.myOrdersViewModel = myOrdersViewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavControllerTransparent()
        configureTableView()
        
        
    }
    
    //MARK: - Methodes
    
    private func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func configureTableView(){
        registerCellsForTableView()
        ordersTableView
            .rx.setDelegate(self)
            .disposed(by: bag)
        bindOrders()
    }
    
    private func bindOrders(){
        ordersTableView.rx.itemSelected.subscribe(onNext: openOrderDetails).disposed(by: bag)
        
        myOrdersViewModel.orderObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).asDriver(onErrorJustReturn: [])
            .drive( ordersTableView.rx.items(cellIdentifier: String(describing: MyOrderTableViewCell.self),cellType: MyOrderTableViewCell.self) ){( row, order, cell) in
                print("data")
                cell.setupCell(order: order)
            }.disposed(by: bag)
        
        
        myOrdersViewModel.orderObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on:MainScheduler.instance).subscribe(onNext: { orders in

            print(orders.count)
            if (orders.isEmpty)
            {
                self.noOrdersImage.isHidden = false
                self.ordersTableView.isHidden = true
                
            }else{
                self.noOrdersImage.isHidden = true
                self.ordersTableView.isHidden = false
            }
            }).disposed(by: bag)
    }
    private func openOrderDetails(_ indexPath: IndexPath) {
        
        ordersTableView.deselectRow(at: indexPath, animated: true)
        guard let vc = self.storyboard?.instantiateViewController(identifier: String(describing: OrderDetailsViewController.self), creator: { (coder) -> OrderDetailsViewController? in
            OrderDetailsViewController(coder: coder, orderViewModel: self.myOrdersViewModel , index:indexPath)
        }) else {return}

        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
    
    private func registerCellsForTableView(){
        let ordersNib = UINib(nibName: String(describing: MyOrderTableViewCell.self), bundle: nil)
        ordersTableView.register(ordersNib, forCellReuseIdentifier: String(describing: MyOrderTableViewCell.self))
    }
    
}

extension MyOrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ordersTableView.frame.height/8
    }
}




