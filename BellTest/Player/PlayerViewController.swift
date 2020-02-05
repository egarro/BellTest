//
//  PlayerViewController.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper

struct PlayerViewControllerConfig {
    let shouldHidePlaylistControls: Bool
    let videoID: String
}

class PlayerViewController: UIViewController {
    var eventHandler: PlayerEventHandler?

    var playerView: YTPlayerView!
    var controlsView: PlayerControlsView!
    var dismissButton = UIButton(type: .custom)
    
    var config: PlayerViewControllerConfig
    
    init(config:PlayerViewControllerConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented for PlayerViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureButton()
        configurePlayer()
        configureControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let playerVars = ["playsinline" : 1,
                          "autoplay" : 1,
                          "controls" : 0]
        playerView.load(withVideoId: config.videoID, playerVars:playerVars)
    }
    
    func play(_ videoId: String) {
        playerView.cueVideo(byId: videoId, startSeconds: 0.0, suggestedQuality: .auto)
        playerView.playVideo()
    }
    
    func configureUI() {
        view.backgroundColor = .black
        dismissButton.setImage(UIImage(named: "downArrow"), for: .normal)
        dismissButton.setTitle("", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissPlayer), for: .touchUpInside)
        
        controlsView = PlayerControlsView(nextClosure: { [weak self] in self?.eventHandler?.didTapOnNext() },
                                          previousClosure:  { [weak self] in self?.eventHandler?.didTapOnPrevious() },
                                          playClosure: { [weak self] (isPlaying) in
                                                if isPlaying {
                                                    self?.playerView.playVideo()
                                                } else {
                                                    self?.playerView.stopVideo()
                                                }
                                          })
        playerView = YTPlayerView()

        view.addSubview(dismissButton)
        view.addSubview(playerView)
        view.addSubview(controlsView)
    }
    
    func configureButton() {
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 42.0).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 42.0).isActive = true
    }
    
    func configurePlayer() {
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor).isActive = true
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        playerView.delegate = self
    }
    
    func configureControls() {
        if config.shouldHidePlaylistControls {
            controlsView.hidePlaylistControls()
        }
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        controlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        controlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        controlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        controlsView.topAnchor.constraint(equalTo: playerView.bottomAnchor).isActive = true
    }
            
    func hidePlaylistButtons() {
        controlsView.hidePlaylistControls()
    }
    
    @objc func dismissPlayer() {
        eventHandler?.didTapOnDismiss()
    }
}

extension PlayerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .playing:
            controlsView.isPlaying = true
        default:
            controlsView.isPlaying = false
        }
    }
}
