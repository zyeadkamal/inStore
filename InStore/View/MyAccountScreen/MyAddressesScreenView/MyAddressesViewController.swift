//
//  MyAddressesViewController.swift
//  InStore
//
//  Created by Mohamed Ahmed on 27/05/2022.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class MyAddressesViewController: UIViewController {
//noOrdersImage
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var noAddressesImage: UIImageView!
    var addresses = ["6 october","giza"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    
    private func configureTableView(){
        registerCellsForTableView()
        setupTableViewDataSource()
    }
    private func registerCellsForTableView(){
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
    }
    private func setupTableViewDataSource(){
        let addressNib = UINib(nibName: String(describing: MyAddressTableViewCell.self), bundle: nil)
        addressesTableView.register(addressNib, forCellReuseIdentifier: String(describing: MyAddressTableViewCell.self))
    }

    @IBAction func AddNewAddressPressed(_ sender: Any) {
        //AddAddressViewController
        let viewController = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: String(describing: AddAddressViewController.self)) as! AddAddressViewController
//          self.navigationController?.pushViewController(viewController, animated: true)
               viewController.modalPresentationStyle = .fullScreen
               self.present(viewController, animated: true, completion: nil)
    }


}

extension MyAddressesViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (addresses.isEmpty){
            print("empty")
            noAddressesImage.isHidden = false
            addressesTableView.isHidden = true
        }else{
            print("not")
            noAddressesImage.isHidden = true
            addressesTableView.isHidden = false
        }
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyAddressTableViewCell.self),for: indexPath) as! MyAddressTableViewCell
        cell.setupCell(address:addresses[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((addressesTableView.frame.height/8))

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: " Delete Address", message: "Are you sure you want to delete this \nchoose delete or cancel", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            self.addresses.remove(at: indexPath.row)
            self.addressesTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Cancel is pressed")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
