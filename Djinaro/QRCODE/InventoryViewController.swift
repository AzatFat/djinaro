//
//  InventoryViewController.swift
//  Djinaro
//
//  Created by Azat on 27.11.2018.
//  Copyright © 2018 Azat. All rights reserved.
//

import UIKit

protocol InventoryCellTapped: class {
    func segueToItemList(decodedString: String, searchType: String )
}

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SpyDelegate {
    
    var goodsFrontShop = [InventoryFrontShop]()
    var delegate: InventoryCellTapped!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var countLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getFrontInventoryShop()
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countItems = goodsFrontShop.count
        //countLable.text = String(countItems)
        return countItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "InventoryCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? InventoryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of GoodsTableViewCell.")
        }
        
        let inventoryGood  = goodsFrontShop[indexPath.row]
        cell.inventoryGoodName.text  = inventoryGood.g_nm
        
        cell.contentView.backgroundColor = UIColor.clear
        switch inventoryGood.status {
            
        case 1:
            cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.1)
        case 2:
            cell.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        case 3:
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        default:
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("trying to perform segue")
        //let cell = tableView.cellForRow(at: indexPath as IndexPath)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if(delegate != nil) {
            self.delegate.segueToItemList(decodedString: String(goodsFrontShop[indexPath.row].goods_id), searchType: "findGoodFromInventory")
        } else {
            print("delegate is nil")
        }
    }
    
    func getFrontInventoryShop(url: String) {
        print("table reloaded")
        countLable.text = "Ждем обновления"
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey:"token") as? String ?? ""
        let receiptController = ReceiptController(useMultiUrl: true)
        receiptController.GetFrontInventoryGoods(url: url,token: token) { (frontGoods) in
            if let frontGoods = frontGoods {
               self.goodsFrontShop = frontGoods.list
                DispatchQueue.main.async {
                    self.countLable.text = "\(String(frontGoods.scanned)) из \(String(frontGoods.totalAll))"
                }
            }
            DispatchQueue.main.async {
                self.goodsFrontShop.sort(by: { (lhs: InventoryFrontShop, rhs: InventoryFrontShop) -> Bool in
                    return lhs.status! < rhs.status!
                })
                self.tableView.reloadData()
               // self.addPreload(start_stop:  false)
            }
        }
    }

    
    
 /*   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GoodList" {
            let vc : QRScannerController = segue.destination as! QRScannerController
            vc.delegate = self
        }
    }*/
}



