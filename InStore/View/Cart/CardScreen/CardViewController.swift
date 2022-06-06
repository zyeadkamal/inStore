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
    //var hasAddress = MyUserDefaults.getValue(forKey: .hasAddress)
    var hasAddress = true
    var cartViewModel : CartViewModelType?
    var totalPrice : Double?
    var disposeBag = DisposeBag()
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavControllerTransparent()
        
        cartViewModel = CartViewModel(repo: Repository.shared(localDataSource: LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)!, apiClient: ApiClient())!)
        configureCardTableView()
        
        cartViewModel?.getLocalProducts()
    }
    
    //MARK: -- IBActions
    @IBAction func didPressCheckout(_ sender: UIButton) {
        if hasAddress {
            navigateToChooseAddress()
        }else{
            navigateToAddAddress()
        }
    }

    //MARK: -- Functions
    func configureCardTableView(){
        cardTableView.rx.setDelegate(self).disposed(by: disposeBag)
        bindCartTableView()
        bindTableEmptyOrNot()
        bindLoadingState()
    }
    
    func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func bindLoadingState(){
        cartViewModel?.showLoadingObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] state in
            guard let self = self else {return}
            switch state{
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
                    self.cardTableView.alpha = 0.0
                    self.emptyCartImg.alpha = 0.0
                })
            case .populated:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.showView()
                })
                self.cardTableView.reloadData()
            }
        }, onError: {error in
            
            }).disposed(by: disposeBag)
    }
    
    func bindCartTableView(){
        cartViewModel?.cartObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).asDriver(onErrorJustReturn: [])
        .drive( cardTableView.rx.items(cellIdentifier: String(describing: CardTableViewCell.self),cellType: CardTableViewCell.self) ){( index, product, cell) in
            print("data")
            cell.productTitle = product.productTitle
            cell.productPrice = "$\(product.productPrice ?? "")"
            cell.productAmount = "\(String(describing: product.productAmount))"
            cell.productImg = product.productImg
            cell.updateProduct = { count in
                self.cartViewModel?.updateProductAmount(productId: product.productId , amount: count)
                self.updatePriceLbl()
                self.cardTableView.reloadData()
            }
            cell.deleteProduct = {
                self.updatePriceLbl()
                self.cartViewModel?.deleteProduct(productId: product.productId)
                self.cardTableView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
    
    func bindTableEmptyOrNot(){
        cartViewModel?.cartObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] products in
            guard let self = self else{return}
            if(products.isEmpty){
            self.emptyCartImg.isHidden = false
            self.containerStack.isHidden = true
        }else{
            self.emptyCartImg.isHidden = true
            self.containerStack.isHidden = false
        }

        }).disposed(by: disposeBag)
    }
    
    func navigateToChooseAddress(){
        guard let addressesVC = storyboard?.instantiateViewController(identifier: String(describing: AddressesViewController.self), creator: { (coder) in
            AddressesViewController(coder: coder, addressesVM : ChooseAddressViewModel(repo: Repository.shared(apiClient: ApiClient())!, myOrder: PostOrderRequest(order: PostNewOrder(lineItems: self.cartViewModel?.getListOfProductsToOrder() ?? [], total_line_items_price: String(self.totalPrice ?? 0.0)))))
        }) else { return }
        navigationController?.pushViewController(addressesVC, animated: true)
    }
    
    func navigateToAddAddress(){
        guard let addAddressVC = storyboard?.instantiateViewController(identifier: String(describing: AddAddressViewController.self), creator: { (coder) in
            AddAddressViewController(coder: coder, addAddressVM: AddAddressViewModel(repo: Repository.shared(apiClient: ApiClient())! , myOrder: PostOrderRequest(order: PostNewOrder(lineItems: self.cartViewModel?.getListOfProductsToOrder() ?? [], total_line_items_price: String(self.totalPrice ?? 0.0)))))
        }) else { return }
        navigationController?.pushViewController(addAddressVC, animated: true)
    }
    
    
    func updatePriceLbl(){
        
        totalAmountPriceLbl.text = "$\(calculateTotalPrice(products: cartViewModel?.products ?? []))"
    }
    
    func calculateTotalPrice(products : [CartProduct]) -> String{
        var totalSum : Double = 0.0
        products.forEach { (product) in
            totalSum += ((Double(product.productPrice ?? "0") ?? 0)*Double(product.productAmount))
        }
        totalPrice = totalSum
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
