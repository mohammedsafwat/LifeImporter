//
//  Food.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/5/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit
import CoreData

class Food: NSManagedObject {
    convenience init(foodTitle : String, context : NSManagedObjectContext) {
        if let entityDescription = NSEntityDescription.entityForName("Food", inManagedObjectContext: context) {
            self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
            self.title = foodTitle;
        } else {
            fatalError("Unable to find the entity named \"Food\"")
        }
    }
}
