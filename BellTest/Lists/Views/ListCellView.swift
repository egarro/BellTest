//
//  ListCellView.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class ListCellView: UICollectionViewCell {
    
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var numberOfSongsLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        listIcon.image = nil
        listNameLabel.text = ""
        numberOfSongsLabel.text = ""
    }
}
