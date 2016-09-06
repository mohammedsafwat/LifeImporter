//
//  SearchSceneViewController.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/6/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit
import CoreData

class SearchSceneViewController: CoreDataViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    var homeScreenOptionType : AppSharedData.HomeScreenOptionType?
    private var numberOfReturnedSearchResults : Int = 0
    private var searchResults = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureSearchResultsTableView()
        registerSearchResultsTableViewCellCustomNib()
        fetchResultsFromCoreData()
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        if let homeScreenOptionType = self.homeScreenOptionType {
            if let homeScreenOptionName = AppSharedData.sharedInstance.homeScreenOptionsStringNames[homeScreenOptionType] {
                searchBar.placeholder = "Search for " + homeScreenOptionName
            }
        }
    }
    
    private func configureSearchResultsTableView() {
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
    }
    
    private func registerSearchResultsTableViewCellCustomNib() {
        searchResultsTableView.registerNib(UINib(nibName: "SearchResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultsTableViewCell")
    }
    
    private func getCoreDataStack() -> CoreDataStack? {
        // Get the Core Data Stack
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.stack
    }
    
    private func fetchResultsFromCoreData() {
        // Create a fetch request
        if let homeScreenOptionType = self.homeScreenOptionType {
            if let homeScreenOptionEntityName = AppSharedData.sharedInstance.homeScreenOptionsEntityNames[homeScreenOptionType] {
                let fetchRequest = NSFetchRequest(entityName: homeScreenOptionEntityName)
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastupdated", ascending: false)]
                
                if let coreDataStack = getCoreDataStack() {
                    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Search Results Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fc = fetchedResultsController {
            return fc.sections![section].numberOfObjects;
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultsTableViewCell", forIndexPath: indexPath) as! SearchResultsTableViewCell
        if self.homeScreenOptionType == .Food {
            if let searchResult = fetchedResultsController?.objectAtIndexPath(indexPath) as? Food {
                cell.searchResultTitleLabel.text = searchResult.title
            }
        } else if self.homeScreenOptionType == .Exercise {
            if let searchResult = fetchedResultsController?.objectAtIndexPath(indexPath) as? Exercise {
                cell.searchResultTitleLabel.text = searchResult.title
            }
        } else if self.homeScreenOptionType == .Category {
            if let searchResult = fetchedResultsController?.objectAtIndexPath(indexPath) as? Category {
                cell.searchResultTitleLabel.text = searchResult.category
            }
        }
        return cell
    }
    
    // MARK: - Search Results Table view delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AppSharedData.sharedInstance.heightForTableViewRow
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
