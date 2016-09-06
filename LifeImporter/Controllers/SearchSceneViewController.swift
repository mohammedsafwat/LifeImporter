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
    var filteredSearchResults = [AnyObject]?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureSearchResultsTableView()
        registerSearchResultsTableViewCellCustomNib()
        fetchResultsFromCoreData { (error) in
            if (error != nil) {
                UICommonActions.sharedInstance.showAlertView("Error", message: "It seems that something went wrong while fetching search results", navigationController: self.navigationController)
            } else {
                self.searchBar.userInteractionEnabled = true
            }
        }
    }
    
    // MARK: - UI Configuration
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.userInteractionEnabled = false
        if let homeScreenOptionType = self.homeScreenOptionType {
            if let homeScreenOptionName = AppSharedData.sharedInstance.homeScreenOptionsStringNames[homeScreenOptionType] {
                searchBar.placeholder = "Search for " + homeScreenOptionName
            }
        }
    }
    
    private func configureSearchResultsTableView() {
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.tableFooterView = UIView()
    }
    
    private func registerSearchResultsTableViewCellCustomNib() {
        searchResultsTableView.registerNib(UINib(nibName: "SearchResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultsTableViewCell")
    }
    
    // MARK: - Core Data Helper Methods
    
    private func getCoreDataStack() -> CoreDataStack? {
        // Get the Core Data Stack
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.stack
    }
    
    private func fetchResultsFromCoreData(fetchResultsCompletionHandler completionHandler: (error : NSError?) -> Void) {
        // Create a fetch request
        if let homeScreenOptionType = self.homeScreenOptionType {
            if let homeScreenOptionEntityName = AppSharedData.sharedInstance.homeScreenOptionsEntityNames[homeScreenOptionType] {
                let fetchRequest = NSFetchRequest(entityName: homeScreenOptionEntityName)
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastupdated", ascending: false)]
                
                if let coreDataStack = getCoreDataStack() {
                    fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
                    completionHandler(error: nil)
                } else {
                    let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("An error happened while fetching results from CoreData.", comment: "")]
                    let error = NSError(domain: "LifeImporterErrorDomain", code: -57, userInfo: userInfo)
                    completionHandler(error: error)
                }
            }
        }
    }
    
    // MARK: - UISerchBar delegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterSearchResults(searchText)
        searchResultsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        filterSearchResults(searchBar.text)
        searchResultsTableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Search methods
    private func filterSearchResults(inputSearchText : String?) {
        if let searchText = inputSearchText {
            if self.homeScreenOptionType == .Food {
                filteredSearchResults = fetchedResultsController?.fetchedObjects?.filter({ (food : AnyObject) -> Bool in
                    let _food = food as? Food
                    return _food?.title?.containsString(searchText) == true
                })
            } else if self.homeScreenOptionType == .Exercise {
                filteredSearchResults = fetchedResultsController?.fetchedObjects?.filter({ (exercise : AnyObject) -> Bool in
                    let _exercise = exercise as? Exercise
                    return _exercise?.title?.containsString(searchText) == true
                })
            } else if self.homeScreenOptionType == .Category {
                filteredSearchResults = fetchedResultsController?.fetchedObjects?.filter({ (category : AnyObject) -> Bool in
                    let _category = category as? Category
                    return _category?.category?.containsString(searchText) == true
                })
            }
        }
    }
    
    // MARK: - Search Results Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchResults = filteredSearchResults {
            return searchResults.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultsTableViewCell", forIndexPath: indexPath) as! SearchResultsTableViewCell
        if self.homeScreenOptionType == .Food {
            if let searchResult = filteredSearchResults?[indexPath.row] as? Food {
                cell.searchResultTitleLabel.text = searchResult.title
                cell.searchResultDetailsLabel.text = String(searchResult.calories) + " cal"
            }
        } else if self.homeScreenOptionType == .Exercise {
            if let searchResult = filteredSearchResults?[indexPath.row] as? Exercise {
                cell.searchResultTitleLabel.text = searchResult.title
                cell.searchResultDetailsLabel.text = String(searchResult.calories) + " cal"
            }
        } else if self.homeScreenOptionType == .Category {
            if let searchResult = filteredSearchResults?[indexPath.row] as? Category {
                cell.searchResultTitleLabel.text = searchResult.category
                cell.searchResultDetailsLabel.text = "id: " + String(searchResult.headcategoryid)
            }
        }
        return cell
    }
    
    // MARK: - Search Results Table view delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AppSharedData.sharedInstance.heightForTableViewRow
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
