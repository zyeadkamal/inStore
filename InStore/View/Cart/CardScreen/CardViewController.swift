//
//  CardViewController.swift
//  InStore
//
//  Created by sandra on 5/25/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxSwift

class CardViewController: UIViewController {
    
    //MARK: -- IBOutlets
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var totalAmountPriceLbl: UILabel!
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var emptyCartImg: UIImageView!
    @IBOutlet weak var containerStack: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: -- Properties
    
    var totalPrice : Double = 0.0
    
    var cartViewModel : CartViewModelType = CartViewModel(repo: Repository.shared(localDataSource: LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)!, apiClient: ApiClient())!)
    
    var disposeBag = DisposeBag()
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setNavControllerTransparent()
        configureCardTableView()
        cartViewModel.getLocalProducts(customerName: self.getUserEmail())
        bindTableEmptyOrNot()
        bindCartTableView()
        updatePriceLbl()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cartViewModel.getLocalProducts(customerName: self.getUserEmail())
        
    }
    
    //MARK: -- IBActions
    @IBAction func didPressCheckout(_ sender: UIButton) {
        
        if self.checkIfCustomerHasAddresses() {
            navigateToChooseAddress()
        }else{
            navigateToAddAddress()
        }
    }
    
    func checkIfCustomerHasAddresses() -> Bool {
        guard let hasAddress = MyUserDefaults.getValue(forKey: .hasAddress) as? Bool else { return false }
        return hasAddress
    }
    
    //MARK: -- Functions
    func configureCardTableView(){
        cardTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    func getUserEmail() -> String {
        if (MyUserDefaults.getValue(forKey: .email)) == nil{
            return ""
        }
        return (MyUserDefaults.getValue(forKey: .email) as! String)
    }
    func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func bindCartTableView(){
        var cartProduct : CartProduct?
        var cellIndex : IndexPath?
        cartViewModel.cartObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).asDriver(onErrorJustReturn: [])
            .drive( cardTableView.rx.items(cellIdentifier: String(describing: CardTableViewCell.self),cellType: CardTableViewCell.self) ){( index, product, cell) in
                cartProduct = product
                cellIndex = IndexPath(row: index, section: 0)
                print("data + \(index)")
                cell.count = product.productAmount
                print("cell.count \(cell.count)")
                cell.productTitle = product.productTitle
                cell.productPrice = "$\(product.productPrice ?? "")"
                cell.productAmount = "\(String(describing: product.productAmount))"
                cell.productImg = product.productImg
                cell.updateProduct = { count in
                    print("count \(count)")
                    self.cartViewModel.updateProductAmount(productId: product.productId , amount: count , customerName: self.getUserEmail())
                    self.updatePriceLbl()
                    self.cardTableView.reloadData()
                }

            }.disposed(by: disposeBag)
        self.delectProduct()
        self.cardTableView.reloadRows(at: [cellIndex ?? IndexPath(row: 0, section: 0)], with: .automatic)
    }
    func delectProduct(){
        cardTableView.rx.itemDeleted.subscribe(onNext: { (index) in
            let alert = UIAlertController(title: "Delete item?", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] _ in
                guard let self = self else{return}
                self.self.cartViewModel.removeProduct(atRow: index.row)
                self.updatePriceLbl()
                self.cardTableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        
        }).disposed(by: self.disposeBag)
        
       
        
    }
    func bindTableEmptyOrNot(){
        cartViewModel.cartObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] products in
            guard let self = self else{return}
            if(products.isEmpty){
                self.emptyCartImg.isHidden = false
                self.activityIndicator.isHidden = true
                self.containerStack.isHidden = true
            }else{
                self.emptyCartImg.isHidden = true
                self.containerStack.isHidden = false
                self.activityIndicator.isHidden = true
            }
            
        }).disposed(by: disposeBag)
    }
    
    func navigateToChooseAddress(){
        guard let addressesVC = storyboard?.instantiateViewController(identifier: String(describing: AddressesViewController.self), creator: { (coder) in
            AddressesViewController(coder: coder, addressesVM : ChooseAddressViewModel(repo: Repository.shared(apiClient: ApiClient())!, myOrder: PostOrderRequest(order: PostNewOrder(lineItems: self.cartViewModel.getListOfProductsToOrder() ?? [], total_line_items_price: self.calculateTotalPrice(products: self.cartViewModel.products ?? [])))))
        }) else { return }
        navigationController?.pushViewController(addressesVC, animated: true)
    }
    
    func navigateToAddAddress(){
        guard let addAddressVC = storyboard?.instantiateViewController(identifier: String(describing: AddAddressViewController.self), creator: { (coder) in
            AddAddressViewController(coder: coder, addAddressVM: AddAddressViewModel(repo: Repository.shared(apiClient: ApiClient())! , myOrder: PostOrderRequest(order: PostNewOrder(lineItems: self.cartViewModel.getListOfProductsToOrder() ?? [], total_line_items_price: self.calculateTotalPrice(products: self.cartViewModel.products ?? [])))))
        }) else { return }
        navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    
    func updatePriceLbl(){
        
        totalAmountPriceLbl.text = "$\(calculateTotalPrice(products: cartViewModel.products ?? []))"
    }
    
    func calculateTotalPrice(products : [CartProduct]) -> String{
        var totalSum : Double = 0.0
        products.forEach { (product) in
            totalSum += ((Double(product.productPrice ?? "0") ?? 0)*Double(product.productAmount))
        }
        totalPrice = totalSum
        print("total price : \(totalPrice)")
        return String(totalSum)
    }
    
    func hideView(){
        self.cardTableView.alpha = 0.0
        self.emptyCartImg.alpha = 1.0
        self.activityIndicator.alpha = 0.0
    }
    
    func showView(){
        self.cardTableView.alpha = 1.0
        self.emptyCartImg.alpha = 0.0
        self.activityIndicator.alpha = 0.0
    }
    
}

extension CardViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cardTableView.reloadData()
    }
    
}
