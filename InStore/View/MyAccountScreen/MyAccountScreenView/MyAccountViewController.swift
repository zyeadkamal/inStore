//
//  MyAccountViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 27/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyAccountViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noOrdersImage: UIImageView!
    @IBOutlet weak var ordersTableView: UITableView!
    
    //MARK: - Properties
    
    private var myAccountViewModel = MyAccountViewModel(repo: Repository.shared(localDataSource: LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)! , apiClient: ApiClient())!)

    
    private var bag = DisposeBag()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavControllerTransparent()
        configureCollectionViews()
        myAccountViewModel.getData()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Methodes
    
    private func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func configureCollectionViews(){
        registerCellsForTableView()
        ordersTableView
            .rx.setDelegate(self)
            .disposed(by: bag)
        bindOrders()
    }
    
    private func registerCellsForTableView(){
        let ordersNib = UINib(nibName: String(describing: MyOrderTableViewCell.self), bundle: nil)
        ordersTableView.register(ordersNib, forCellReuseIdentifier: String(describing: MyOrderTableViewCell.self))
        
    }
    private func bindOrders(){
        ordersTableView.rx.itemSelected.subscribe(onNext: openOrderDetails).disposed(by: bag)
        
        myAccountViewModel.orderObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).asDriver(onErrorJustReturn: [])
            .drive( ordersTableView.rx.items(cellIdentifier: String(describing: MyOrderTableViewCell.self),cellType: MyOrderTableViewCell.self) ){( row, order, cell) in
                print("data")
                cell.setupCell(order: order)
            }.disposed(by: bag)
        
        myAccountViewModel.showLoadingObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on:MainScheduler.instance).subscribe(onNext: { state in
            
            switch state {
            case .error:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.ordersTableView.alpha = 0.0
                    self.noOrdersImage.alpha = 1.0
                    self.activityIndicator.alpha = 0.0

                })
            case .empty:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.ordersTableView.alpha = 0.0
                    self.noOrdersImage.alpha = 1.0
                    self.activityIndicator.alpha = 0.0

                })
            case .loading:
                self.activityIndicator.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.ordersTableView.alpha = 0.0
                    self.noOrdersImage.alpha = 0.0
                })
            case .populated:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.ordersTableView.alpha = 1.0
                    self.noOrdersImage.alpha = 0.0
                    self.activityIndicator.alpha = 0.0

                })
            }
        })
    }
    
    private func openOrderDetails(_ indexPath: IndexPath) {
        
        ordersTableView.deselectRow(at: indexPath, animated: true)

        guard let vc = self.storyboard?.instantiateViewController(identifier: String(describing: OrderDetailsViewController.self), creator: { (coder) -> OrderDetailsViewController? in
            OrderDetailsViewController(coder: coder, orderViewModel: self.myAccountViewModel , index:indexPath)
        }) else {return}

        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    
    //MARK: - IBActions
    
    @IBAction func logoutPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: String(describing: LoginViewController.self)) as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func seeMoreOrdersPressed(_ sender: Any) {
        
        guard let vc = self.storyboard?.instantiateViewController(identifier: String(describing: MyOrdersViewController.self), creator: { (coder) -> MyOrdersViewController? in
            MyOrdersViewController(coder: coder, myOrdersViewModel: self.myAccountViewModel)
        }) else {return}
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func CurrencyPressed(_ sender: Any) {
    }
    
    @IBAction func AddressesPressed(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: String(describing: MyAddressesViewController.self), creator: { (coder) -> MyAddressesViewController? in
            MyAddressesViewController (coder: coder, myAddressViewModel: MyAddressViewModel(repo: Repository.shared(localDataSource: LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)! , apiClient: ApiClient())!))
        }) else {return}

        self.navigationController?.pushViewController(vc, animated: true)
//
//        let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: MyAddressesViewController.self)) as! MyAddressesViewController
//
//        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
}
extension MyAccountViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((ordersTableView.frame.height/2))
        
    }
    
}
