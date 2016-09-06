//
//  CoreDataViewController.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/6/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit
import CoreData

class CoreDataViewController: UIViewController {
    var tableView : UITableView?
    
    // MARK: - Properties
    var fetchedResultsController : NSFetchedResultsController? {
        didSet {
            fetchedResultsController?.delegate = self
            executeSearch()
            tableView?.reloadData()
        }
    }
    
    init(fetchedResultsController fc : NSFetchedResultsController){
        fetchedResultsController = fc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// MARK: - Fetches
extension CoreDataViewController {
    func executeSearch() {
        if let frc = fetchedResultsController {
            do {
                try frc.performFetch()
            } catch let error as NSError {
                print("An error happened while trying to perform a search: \n\(error)\n\(fetchedResultsController)")
            }
        }
    }
}

// MARK: - Delegates
extension CoreDataViewController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView?.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        let set = NSIndexSet(index: sectionIndex)
        
        switch type {
        case .Insert:
            tableView?.insertSections(set, withRowAnimation: .Fade)

        default:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView?.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            tableView?.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        default:
            tableView?.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView?.endUpdates()
    }
}
