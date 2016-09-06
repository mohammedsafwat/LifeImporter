//
//  Category.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/5/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit
import CoreData

class Category: NSManagedObject {
    convenience init(categoryTitle : String, context : NSManagedObjectContext) {
        if let entityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: context) {
            self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
            self.category = categoryTitle;
        } else {
            fatalError("Unable to find the entity named \"Category\"")
        }
    }
}
