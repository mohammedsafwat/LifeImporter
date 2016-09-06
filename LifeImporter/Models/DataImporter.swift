//
//  DataImporter.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/5/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit
import CoreData

class DataImporter: NSObject {
    static let sharedInstance = DataImporter()
    
    let filesData : [String : AppSharedData.FileModelType] = ["categoriesStatic" : AppSharedData.FileModelType.Category, "exercisesStatic" : AppSharedData.FileModelType.Exercise, "foodStatic" : AppSharedData.FileModelType.Food]
    
    func importData(context : NSManagedObjectContext, importDataCompletionHandler completionHandler:(error : NSError?) -> Void) {
        do {
            for fileName in filesData.keys {
                if let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") {
                    let fileJSONString = try NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding)
                    if let fileJSONData : NSData = fileJSONString.dataUsingEncoding(NSUTF8StringEncoding) {
                        if let fileJSONObject : AnyObject = try NSJSONSerialization.JSONObjectWithData(fileJSONData, options: NSJSONReadingOptions.AllowFragments) {
                            if let fileJSONArray = fileJSONObject as? NSArray {
                                parseJSONValues(fileJSONArray, fileModelType: filesData[fileName], context: context, parseJSONValueCompletionHandler: { (error) in
                                    if (error != nil) {
                                        completionHandler(error: error)
                                    }
                                })
                            } else {
                                let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("An error happened while reading JSON file \(fileName)", comment: "")]
                                let error = NSError(domain: "LifeImporterErrorDomain", code: -57, userInfo: userInfo)
                                completionHandler(error: error)
                            }
                        }
                    }
                }
            }
            completionHandler(error: nil)
        } catch let error as NSError {
            completionHandler(error: error)
        }
    }
    
    private func parseJSONValues(jsonArray : NSArray, fileModelType : AppSharedData.FileModelType?, context : NSManagedObjectContext, parseJSONValueCompletionHandler completionHandler:(error : NSError?) -> Void) {
        for jsonObject in jsonArray {
            if let jsonDictionary : NSDictionary = jsonObject as? NSDictionary {
                saveJSONValuesToCoreData(jsonDictionary, fileModelType: fileModelType, context: context, saveJSONValuesToCoreDataCompletionJandler: { (error) in
                    if error != nil {
                        completionHandler(error: error)
                    }
                })
            }
        }
        completionHandler(error: nil)
    }
    
    private func saveJSONValuesToCoreData(jsonDictionary : NSDictionary, fileModelType : AppSharedData.FileModelType?, context : NSManagedObjectContext, saveJSONValuesToCoreDataCompletionJandler completionHandler:(error : NSError?) -> Void) {
        
        if fileModelType == .Category {
            let category = Category(categoryTitle: "", context: context)
            for (k, v) in jsonDictionary {
                if let key = k as? String {
                    if !(jsonDictionary.valueForKey(key) is NSNull) {
                        category.setValue(v, forKey: key)
                    }
                }
            }
        } else if fileModelType == .Food {
            let food = Food(foodTitle: "", context: context)
            for (k, v) in jsonDictionary {
                if let key = k as? String {
                    if !(jsonDictionary.valueForKey(key) is NSNull) {
                        food.setValue(v, forKey: key)
                    }
                }
            }
        } else if fileModelType == .Exercise {
            let exercise = Exercise(exerciseTitle: "", context: context)
            for (k, v) in jsonDictionary {
                if let key = k as? String {
                    if !(jsonDictionary.valueForKey(key) is NSNull) {
                        exercise.setValue(v, forKey: key)
                    }
                }
            }
        }
        completionHandler(error: nil)
    }
}
