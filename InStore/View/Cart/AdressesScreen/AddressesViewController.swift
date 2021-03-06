//
//  AddressesViewController.swift
//  InStore
//
//  Created by sandra on 5/26/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddressesViewController: UIViewController {
    
    //MARK: -- IBOutlets
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var continuePaymentBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: -- Properties
    var selectedIndex : IndexPath?
    private var addressesVM : ChooseAddressViewModelType
    private var disposeBag = DisposeBag()
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavControllerTransparent()
        configureAddressesTableView()
        addressesVM.getData()
    }
    
    init?(coder: NSCoder, addressesVM : ChooseAddressViewModelType) {
        self.addressesVM = addressesVM
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been initialized")
    }
    
    //MARK: -- IBActions
    
    @IBAction func didPressContinuePayment(_ sender: UIButton) {
        guard let paymentVC = storyboard?.instantiateViewController(identifier: String(describing: PaymentViewController.self), creator: { (coder) in
            PaymentViewController(coder: coder, paymentVM: PaymentViewModel(repo: Repository.shared(localDataSource: LocalDataSource.shared(managedContext: ((UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext))!, apiClient: ApiClient())!, myOrder: self.addressesVM.order ?? PostOrderRequest()))
            
        }) else {return}
        print(" order object in addresses screen --> \(addressesVM.order ?? PostOrderRequest())")
        navigationController?.pushViewController(paymentVC, animated: true)
        
    }
    
    //MARK: -- Functions
    
    func configureAddressesTableView(){
        
        addressesVM.addressObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).asDriver(onErrorJustReturn: [])
            .drive( addressesTableView.rx.items(cellIdentifier: String(describing: AddressesTableViewCell.self),cellType: AddressesTableViewCell.self) ){( row, address, cell) in
                print("data")
                cell.addressName = "\(address.country ?? ""), \(address.address1 ?? "")"
                if self.selectedIndex?.row == row{
                    cell.setOptionSelection(true)
                }else{
                    cell.setOptionSelection(false)
                }
            }.disposed(by: disposeBag)
        
        addressesVM.showLoadingObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on:MainScheduler.instance).subscribe(onNext: { state in
            print(state)
            switch state {
            case .error:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.hideView()
                })
            case .empty:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.hideView()
                })
            case .loading:
                self.activityIndicator.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.addressesTableView.alpha = 0.0
                })
            case .populated:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.showView()
                })
                self.addressesTableView.reloadData()
            }
           
            }).disposed(by: disposeBag)
        
        addressesTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.addressesTableView.deselectRow(at: indexPath, animated: true)
            let cell = self?.addressesTableView.cellForRow(at: indexPath) as? AddressesTableViewCell
            self?.addressesVM.order?.order?.default_address = Address(customer_id: self!.getUserId(), address1: cell?.addressName, city: cell?.addressName, country: "Egypt")
            print("address selected is : \(self?.addressesVM.order?.order?.default_address)")
            self?.selectedIndex = indexPath
            self?.addressesTableView.reloadData()
            }).disposed(by: disposeBag)

    }

    func getUserId() -> Int {
       return (MyUserDefaults.getValue(forKey: .id) as! Int)
    }
    func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func hideView(){
        self.addressesTableView.alpha = 0.0
        self.activityIndicator.alpha = 0.0
    }
    
    func showView(){
        self.addressesTableView.alpha = 1.0
        self.activityIndicator.alpha = 0.0
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
