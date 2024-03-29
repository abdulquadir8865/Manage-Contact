//
//  addContactViewController.swift
//  Manage Contact
//
//  Created by droadmin on 20/10/23.
//

import UIKit

protocol passDetailsData{
    func passingData(dict:[String:Any], isUpdate: Bool)
}

class addContactViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var importnImgBtn: UIButton!
    @IBOutlet weak var btnSave: UIButton!//outlet
    @IBOutlet weak var txtDiscription: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!        //datepickr
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    var delegate:passDetailsData?
    var placeholder = "Location!"

    //edit 
    var isUpdate = false
    var contactToEdit :[String:Any] = [:]
    var saveDate:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewcorner Radius
        view1.layer.cornerRadius = 10
        view2.layer.cornerRadius = 10
        view4.layer.cornerRadius = 10
        view1.clipsToBounds = true
        view2.clipsToBounds = true
        view4.clipsToBounds = true
        
        //corner
        btnSave.layer.cornerRadius = 10
        importnImgBtn.layer.cornerRadius = 10
        btnMale.layer.cornerRadius = 10
        btnFemale.layer.cornerRadius = 10
        self.imageview.layer.cornerRadius = 120

        //selection button male&female
        btnMale.setTitleColor(.blue, for: .normal)
        btnMale.setTitleColor(.blue, for: .selected)
        btnFemale.setTitleColor(.blue, for: .normal)
        btnFemale.setTitleColor(.blue, for: .selected)

//        datePicker
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = .current
        datePicker.date = Date()
        datePicker.center = view.center
//sssss
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
     
        //textview
        setupTextview()
        
        //keyboard
        txtDiscription.delegate = self
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtoTaped))
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.setItems([doneButton], animated: false)
        txtName.inputAccessoryView = toolBar
        txtDiscription.inputAccessoryView = toolBar

        
        //look for single or multiple tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        

    }
    
    //call this function when the tap is recognize
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
    
    
    //keyboard
    @objc func doneButtoTaped(){
        txtName.resignFirstResponder()
        txtDiscription.resignFirstResponder()

    }
    //datepicker
    @objc func handleDatePicker(sender: UIDatePicker){
        print("ok")
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                saveDate = dateFormatter.string(from: sender.date)
                print(saveDate)
    }
    //willapear
    override func viewWillAppear(_ animated: Bool) {
       if isUpdate{
           btnSave.setTitle("Update", for: .normal)

           txtName.text = contactToEdit["name"] as? String
           txtDiscription.text = contactToEdit["discription"] as? String

           if txtDiscription.text.isEmpty {
               txtDiscription.text = placeholder
               txtDiscription.textColor = .lightGray
           } else {
               txtDiscription.textColor = .black
           }
           if imageview != nil{
               imageview.image = contactToEdit["image"] as? UIImage
           }
           //fordate
           let dateformat = DateFormatter()
           dateformat.dateFormat = "dd-MM-yyyy"

           if let dateToString = dateformat.date(from: contactToEdit["date"] as! String) {
               datePicker.date = dateToString
           } else {
               print("default date")
           }
           
           if let gender = contactToEdit["gender"] as? String {
               if gender == "Male" {
                   btnMale.isSelected = true
                   btnFemale.isSelected = false
               } else if gender == "Female" {
                   btnMale.isSelected = false
                   btnFemale.isSelected = true
               }
           }
   
       }else{
           btnSave.setTitle("Save", for: .normal)

       }
    }
    
    
    
    //textview
    func setupTextview(){
        self.txtDiscription.text = placeholder
        self.txtDiscription.textColor = .lightGray
        self.txtDiscription.layer.borderWidth = 0.5
        self.txtDiscription.layer.borderColor = UIColor.black.cgColor
        self.txtDiscription.layer.cornerRadius = 10.0
        
        self.txtDiscription.delegate = self
 
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder && textView.textColor == .lightGray{
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = placeholder
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    

    
    @IBAction func addImgBtn(_ sender: UIButton) {
        
   let imgPiker = UIImagePickerController()
        imgPiker.delegate = self
        imgPiker.sourceType = .photoLibrary
        self.present(imgPiker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageview.image = pickedImage
        }
        
        self.dismiss(animated: true,completion: nil)
    }
    
    //save all data type1:
//    func saveAlldata(dict:[String:Any]){
//
//        var dictionary: [String: Any] = ["name": txtName.text!]
//        dictionary["discrip"] = txtDiscription.text
//        dictionary["image"] = imageview.image
//        if saveDate == ""{
//            let alert = UIAlertController(title: "Invalid", message: "Please select your date of birth", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
//            present(alert, animated: true)
//
//        }else
//        {
//            dictionary["date"] = saveDate
//        }
//        //for gender
//        if btnMale.isSelected {
//            dictionary["gender"] = btnMale.titleLabel?.text
//        } else if btnFemale.isSelected {
//            dictionary["gender"] = btnFemale.titleLabel?.text
//        } else {
//            let alert = UIAlertController(title: "Invalid", message: "Please select your gender", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
//            present(alert, animated: true)
//            return
//        }
//
//        //
//        if txtName.text != "" && saveDate != "" && txtDiscription.text != "" {
//            delegate?.passingData(dict: dictionary)
//        }else {
//            let alert = UIAlertController(title: "Invalid", message: "Please enter your name", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
//            present(alert, animated: true)
//        }
//        //img
////        else{
////            let alert = UIAlertController(title: "Invalid", message: "Please enter your name", preferredStyle: .alert)
////            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
////            present(alert, animated: true)
////        }
////
////        if isUpdate{
////            delegate?.passingData(dict: dictionary)
////            self.dismiss(animated: true)
////
////        }
//        delegate?.passingData(dict: dictionary)
//
//        self.navigationController?.popViewController(animated: true)
//    }
    
    
    
    //type2:
    func SaveAllData(dict: [String: Any]){
        var dictt:[String:Any] = ["name" :txtName.text!]
        if txtName.text == "" {
            errorShow(message: "Please enter your name")
            return
        }
       
        if txtDiscription.text == placeholder{
            dictt["discription"] = ""
        }else{
            dictt["discription"] = txtDiscription.text
        }

        dictt["image"] = imageview.image
        
        if isUpdate == true{
            dictt["id"] = contactToEdit["id"]
        }else{
            dictt["id"] = UUID().uuidString

        }
        
        if btnMale.isSelected{
            dictt["gender"] = btnMale.titleLabel?.text
        }else if btnFemale.isSelected{
            dictt["gender"] = btnFemale.titleLabel?.text
        }else{
            errorShow(message: "Please select your gender")
            return
        }
        
        let dateformat = DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        dateformat.dateFormat = "dd-MM-yyyy"
        dictt["date"] = dateformat.string(from: datePicker.date)

        if isUpdate{
            delegate?.passingData(dict: dictt, isUpdate: true)
        }else{
            if txtName.text != ""  {
                delegate?.passingData(dict: dictt, isUpdate: false)
            }
        }
        
    }

    
    //
    @IBAction func saveBtn(_ sender: UIButton) {
        
        SaveAllData(dict: [:])
        self.navigationController?.popViewController(animated: true)
    }
    
    //validation for error show
        func errorShow(message: String) {
            let alert = UIAlertController(title: "Invalid", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    
    
    @IBAction func selectGender(_ sender: UIButton) {
        if sender == btnMale{
            btnMale.isSelected = true
            btnFemale.isSelected = false
        }else{
            btnMale.isSelected = false
            btnFemale.isSelected = true
        }
        
    }
   
}


extension addContactViewController{
    //for name validate
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charPattern = "^[a-zA-Z0-9 ]*$"
        
        if let text = textField.text as NSString? {
            let updatedText = text.replacingCharacters(in: range, with: string)
            
            if let regex = try? NSRegularExpression(pattern: charPattern, options: .caseInsensitive) {
                let range = NSRange(location: 0, length: updatedText.count)
                if regex.numberOfMatches(in: updatedText, options: [], range: range) == 0 {
                    return false
                }
            }
        }
        return true
    }
}
