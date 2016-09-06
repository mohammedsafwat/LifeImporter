//
//  SearchResultsTableViewCell.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/6/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var searchResultTitleLabel: UILabel!
    @IBOutlet weak var searchResultDetailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
