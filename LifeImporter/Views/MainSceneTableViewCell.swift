//
//  MainSceneTableViewCell.swift
//  LifeImporter
//
//  Created by Mohammed Safwat on 9/5/16.
//  Copyright © 2016 Mohammed Safwat. All rights reserved.
//

import UIKit

class MainSceneTableViewCell: UITableViewCell {
    @IBOutlet weak var mainOptionTitleLabel: UILabel!
    @IBOutlet weak var mainOptionIconBackgroundImageView: UIView!
    @IBOutlet weak var mainOptionIconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5;

        self.layer.shadowOffset = CGSizeMake(-1, 1)
        self.layer.shadowOpacity = 0.5
        
        mainOptionIconBackgroundImageView.layer.cornerRadius = 21;
        mainOptionIconBackgroundImageView.layer.masksToBounds = true;
        mainOptionIconBackgroundImageView.backgroundColor = UIColor(red: 242.0/255.0, green: 241.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
