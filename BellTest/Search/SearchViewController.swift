//
//  SearchViewController.swift
//  BellTest
//
//  Created by Esteban on 2020-02-04.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

let videoCellID = "playlistCellID"
let loadingCellID = "playlistLoadingCellID"

class SearchViewController: UITableViewController, UISearchResultsUpdating {
    var videos: [Video] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var eventHandler: SearchEventHandler?
        
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    private var fetchingResults: Bool = false
    private var nextPageToken: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureTableView()
    }
    
    public func update(videos: [Video], nextPage:String) {
        self.fetchingResults = false
        self.nextPageToken = nextPage
        self.videos += videos
        self.tableView.reloadData()
    }
    
    private func configureSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Videos"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
    
    private func configureTableView() {
        tableView.register(LoadingCellView.self, forCellReuseIdentifier: loadingCellID)
        tableView.register(UINib(nibName: "ItemCellView", bundle: nil), forCellReuseIdentifier: videoCellID)
        tableView.showsVerticalScrollIndicator = true
        tableView.indicatorStyle = .white
        tableView.backgroundColor = .black
        tableView.alwaysBounceHorizontal = false
        tableView.isDirectionalLockEnabled = true
    }
        
    @objc func didTapOnBack() {
        eventHandler?.didTapOnBack()
    }
    
    @objc func didTapOnPlay(for videoID:String) {
        eventHandler?.didTapOnPlay(for: videoID)
    }
    
// MARK: UITableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int  {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return videos.count
        } else if section == 1 && fetchingResults {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: loadingCellID, for: indexPath) as! LoadingCellView
            loadingCell.indicator.startAnimating()
            return loadingCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: videoCellID, for: indexPath) as! ItemCellView
        
        let video = videos[indexPath.row]
        
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        cell.itemNameLabel.text = video.description
        cell.authorLabel.text = video.author
        cell.durationLabel.text = video.duration
        cell.itemIcon.downloaded(from: video.iconURL)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let video = self.videos[indexPath.row]
        
        if searchController.isActive {
            searchController.searchBar.text = ""
            self.searchController.dismiss(animated: false) { [weak self] in
                guard let `self` = self else { return }
                self.eventHandler?.didTapOnPlay(for: video.videoId)
            }
        } else {
            eventHandler?.didTapOnPlay(for: video.videoId)
        }
    }

// MARK: Inifinte scrolling support using pagination
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > ( contentHeight - scrollView.frame.height ) && !fetchingResults {
            sendFetchRequest()
        }
    }
    
    private func sendFetchRequest() {
        guard let query = searchController.searchBar.text else {
            fetchingResults = false
            return
        }
        fetchingResults = true
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        eventHandler?.didUpdateSearchTerm(query: query, pageToken: nextPageToken)
    }
    
// MARK: UISearchResultsUpdating Methods
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, query.count > 3 else {
            fetchingResults = false
            return
        }
                
        fetchingResults = true
        self.videos = []
        eventHandler?.didUpdateSearchTerm(query: query, pageToken: "")
    }
}
