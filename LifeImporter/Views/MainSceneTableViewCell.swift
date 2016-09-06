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
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor.clearColor()
        
        containerView.layer.cornerRadius = 5;
        containerView.layer.shadowOffset = CGSizeMake(-0.5, 0.5)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.borderColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0).CGColor
        mainOptionIconBackgroundImageView.layer.cornerRadius = 21;
        mainOptionIconBackgroundImageView.layer.masksToBounds = true;
        mainOptionIconBackgroundImageView.backgroundColor = UIColor(red: 242.0/255.0, green: 241.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
