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
    @IBOutlet weak var userNameLabel: UILabel!
    
    //MARK: - Properties
    
    private var myAccountViewModel = MyAccountViewModel(repo: Repository.shared(localDataSource: LocalDataSource.shared(managedContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)! , apiClient: ApiClient())!)
    
    let items: Observable<[String]> = Observable.of(["EGP", "USD"])

    
    private var bag = DisposeBag()
    
    //MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.isNotLoggedIn()){
            let viewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier: String(describing: GetStartedViewController.self))
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
        else {
            setUsername()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavControllerTransparent()
        
        configureCollectionViews()
        myAccountViewModel.getData(userId: getUserId())
        // Do any additional setup after loading the view.
    }

    
    //MARK: - Methodes
    
    func isNotLoggedIn() -> Bool  {
        if(MyUserDefaults.getValue(forKey: .loggedIn) == nil){
            return true
        }else if(MyUserDefaults.getValue(forKey: .loggedIn) as! Int == 0) {
            return true
        }else{
            return false
        }
    }
    
    func setUsername()  {
        userNameLabel.text = (MyUserDefaults.getValue(forKey: .username) as! String)
    }
    
    func getUserId() -> Int {
        if (MyUserDefaults.getValue(forKey: .id)) == nil{
            return 0
        }
        return (MyUserDefaults.getValue(forKey: .id) as! Int)
    }
    
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
                cell.setupCell(order: order)
            }.disposed(by: bag)
        
        myAccountViewModel.showLoadingObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on:MainScheduler.instance).subscribe(onNext: {
            [weak self] state in
            guard let self = self else{return}
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
                    self.activityIndicator.alpha = 1.0

                })
            case .populated:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.ordersTableView.alpha = 1.0
                    self.noOrdersImage.alpha = 0.0
                    self.activityIndicator.alpha = 0.0
                    
                })
            }
        }).disposed(by: bag)
    }
    
    private func openOrderDetails(_ indexPath: IndexPath) {
        
        ordersTableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = self.storyboard?.instantiateViewController(identifier: String(describing: OrderDetailsViewController.self), creator: { (coder) -> OrderDetailsViewController? in
            OrderDetailsViewController(coder: coder, orderViewModel: self.myAccountViewModel , index:indexPath)
        }) else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func emptyUserDefaults(){
        MyUserDefaults.add(val: false, key: .loggedIn)
        MyUserDefaults.add(val: "", key: .email)
        MyUserDefaults.add(val: "", key: .username)
        MyUserDefaults.add(val: 0, key: .id)
        MyUserDefaults.add(val: false, key: .hasAddress)
        MyUserDefaults.add(val: "$", key: .currency)
    }
    
    func showPickerView(){
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 100))
        items.bind(to: pickerView.rx.itemTitles) { (row, element) in
            return element
        }
        .disposed(by: bag)
        
        pickerView.rx.itemSelected
            .subscribe { (event) in
                switch event {
                case .next(let selected):
                    MyUserDefaults.add(val: selected.row, key: .currency)
                    print("You selected #\(selected.row)")
                default:
                    break
                }
            }
            .disposed(by: bag)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func logoutPressed(_ sender: Any) {
        //        let viewController = UIStoryboard(name: "SplashScreen", bundle: nil).instantiateViewController(withIdentifier: String(describing: GetStartedViewController.self)) as! GetStartedViewController
        //        //homeScreenViewModel.getBrandAtIndex(indexPath: indexPath)
        //
        //
        //       // viewController.brand = brands[indexPath.row]
        //        self.navigationController?.pushViewController(viewController, animated: true)
        let vc = UIStoryboard(name: "UserAuthentication",bundle: nil).instantiateViewController(identifier: String(describing: LoginViewController.self)) as! LoginViewController
        emptyUserDefaults()
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
        
        let alert = UIAlertController(title: "Choose Currency", message: nil, preferredStyle: .actionSheet)
        
        let usd  = UIAlertAction(title: "USD", style: .default) { (UIAlertAction) in
            MyUserDefaults.add(val: "USD", key: .currency)
        }
        let egp  = UIAlertAction(title: "EGP", style: .default) { (UIAlertAction) in
            
            MyUserDefaults.add(val: "EGP", key: .currency)

        }
        
        let cancel  = UIAlertAction(title: "Cancel", style: .destructive) { (UIAlertAction) in
            
            alert.dismiss(animated: true)

        }
        
        alert.addAction(usd)
        alert.addAction(egp)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
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
