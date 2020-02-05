//
//  LoadingCellView.swift
//  BellTest
//
//  Created by Esteban on 2020-02-05.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class LoadingCellView: UITableViewCell {
    var indicator = UIActivityIndicatorView(style: .medium)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureIndicator()
        contentView.backgroundColor = .black
    }
    
    private func configureIndicator() {
        indicator.color = .white
        contentView.addSubview(indicator)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        indicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented for LoadingCellView")
    }
}
