//
//  CoreManage.swift
//  transmedik
//
//  Created by Idham Kurniawan on 23/07/21.
//

import Foundation
//1.
import CoreData
public class CoreDataManager {
    //2.
    public static let shared = CoreDataManager()
//3.
    let identifier: String  = AppSettings.frameworkBundleID       //Your framework bundle ID
    let model: String       = "databaseTransmedik"                      //Model name
    
    lazy var persistentContainer: NSPersistentContainer = {
            //5
            let messageKitBundle = Bundle(identifier: self.identifier)
            let modelURL = messageKitBundle!.url(forResource: self.model, withExtension: "momd")!
            let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
            
    // 6.
            let container = NSPersistentContainer(name: self.model, managedObjectModel: managedObjectModel!)
            container.loadPersistentStores { (storeDescription, error) in
                
                if let err = error{
                    fatalError("❌ Loading of store failed:\(err)")
                }
            }
            
            return container
        }()
    
    
}
