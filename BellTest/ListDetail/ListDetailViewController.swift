//
//  ListDetailViewController.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

struct ListDetailViewControllerConfig {
    let playlist: Playlist
    let info: PlaylistInfo
}

class ListDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var items: [Item] = []
    
    var eventHandler: ListDetailEventHandler?
    
    var headerView: ListHeaderView!
    var tableView = UITableView()
    
    var config: ListDetailViewControllerConfig
    
    init(config: ListDetailViewControllerConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = config.playlist.items
        
        configureUI()
        configureTableView()
        configureHeader()
    }

    func configureUI() {
        view.backgroundColor = .black
        headerView = ListHeaderView(info: config.info,
                                    dismissClosure: { [weak self] in self?.eventHandler?.didTapOnBack() },
                                    playClosure:    { [weak self] in
                                        //Implement this for shuffle-like start:
                                        let randomID = self?.items.first?.videoId ?? ""
                                        self?.eventHandler?.didTapOnPlay(for: randomID)
                                    })
        
        view.addSubview(tableView)
        view.addSubview(headerView)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ItemCellView", bundle: nil), forCellReuseIdentifier: videoCellID)
        tableView.showsVerticalScrollIndicator = true
        tableView.indicatorStyle = .white
        tableView.backgroundColor = .black
        tableView.alwaysBounceHorizontal = false
        tableView.isDirectionalLockEnabled = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func configureHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
    }

// MARK: UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: videoCellID, for: indexPath) as! ItemCellView
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        let item = items[indexPath.row]
        cell.itemNameLabel.text = item.title
        cell.authorLabel.text = item.author
        cell.durationLabel.text = item.duration
        cell.itemIcon.downloaded(from: item.iconURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        tableView.deselectRow(at: indexPath, animated: false)
        
        let videoID = items[indexPath.item].videoId
        eventHandler?.didTapOnPlay(for: videoID)
    }
}

