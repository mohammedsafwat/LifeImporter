//
//  Food+CoreDataProperties.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/5/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit
import CoreData

extension Food {
    @NSManaged var title : String?
    @NSManaged var category : Category?
}
