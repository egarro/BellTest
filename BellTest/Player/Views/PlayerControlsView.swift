//
//  PlayerControlsView.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

class PlayerControlsView: UIView {
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    var nextClosure: VoidClosure?
    var previousClosure: VoidClosure?
    var playClosure: BoolClosure?
    
    var isPlaying: Bool {
        didSet {
            refreshPlayButton()
        }
    }
    
    required override init(frame: CGRect) {
        isPlaying = true
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented for PlayerControlsView")
    }
    
    convenience init(nextClosure: @escaping VoidClosure,
                     previousClosure: @escaping VoidClosure,
                     playClosure: @escaping BoolClosure) {
        self.init(frame: .zero)
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        addSubview(containerView)

        self.nextClosure = nextClosure
        self.previousClosure = previousClosure
        self.playClosure = playClosure
        
        configureUI()
    }
    
    private func configureUI() {
        playButton.setTitle("", for: .normal)
        refreshPlayButton()
        
        nextButton.setImage(UIImage(named: "next"), for: .normal)
        nextButton.setTitle("", for: .normal)
        
        previousButton.setImage(UIImage(named: "previous"), for: .normal)
        previousButton.setTitle("", for: .normal)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @IBAction func nextSong(_ sender: Any) {
        nextClosure?()
    }
    
    @IBAction func previousSong(_ sender: Any) {
        previousClosure?()
    }
    
    @IBAction func playSong(_ sender: Any) {
        isPlaying = !isPlaying
        playClosure?(isPlaying)
    }
    
    func hidePlaylistControls() {
        nextButton.isHidden = true
        previousButton.isHidden = true
    }
    
    private func refreshPlayButton() {
        if isPlaying {
             playButton.setImage(UIImage(named: "stop"), for: .normal)
        } else {
             playButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
}
