//
//  MainSceneTableViewController.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/5/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit
import SwiftSpinner

class MainSceneTableViewController: UITableViewController {
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let userDefault : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Life Importer"
        registerTableViewCellCustomNib()
        styleTableView()
        if dataShouldBeImported {
            importDataForFirstTime()
        }
    }
    
    var dataShouldBeImported : Bool {
        get {
            var dataShouldBeImported = true
            
            if userDefault.valueForKey("DataImported") != nil {
                dataShouldBeImported = userDefault.boolForKey("DataImported")
            } else {
                userDefault.setBool(false, forKey: "DataImported")
            }
            return dataShouldBeImported
        }
    }
    
    private func importDataForFirstTime() {
        SwiftSpinner.show("Importing data for first time..", animated: true)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(5 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            self.importDataInBackground();
        }
    }
    
    private func importDataInBackground() {
        delegate.stack?.performBackgroundBatchOperation({ (workerContext) in
            DataImporter.sharedInstance.importData(workerContext, importDataCompletionHandler: { (error) in
                if (error == nil) {
                    print("Finished importing.")
                    SwiftSpinner.hide()
                } else {
                    UICommonActions.sharedInstance.showAlertView("Error", message: "It seems that something went wrong while importing data.", navigationController: self.navigationController)
                }
            })
        })
    }

    
    private func registerTableViewCellCustomNib() {
        tableView.registerNib(UINib(nibName: "MainSceneTableViewCell", bundle: nil), forCellReuseIdentifier: "MainSceneTableViewCell")
    }
    
    private func styleTableView() {
        self.view.backgroundColor = UIColor(red: 242.0/255.0, green: 241.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppSharedData.sharedInstance.homeScreenOptions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainSceneTableViewCell", forIndexPath: indexPath) as! MainSceneTableViewCell
        let homeScreenOption = AppSharedData.sharedInstance.homeScreenOptions[indexPath.row]
        if let homeScreenOptionName : String = AppSharedData.sharedInstance.homeScreenOptionsStringNames[homeScreenOption] {
            cell.mainOptionTitleLabel.text = homeScreenOptionName
            cell.mainOptionIconImageView.image = UIImage(named: homeScreenOptionName)
        }
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AppSharedData.sharedInstance.heightForTableViewRow
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SearchSceneSegue", sender: indexPath.row)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let searchSceneViewController = segue.destinationViewController as? SearchSceneViewController {
            if let tappedIndex = sender as? NSInteger {
                searchSceneViewController.homeScreenOptionType = AppSharedData.sharedInstance.homeScreenOptions[tappedIndex]
            }
        }
    }
}
