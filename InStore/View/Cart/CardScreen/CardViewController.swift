//
//  CardViewController.swift
//  InStore
//
//  Created by sandra on 5/25/22.
//  Copyright © 2022 mac. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    //MARK: -- IBOutlets
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var totalAmountPriceLbl: UILabel!
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var emptyCartImg: UIImageView!
    @IBOutlet weak var containerStack: UIStackView!
    
    //MARK: -- Properties
    var hasAddress = false
    
    // ay list just for testing UI
    var cartList : [String] = [""]
    
    //MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavControllerTransparent()
        configureCardTableView()
        self.totalAmountPriceLbl.text = "$165.78"
    }
    
    //MARK: -- IBActions
    @IBAction func didPressCheckout(_ sender: UIButton) {
        if hasAddress {
            var addressesVC = storyboard?.instantiateViewController(withIdentifier: String(describing: AddressesViewController.self)) as! AddressesViewController
            navigationController?.pushViewController(addressesVC, animated: true)
        }else{
            var addAddressVC = storyboard?.instantiateViewController(withIdentifier: String(describing: AddAddressViewController.self)) as! AddAddressViewController
            navigationController?.pushViewController(addAddressVC, animated: true)
        }
    }
    

    //MARK: -- Functions
    func configureCardTableView(){
        cardTableView.delegate = self
        cardTableView.dataSource = self
    }
    
    func setNavControllerTransparent(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
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

extension CardViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        if (cartList.isEmpty){
            emptyCartImg.isHidden = false
            containerStack.isHidden = true
        }else{
            emptyCartImg.isHidden = true
            containerStack.isHidden = false
        }
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cardCell = cardTableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardTableViewCell
        cardCell.productCardTitle.text = "Stride Rite Kid Shoes"
        cardCell.productCardPrice.text = "$65.80"
        cardCell.productCardAmount.text = "2"
        return cardCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
