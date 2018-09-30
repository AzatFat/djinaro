//
//  itemsTableViewController.swift
//  Djinaro
//
//  Created by Azat on 21.09.2018.
//  Copyright © 2018 Azat. All rights reserved.
//

import UIKit




class itemsTableViewController: UITableViewController,UISearchBarDelegate {

    let goodsController = GoodsController()
    var goodList = [Good]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var search: UISearchBar!
    
    var id = ""
    var name = ""
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        search.delegate = self

        searchController.searchBar.delegate = self
        /*
        
        goodsController.fetchListGoods { (listGoods) in
            if let listGoods = listGoods {
                
                print("request List success")
                self.goodList = listGoods
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        */
        //hideKeyboardWhenTappedAround()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /*
        goodsController.fetchListGoods { (listGoods) in
            if let listGoods = listGoods {

                self.goodList = listGoods
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        */
        goodsController.fetchSearhGoods(search: "") { (listGoods) in
            if let listGoods = listGoods {
                
                print("request List success")
                
                self.goodList = listGoods
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true;
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Наименование", "Рамер"]
        searchBar.sizeToFit()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       // hideKeyboardWhenTappedAround()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        searchBar.showsCancelButton = false;
        searchBar.showsScopeBar = false
        searchBar.sizeToFit()
        
        goodsController.fetchListGoods { (listGoods) in
            if let listGoods = listGoods {
                
                self.goodList = listGoods
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        searchBar.resignFirstResponder()
    }
   
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let scopeString = searchBar.scopeButtonTitles? [searchBar.selectedScopeButtonIndex] else {return }
        
        searchBar.showsCancelButton = false;
        searchBar.showsScopeBar = false
        searchBar.sizeToFit()
        
        print(scopeString)
        
        if scopeString == "Рамер"{
            
            let searchList_1 = searchBar.text!.replacingOccurrences(of: ", ", with: ",")
            let searchList = searchList_1.replacingOccurrences(of: " ", with: ",")
            goodsController.fetchSearchGoodsBySize(search: searchList) { (listGoods) in
                if let listGoods = listGoods {
                    print("request List success")
                    self.goodList = listGoods
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            goodsController.fetchSearhGoods(search: searchBar.text!) { (listGoods) in
                if let listGoods = listGoods {
                    print("request List success")
                    self.goodList = listGoods
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        searchBar.resignFirstResponder()
      //  searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      //  searchBar.showsScopeBar = true
      //  searchBar.scopeButtonTitles = ["Наименование", "Рамер"]
       /*
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
         */
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        searchBarTextDidBeginEditing(searchBar)
        
    }

    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return goodList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "itemsTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? itemsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let good = goodList[indexPath.row]
        cell.labelTest.text = good.name
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        id = String(goodList[indexPath.row].id)
        name = String(goodList[indexPath.row].name)
        performSegue(withIdentifier: "ItemInfo", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemInfo" {
            
            let controller = segue.destination as! ItemsInfoTableViewController
            controller.id = id
            controller.type = "0"
            controller.title = name
            
        }
    }
}


extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
}
