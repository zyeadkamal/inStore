//
//  AddressesViewController.swift
//  InStore
//
//  Created by sandra on 5/26/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class AddressesViewController: UIViewController {
    
    //MARK: -- IBOutlets
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var continuePaymentBtn: UIButton!
    
    
    //MARK: -- Properties
    var selectedIndex : IndexPath?
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureAddressesTableView()
    }
    
    
    //MARK: -- IBActions
    
    @IBAction func didPressContinuePayment(_ sender: UIButton) {
        var paymentVC = storyboard?.instantiateViewController(withIdentifier: String(describing: PaymentViewController.self)) as! PaymentViewController
        navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    //MARK: -- Functions
    
    func configureAddressesTableView(){
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
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

extension AddressesViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addressesCell = addressesTableView.dequeueReusableCell(withIdentifier: "addressesCell", for: indexPath) as! AddressesTableViewCell
        addressesCell.addressTitle.text = "Egypt, Giza, 6 October"
        if selectedIndex == indexPath{
            addressesCell.setOptionSelection(true)
        }else{
            addressesCell.setOptionSelection(false)
        }
        return addressesCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addressesTableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath
        addressesTableView.reloadData()
    }
    
}
