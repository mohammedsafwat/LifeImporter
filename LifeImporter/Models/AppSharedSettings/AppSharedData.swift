//
//  AppSharedSettings.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/5/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit

class AppSharedData: NSObject {
    static let sharedInstance = AppSharedData()
    
    enum FileModelType {
        case Food, Exercise, Category
    }
    
    enum HomeScreenOptionType {
        case Food, Exercise, Category
    }
    
    let homeScreenOptions = [HomeScreenOptionType.Food, HomeScreenOptionType.Exercise, HomeScreenOptionType.Category]
    
    let homeScreenOptionsStringNames : [HomeScreenOptionType : String] = [.Food : "Food", .Exercise : "Exercise", .Category : "Category"]
    
    let homeScreenOptionsEntityNames : [HomeScreenOptionType : String] = [.Food : "Food", .Exercise : "Exercise", .Category : "Category"]

    let heightForTableViewRow : CGFloat = 64.0
    
    let paddingOnTopOfMainSceneTableView : CGFloat = 3.0
}
