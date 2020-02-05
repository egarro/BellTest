//
//  ListHeaderView.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class ListHeaderView: UIView {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var playlistIcon: UIImageView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var playAllButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    var info: PlaylistInfo!
    var dismissClosure: VoidClosure?
    var playClosure: VoidClosure?
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented for ListHeaderView")
    }
    
    convenience init(info: PlaylistInfo, dismissClosure: @escaping VoidClosure, playClosure: @escaping VoidClosure) {
        self.init(frame: .zero)
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        addSubview(containerView)

        self.info = info
        self.dismissClosure = dismissClosure
        self.playClosure = playClosure
        
        configureUI()
    }
    
    private func configureUI() {
        dismissButton.setImage(UIImage(named: "downArrow"), for: .normal)
        dismissButton.setTitle("", for: .normal)
        
        playAllButton.layer.cornerRadius = 10
        playAllButton.layer.borderWidth = 2.0
        playAllButton.layer.borderColor = UIColor.white.cgColor
        
        playlistNameLabel.text = "\(info.title) (\(info.numberOfItems) items)"
        playlistIcon.downloaded(from: info.iconURL)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @IBAction func dismissListDetail(_ sender: Any) {
        dismissClosure?()
    }
    
    @IBAction func play(_ sender: Any) {
        playClosure?()
    }
}

