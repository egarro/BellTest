//
//  ListsViewController.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit

struct ListsViewControllerConfig {
    let user: User
}

class ListsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let playlistCellID = "playlistCellID"
    let desiredIconSpacing: CGFloat = 50.0
    
    let config: ListsViewControllerConfig
    var eventHandler: ListsEventHandler?
    
    var logoutButton = UIButton(type: .roundedRect)
    var searchButton = UIButton(type: .custom)
    var titleLabel = UILabel(frame: .zero)
    
    var data:[PlaylistInfo] = []
    private var currentFetchingIndex: IndexPath? = nil
    
    init(config: ListsViewControllerConfig) {
        self.config = config
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureButtons()
        configureCollectionView()
        configureLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventHandler?.requestAllPlaylists()
    }
    
    public func update(with playlists:Playlists) {
        self.data = playlists.lists
        self.collectionView.reloadData()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
    }
    
    private func configureButtons() {
        view.addSubview(logoutButton)
        view.addSubview(searchButton)
        
        logoutButton.addTarget(self, action: #selector(didTapOnLogout), for: .touchUpInside)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .clear
        logoutButton.setTitleColor(.white, for: .normal)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
                
        searchButton.addTarget(self, action: #selector(didTapOnSearch), for: .touchUpInside)
        searchButton.setImage(UIImage(named: "magnifier"), for: .normal)
        searchButton.backgroundColor = .clear
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.register(UINib(nibName: "ListCellView", bundle: nil), forCellWithReuseIdentifier: playlistCellID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 50, bottom: 0, right: 50)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120.0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50.0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
    }

    private func configureLabel() {
        view.addSubview(titleLabel)
        titleLabel.text = "\(config.user.name)'s Playlists"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: logoutButton.bottomAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
    }
    
    @objc func didTapOnLogout() {
        eventHandler?.didTapOnLogout()
    }

    @objc func didTapOnSearch() {
        eventHandler?.didTapOnSearch()
    }
    
    func stopFetchingResults() {
        guard let indexPath = currentFetchingIndex else { return }
        currentFetchingIndex = nil
        let cell = collectionView.cellForItem(at: indexPath) as! ListCellView
        cell.indicator.stopAnimating()
    }
    
// MARK: Collection View

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard currentFetchingIndex == nil else { return }
        
        currentFetchingIndex = indexPath
        let cell = collectionView.cellForItem(at: indexPath) as! ListCellView
        cell.indicator.startAnimating()
        eventHandler?.didTapOnDisplayDetail(playListInfo: data[indexPath.item])
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playlistCellID, for: indexPath) as! ListCellView
        cell.listNameLabel.text = data[indexPath.item].title
        cell.numberOfSongsLabel.text = "\(data[indexPath.item].numberOfItems)"
        cell.listIcon.downloaded(from: data[indexPath.item].iconURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        let totalSpace = collectionView.contentInset.left +
                         collectionView.contentInset.right +
                         (desiredIconSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return desiredIconSpacing
    }
}

