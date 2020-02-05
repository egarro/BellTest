//
//  PlayerHeaderView.swift
//  BellTest
//
//  Created by Esteban on 2020-02-02.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class PlayerHeaderView: UIView {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var songIcon: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var dismissClosure: VoidClosure?
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented for PlayerHeaderView")
    }
    
    convenience init(dismissClosure: @escaping VoidClosure) {
        self.init(frame: .zero)
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        addSubview(containerView)

        self.dismissClosure = dismissClosure
        
        configureUI()
    }
    
    private func configureUI() {
        dismissButton.setImage(UIImage(named: "downArrow"), for: .normal)
        dismissButton.setTitle("", for: .normal)
        
        songNameLabel.text = "Some Song"
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @IBAction func dismissListDetail(_ sender: Any) {
        dismissClosure?()
    }
    
    func setSongName(_ string: String) {
        songNameLabel.text = string
    }
}

