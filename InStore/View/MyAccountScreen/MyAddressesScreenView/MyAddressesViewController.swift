//
//  MyAddressesViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 27/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyAddressesViewController: UIViewController {
//noOrdersImage
    //MARK: - IBOutlets

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var noAddressesImage: UIImageView!
    
    //MARK: - Properties

    var bag = DisposeBag()
    var myAddressViewModel : MyAddressViewModelType
   
    //MARK: - Init
    
    init?(coder: NSCoder ,myAddressViewModel:MyAddressViewModelType ) {
        self.myAddressViewModel = myAddressViewModel
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
        myAddressViewModel.getData(userId: getUserId())
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Methods
    
    private func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func getUserId() -> Int {
        if (MyUserDefaults.getValue(forKey: .id)) == nil{
            return 0
        }
        return (MyUserDefaults.getValue(forKey: .id) as! Int)
    }
    

    private func configureTableView(){
        registerCellsForTableView()
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        bindAddresses()
        
    }
    private func registerCellsForTableView(){
            let addressNib = UINib(nibName: String(describing: MyAddressTableViewCell.self), bundle: nil)
            addressesTableView.register(addressNib, forCellReuseIdentifier: String(describing: MyAddressTableViewCell.self))
    }
    private func bindAddresses(){

        myAddressViewModel.showLoadingObservable.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background)).observe(on:MainScheduler.instance).subscribe(onNext: {
            [weak self] state in
            guard let self = self else{return}
            
            switch state {
            case .error:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.addressesTableView.alpha = 0.0
                    self.noAddressesImage.alpha = 1.0
                    self.activityIndicator.alpha = 0.0

                })
            case .empty:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.addressesTableView.alpha = 0.0
                    self.noAddressesImage.alpha = 1.0
                    self.activityIndicator.alpha = 0.0

                })
            case .loading:
                self.activityIndicator.startAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.addressesTableView.alpha = 0.0
                    self.noAddressesImage.alpha = 0.0
                })
            case .populated:
                self.activityIndicator.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self.addressesTableView.alpha = 1.0
                    self.noAddressesImage.alpha = 0.0
                    self.activityIndicator.alpha = 0.0
                    
                })
                self.addressesTableView.reloadData()
            }
           
            }).disposed(by: bag)
    }
    
    private func openOrderDetails(_ indexPath: IndexPath) {
    
        self.addressesTableView.deselectRow(at: indexPath, animated: true)
        
    }

    //MARK: - IBActions

    @IBAction func AddNewAddressPressed(_ sender: Any) {
        self.myAddressViewModel.deleteData(index: 1,userId: self.getUserId())
    }
}


//MARK: - UITableViewDelegate,UITableViewDataSource

extension MyAddressesViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return myAddressViewModel.addressesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyAddressTableViewCell.self),for: indexPath) as! MyAddressTableViewCell
        let address = myAddressViewModel.addressesList[indexPath.row]
        cell.setupCell(address:String("\((address.country)!),\((address.city)!),\((address.address1)!)"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((addressesTableView.frame.height/7))

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: " Delete Address", message: "Are you sure you want to delete this \nchoose delete or cancel", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.myAddressViewModel.deleteData(index: indexPath.row , userId: self.getUserId())
    
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Cancel is pressed")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
