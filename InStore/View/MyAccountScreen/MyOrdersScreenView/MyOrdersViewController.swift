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
    private var myOrdersViewModel:MyOrdersViewModelType?
    private var bag = DisposeBag()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavControllerTransparent()
        configureTableView()
        myOrdersViewModel?.getData()
        
        
    }
    
    //MARK: - Methodes
    
    private func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func configureTableView(){
        registerCellsForTableView()
        bindOrders()
    }
    private func bindOrders(){
        ordersTableView.rx.itemSelected.subscribe(onNext: openOrderDetails).disposed(by: bag)
        
        
//                ordersTableView.rowHeight = UITableView.automaticDimension
//                ordersTableView.estimatedRowHeight = ordersTableView.frame.height/8
        
        myOrdersViewModel?.orderObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).asDriver(onErrorJustReturn: [])
            .drive( ordersTableView.rx.items(cellIdentifier: String(describing: MyOrderTableViewCell.self),cellType: MyOrderTableViewCell.self) ){( row, order, cell) in
                print("data")
                cell.setupCell(order: order)
            }.disposed(by: bag)
        
        
        myOrdersViewModel?.orderObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on:MainScheduler.instance).subscribe(onNext: { orders in

            if (orders.isEmpty)
            {
                self.noOrdersImage.isHidden = false
                self.ordersTableView.isHidden = true
                
            }else{
                self.noOrdersImage.isHidden = true
                self.ordersTableView.isHidden = false
            }
        })
    }
    
    private func openOrderDetails(_ indexPath: IndexPath) {
    
        let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: OrderDetailsViewController.self)) as! OrderDetailsViewController
        viewController.order = myOrdersViewModel?.orderList[indexPath.row]
        ordersTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func registerCellsForTableView(){
        let ordersNib = UINib(nibName: String(describing: MyOrderTableViewCell.self), bundle: nil)
        ordersTableView.register(ordersNib, forCellReuseIdentifier: String(describing: MyOrderTableViewCell.self))
    }
    
    
    func injectOrdersViewModel(myOrdersViewModel:MyOrdersViewModelType){
        self.myOrdersViewModel = myOrdersViewModel
    }
    
    
}




