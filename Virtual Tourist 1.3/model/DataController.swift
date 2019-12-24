//
//  ViewController.swift
//  Virtual Tourist 1.3
//
//  Created by Muath Mohammed on 17/04/1441 AH.
//  Copyright © 1441 MuathMohammed. All rights reserved.
//


import Foundation
import CoreData

class DataController{
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        

        return persistentContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName: String){
        
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContext(){
        backgroundContext = persistentContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completionHandler: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (description, error) in
            guard error == nil else{
                print("Persistence Stor Load Error")
                fatalError(error!.localizedDescription)
            }
            print("DataController loaded")
            self.configureContext()
            completionHandler?()
        }
    }
}
