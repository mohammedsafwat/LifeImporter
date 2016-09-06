//
//  Exercise.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/5/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit
import CoreData

class Exercise: NSManagedObject {
    convenience init(exerciseTitle : String, context : NSManagedObjectContext) {
        if let entityDescription = NSEntityDescription.entityForName("Exercise", inManagedObjectContext: context) {
            self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Unable to find the entity named \"Exercise\"")
        }
    }
}
