//
//  ViewController.swift
//  Manage Contact
//
//  Created by droadmin on 20/11/23.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,passDetailsData,UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBarTxt: UISearchBar!
    
    
    @IBOutlet weak var tableview: UITableView!
    
    
    @IBOutlet weak var aTozBtn: UIButton!
    
    @IBOutlet weak var zToaBtn: UIButton!
    
    @IBOutlet weak var maleBtn: UIButton!
    
    @IBOutlet weak var femaleBtn: UIButton!
    
    @IBOutlet weak var viewGender: UIView!
    
    
    
    var arrDetails:[[String:Any]] = [] // alldata from database
    var filteredData:[[String:Any]] = []
    
    var isSearch:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aTozBtn.layer.cornerRadius = 10
        zToaBtn.layer.cornerRadius = 10
        maleBtn.layer.cornerRadius = 10
        femaleBtn.layer.cornerRadius = 10
        viewGender.layer.cornerRadius = 10
        
        //selection button male&female
        maleBtn.setTitleColor(.blue, for: .normal)
        maleBtn.setTitleColor(.blue, for: .selected)
        femaleBtn.setTitleColor(.blue, for: .normal)
        femaleBtn.setTitleColor(.blue, for: .selected)
        
        // selection button male and female
        //selection button male&female
        maleBtn.setTitleColor(.blue, for: .normal)
        maleBtn.setTitleColor(.blue, for: .selected)
        femaleBtn.setTitleColor(.blue, for: .normal)
        femaleBtn.setTitleColor(.blue, for: .selected)
        
        filteredData = arrDetails
        tableview.allowsSelection = false
        
        //searchbar keyboard
        searchBarTxt.delegate = self
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtoTaped))
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([doneButton], animated: false)
        searchBarTxt.inputAccessoryView = toolBar
        
        //keyboard dow on tap screen
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
           view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        searchBarTxt.text = ""
        maleBtn.isSelected = false
        femaleBtn.isSelected = false
        
//        // on search add data then show search data after add
//        self.filteredData = self.arrDetails
//        tableview.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        filteredData = sortedData(aryData: arrDetails)
        searchData(searchText: searchBarTxt.text ?? "")
         tableview.reloadData()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData.count > 0 {
            // If there is filtered data, remove the label and return the count
            self.tableview.backgroundView = nil
            return filteredData.count
        } else {
            // If there is no filtered data, display the appropriate message
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableview.bounds.size.width, height: self.tableview.bounds.size.height))
            if self.isSearch {
                noDataLabel.text = "No Search Data Found"
            } else {
                noDataLabel.text = "No Data Available"
            }
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableview.backgroundView = noDataLabel
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as? contactTableViewCell
            cell?.lblName.text = filteredData[indexPath.row]["name"] as? String
            cell?.lblBirth.text = filteredData[indexPath.row]["date"] as? String
            cell?.lblDiscription.text = filteredData[indexPath.row]["discrip"] as? String
            cell?.imgview.image = filteredData[indexPath.row]["image"] as? UIImage
            cell?.lblGender.text = filteredData[indexPath.row]["gender"] as? String
            
            //addrtarget
            cell?.deleteBtn.tag = indexPath.row
            cell?.deleteBtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
            
            cell?.editBtn.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
            cell?.imgview.layer.cornerRadius = 55
            
            return cell!
      
        }
    
    //keyboard
    @objc func doneButtoTaped(){
        searchBarTxt.resignFirstResponder()
    }
    
    //passsing data
    //delegate:
    func passingData(dict: [String: Any], isUpdate: Bool) {
        if isUpdate,
            let originalIndex = arrDetails.firstIndex(where: { $0["id"] as? String == dict["id"] as? String }) {
            arrDetails[originalIndex] = dict
        } else {
            arrDetails.append(dict)
        }
        filteredData = sortedData(aryData: arrDetails)
        tableview.reloadData()

    }
    //addBtn for data 
    @IBAction func addBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addContactViewController") as? addContactViewController
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //delete
    @objc func deleteButtonTapped(_ sender: UIButton) {
        print(sender.tag)
        let alert = UIAlertController(title: "Delete Your Details", message: "Are you sure you want to delete?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            if self.isSearch == true {
                let getId = self.filteredData[sender.tag]["id"] as? String
                let index = self.arrDetails.firstIndex(where: {$0["id"] as? String == getId})
                self.filteredData.remove(at: sender.tag)
                self.arrDetails.remove(at: index!)
                self.filteredData = self.arrDetails
                self.searchBarTxt.text = ""
            }else
            {
                self.arrDetails.remove(at: sender.tag)
                self.filteredData.remove(at: sender.tag)

            }

            self.tableview.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }
    
    //for edit
    @objc func editButtonTapped(_ sender: UIButton) {
        print(sender.tag)
        let vc = storyboard?.instantiateViewController(withIdentifier: "addContactViewController") as? addContactViewController
        vc?.delegate = self
        vc?.isUpdate = true
        vc?.contactToEdit = filteredData[sender.tag]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //search data
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       searchData(searchText: searchText)
    }
    //search method
    func searchData(searchText: String) {
        if searchText.isEmpty {
               filteredData = arrDetails
            self.isSearch = false

           } else {
               self.isSearch = true
               filteredData = arrDetails.filter { item in
                   if let name = item["name"] as? String {
                       return name.lowercased().contains(searchText.lowercased())
                   }
                   return false
               }
           }
        filteredData = sortedData(aryData: filteredData)
           tableview.reloadData()
    }
    
    //sorted data
    func sortedData(aryData: [[String: Any]]) -> [[String: Any]] {
        let sortedData = aryData.sorted { (item1, item2) in
            if let name1 = item1["name"] as? String,
               let name2 = item2["name"] as? String,
               let num1 = Int(name1),
               let num2 = Int(name2) {
                if num1 < num2 {    //compare numeric number
                    return true
                } else if num1 > num2 {
                    return false
                }
                return name1 < name2    // numeric value equal, to check alphabet
            } else if let name1 = item1["name"] as? String,
                      let name2 = item2["name"] as? String {
                return name1 < name2   // compare the names alphabetically one or both cd't convert to int
            } else {
                return false
            }
        }
        return sortedData
    }

    //a to z    
    @IBAction func aTozBtn(_ sender: UIButton) {
        self.filteredData = self.filteredData.sorted { (item1, item2) in
            return ((item1["name"] as? String)!) < ((item2["name"] as? String)!)
        }
        tableview.reloadData()
    }
    
    @IBAction func zToA(_ sender: UIButton) {
        self.filteredData = self.filteredData.sorted { (item1, item2) in
            return ((item1["name"] as? String)!) > ((item2["name"] as? String)!)
        }
        tableview.reloadData()
    }
    
    
    //serchM/F
    @IBAction func searchMFBtn(_ sender: UIButton) {
        //selection
        if sender == maleBtn && maleBtn.isSelected {  // sender is select hai to unselcet krne lie use
            maleBtn.isSelected = false
            self.filteredData = arrDetails
            self.tableview.reloadData()
            return
        }
        
        if sender == femaleBtn && femaleBtn.isSelected {
            femaleBtn.isSelected = false
            self.filteredData = arrDetails
            self.tableview.reloadData()
            return
        }
        
        if sender == maleBtn{
            maleBtn.isSelected = true
            femaleBtn.isSelected = false
        }else{
            maleBtn.isSelected = false
            femaleBtn.isSelected = true
        }
        //tag 0 or 1 check
        if let selectedGender = sender.tag == 0 ? "Female" : "Male" {
            let filter = arrDetails.filter { ($0["gender"] as? String) == selectedGender }
            self.filteredData = filter
        }
        tableview.reloadData()
    }
    
    
}


