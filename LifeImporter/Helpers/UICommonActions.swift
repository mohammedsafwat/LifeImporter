//
//  UICommonActions.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/6/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit

class UICommonActions: NSObject {
    static let sharedInstance = UICommonActions()
    
    func showAlertView(title : String?, message : String?, navigationController : UINavigationController?) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction : UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertViewController.addAction(cancelAction)
        navigationController?.presentViewController(alertViewController, animated: true, completion: nil)
    }
}
