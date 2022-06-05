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
    
    //MARK: -- Properties
    var hasAddress = true
    var cartViewModel : CartViewModelType?
    var totalPrice : Int?
    var disposeBag = DisposeBag()
    var cartList = [""]
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavControllerTransparent()
        
        cardTableView.rx.setDelegate(self).disposed(by: disposeBag)
        cartViewModel = CartViewModel(repo: Repository.shared(localDataSource: LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)!, apiClient: ApiClient())!)
        configureCardTableView()
        cartViewModel?.getLocalProducts()
        totalAmountPriceLbl.text = "\(calculateTotalPrice(products: cartViewModel?.products ?? [])) EGP"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartViewModel?.getLocalProducts()
        totalAmountPriceLbl.text = "\(calculateTotalPrice(products: cartViewModel?.products ?? [])) EGP"
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        totalAmountPriceLbl.text = "\(calculateTotalPrice(products: cartViewModel?.products ?? [])) EGP"
    }
    //MARK: -- IBActions
    @IBAction func didPressCheckout(_ sender: UIButton) {
//        let myProduct = Product(id: 7330408726700, title: "ADIDAS", description: "ADIDAS", vendor: "ADIDAS", productType: "ACCESSORIES", images: [ProductImage(id: 5444, productID: 7330408726700, position: 1, width: 635.0, height: 560.0, src: "https://cdn.shopify.com/s/files/1/0645/8441/7515/products/85cc58608bf138a50036bcfe86a3a362.jpg?v=1653146549", graphQlID: "gid://shopify/ProductImage/37295483912427")], options: [OptionList(id: 9456229679276, productID: 7330408726700, name: "Size", position: 1, values: ["OS"])], varients: [Varient(id: 41672049819820, productID: 7330408726700, title: "OS / black", price: "70.00")], count: 1)
////
//        cartViewModel?.addProductToCart(product: myProduct)
        if hasAddress {
            guard let addressesVC = storyboard?.instantiateViewController(identifier: String(describing: AddressesViewController.self), creator: { (coder) in
                AddressesViewController(coder: coder, addressesVM : ChooseAddressViewModel(repo: Repository.shared(apiClient: ApiClient())!, myOrder: PostOrderRequest(order: PostNewOrder(lineItems: self.cartViewModel?.getListOfProductsToOrder() ?? [], total_line_items_price: self.calculateTotalPrice(products: self.cartViewModel?.products ?? [])))))
            }) else { return }
            print("my order -> \(self.cartViewModel?.getListOfProductsToOrder() ?? [])")
            navigationController?.pushViewController(addressesVC, animated: true)
        }else{
            guard let addAddressVC = storyboard?.instantiateViewController(identifier: String(describing: AddAddressViewController.self), creator: { (coder) in
                AddAddressViewController(coder: coder, addAddressVM: AddAddressViewModel(repo: Repository.shared(apiClient: ApiClient())! , myOrder: PostOrderRequest(order: PostNewOrder(lineItems: self.cartViewModel?.getListOfProductsToOrder() ?? [], total_line_items_price: self.calculateTotalPrice(products: self.cartViewModel?.products ?? [])))))
            }) else { return }
            print(cartViewModel?.getListOfProductsToOrder())
            navigationController?.pushViewController(addAddressVC, animated: true)
        }
    }

    //MARK: -- Functions
    func configureCardTableView(){
        bindCartTableView()
        bindTableEmptyOrNot()
    }
    
    func bindCartTableView(){
        cartViewModel?.cartObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).asDriver(onErrorJustReturn: [])
        .drive( cardTableView.rx.items(cellIdentifier: String(describing: CardTableViewCell.self),cellType: CardTableViewCell.self) ){( index, product, cell) in
            print("data")
            cell.productTitle = product.productTitle
            cell.productPrice = "\(product.productPrice ?? "") EGP"
            cell.productAmount = "\(String(describing: product.productAmount))"
            cell.productImg = product.productImg
            cell.updateProduct = { count in
                self.cartViewModel?.updateProductAmount(productId: product.productId , amount: count)
                self.cardTableView.reloadData()
            }
            cell.deleteProduct = {
                self.cartViewModel?.deleteProduct(productId: product.productId)
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
    
    
    func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func calculateTotalPrice(products : [CartProduct]) -> String{
        var totalSum : Double = 0.0
        products.forEach { (product) in
            totalSum += ((Double(product.productPrice ?? "0") ?? 0)*Double(product.productAmount))
        }
        return String(totalSum)
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
