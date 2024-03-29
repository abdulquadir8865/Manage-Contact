//
//  database.swift
//  Manage Contact
//
//  Created by droadmin on 20/10/23.
//

import Foundation

import CoreData
import UIKit


class databaseHandler:NSObject{

    static  let shareInstance = databaseHandler()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // save contact data
    func saveContactDetailsData(contactDict:[String:Any]){

        let contDetails = NSEntityDescription.insertNewObject(forEntityName: "ContactDetails", into: context) as? ContactDetails
        contDetails?.name = contactDict["name"] as? String
        contDetails?.birth = contactDict["birth"] as? String
        contDetails?.gender = contactDict["gender"] as? String

        let image = contactDict["image"]
        contDetails?.userImage = image as? Data
//        contDetails?.userImage = contactDict["userImage"] as? Data


        print("kwcnbefodcw")
        do{
            try context.save()
        }
        catch{
            print("error college")
        }
    }

    //fetch data
    func getContactData()->[ContactDetails]{
        var arDetails = [ContactDetails]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ContactDetails")
        do{
            arDetails = try context.fetch(fetchRequest) as! [ContactDetails]
//            arDetails = arDetails.sorted(by: {$0.?.lowercased() ?? "" < $1.firstName?.lowercased() ?? ""})
            arDetails = try context.fetch(ContactDetails.fetchRequest()) as! [ContactDetails] //type2
            print(arDetails)
            for idx in arDetails{
                print(idx)
            }
        }catch{
            print("error for save data!")
        }
        return arDetails
    }

    
    //for edit contactdata
    func editDetails(contDict:[String:Any],indx:Int){
        let details = self.getContactData()
        details[indx].name = contDict["name"] as? String
        details[indx].birth = contDict["birth"] as? String
        details[indx].gender = contDict["gender"] as? String
        
        details[indx].userImage = contDict["image"] as? NSData as Data?
        do{
            print(details)
            try context.save()
        }catch{
            print("error for eidt data!")
        }
    }


}
