

//
//  AlbumsVC.swift
//  VaultApp
//
//  Created by Rabia Abdioğlu on 4.04.2024.
//

import Foundation
import UIKit
import NeonSDK

class AlbumsVC: UIViewController {
    
    // MARK: UI Variables
    var albums : [AlbumModel] = []
    
    var albumsCollectionView : AlbumCollectionView!
    var noAlbumVC = EmptyView(imageName: "file", title: "There is no albums", subtitle: "You don't have any albums yet")
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAlbums()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .styledBlue
        
        fetchAlbums()
        setupCollectionView()
        setupUI()
        
        
        if albums.count == 0 {
            albumsCollectionView!.isHidden = true
            
        } else {
            noAlbumVC.isHidden = true
            
        }
    }
    
    
    // MARK: - UI SETUP
    
    func setupUI() {
        // Navigation View
        let navigationView = NavigationView(leftImageName: "leftArrow", title: "Albums", rightImageName: "plus")
        view.addSubview(navigationView)
        navigationView.leftButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        navigationView.rightButton.addTarget(self, action: #selector(addNewAlbum), for: .touchUpInside)
        navigationView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(40)
        }
        // BackGround
        let backgroundView = UIView()
        backgroundView.backgroundColor = .styledWhite1
        backgroundView.layer.cornerRadius = 30
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.86)
            make.width.equalToSuperview()
            make.top.equalTo(navigationView.snp.bottom).offset(10)
        }
        
        
        // if there is no album
        
        view.addSubview(noAlbumVC)
        noAlbumVC.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100)
            
        }
        // Album Collection View
        
        view.addSubview(albumsCollectionView!)
        albumsCollectionView!.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).offset(35)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.centerX.equalToSuperview()
            
            
        }
        
        
        
    }
    
    // Setup Collection view
    func setupCollectionView(){
        albumsCollectionView = AlbumCollectionView(albums: albums)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchAlbums), for: .valueChanged)
        albumsCollectionView!.refreshControl = refreshControl
        
        // Did select
        albumsCollectionView!.didSelect = { [self] object, indexPath in
            let selectedAlbumVC = SelectedAlbumVC()
            selectedAlbumVC.selectedAlbum = object
            self.present(destinationVC: selectedAlbumVC, slideDirection: .right)
            
        }
        albumsCollectionView!.contextMenuActions = [
        
            ContextMenuAction<AlbumModel>(title: "Delete", imageSystemName : "trash", isDestructive: true){ [self] album, indexPath in
                
                FirebaseService.shared.deleteAlbum(album: album) { [self] error in
                    if error != nil {
                        // Error
                        getAlert(title: "Error", message: "An error occurred while deleting  \(album.albumName) album")
                        
                    } else {
                        fetchAlbums()
                        // Koleksiyon görünümünü yeniden yükle
                        if let index = self.albums.firstIndex(where: { $0.id == album.id }) {
                                    self.albums.remove(at: index)
                                }
                         
                        refreshAlbums()
                                   
                        getAlert(title: "Success", message: "Album deleted successfully.")

                     
                    }
                }
                

                
            }
        ]
    }
    // MARK: OBJC Functions

    @objc func addNewAlbum() {
        let selectedAlbumVC = SelectedAlbumVC()
        self.present(destinationVC: selectedAlbumVC, slideDirection: .right)
        
    }
    // Refresh func
    @objc func refreshAlbums() {
        albumsCollectionView!.refreshControl?.beginRefreshing()

            albumsCollectionView.objects = albums
            albumsCollectionView.reloadData()
            albumsCollectionView?.isHidden = albums.isEmpty
            noAlbumVC.isHidden = !albums.isEmpty
    
        albumsCollectionView!.refreshControl?.endRefreshing()
  
    }

    
    // MARK:  Functions

    @objc func fetchAlbums() {
        FirebaseService.shared.fetchAlbums { albums in
            if let albums = albums {
              
                DispatchQueue.main.async {
                    self.albums = albums
                    self.refreshAlbums()
                }
            } else {
                self.getAlert(title: "Error", message: "Error: Failed to fetch albums")
                self.goBack()
            }
        }

    }

    
    func getAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    
    
}

// MARK: Collection View Override

class AlbumCollectionView : NeonCollectionView<AlbumModel , CollectionViewAlbumCell> {
    
    convenience init(albums: [AlbumModel]) {
        self.init(
            objects: albums,
            itemsPerRow: 3,
            leftPadding: 10,
            rightPadding: 10,
            horizontalItemSpacing: 1,
            verticalItemSpacing: 3
        )
        self.backgroundColor = .clear
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewAlbumCell.identifier, for: indexPath) as! CollectionViewAlbumCell
        let album = objects[indexPath.item]
        cell.configure(with: album)
        return cell
    }
    override   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = collectionView.frame.size.width / 3.3
        return CGSize(width: size, height: size * 1.5 )
        
    }
    
}


