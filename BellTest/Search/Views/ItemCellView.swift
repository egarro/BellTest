//
//  ItemCellView.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class ItemCellView: UITableViewCell {
    
    @IBOutlet weak var itemIcon: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func prepareForReuse() {
        itemIcon.image = nil
        itemNameLabel.text = ""
        authorLabel.text = ""
        durationLabel.text = ""
    }
}
