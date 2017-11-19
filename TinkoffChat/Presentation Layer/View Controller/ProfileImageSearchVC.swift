//
//  ProfileImageSearchVC.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 11/19/17.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import UIKit

protocol ImageSearchVCDelegate : class {
    func didPick(image: UIImage)
}

class ProfileImageSearchVC: UIViewController {
    
    // MARK: - Delegate
    weak var delegate: ImageSearchVCDelegate?
    
    // MARK: - Properties
    let requestSender: IRequestSender = RequestSender(async: true)
    private var requestPage = 1
    var imageUrls: [Int:URL] = [:] // URL for indexPath.row
    var images: [Int:UIImage] = [:] // UIImage for indexPath.row
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - internal
    var typedKeywords: [String] {
        guard let text = searchBar.text else { return [] }
        return text.split(separator: " ").map(String.init)
    }
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        searchBar.delegate = self
    }
    
    // MARK: - Download List of Image Infos
    func downloadImagesInfo() {
        // check if text changed -> should do new request
        if imageUrls.isEmpty {
            requestPage = 1
        }
        let config = RequestsFactory.PixabayRequests.imageInfosConfig(keywords: typedKeywords, page: requestPage)
        requestSender.send(config: config) { [weak self] (result) in
            switch result {
            case .success(let imageInfos):
                guard let strongSelf = self else { return }
                let offset = strongSelf.imageUrls.count
                for (index,imageInfo) in imageInfos.enumerated() {
                    strongSelf.imageUrls[index + offset] = imageInfo.imageUrl // pagination is considered
                }
                DispatchQueue.main.sync {
                    strongSelf.collectionView.reloadData()
                }
                strongSelf.requestPage += 1
            case .error(let description):
                print(description)
            }
        }
    }
    
    // MARK: - Download image -> UIImage
    func downloadImage(indexPathRow row: Int) {
        guard let url = imageUrls[row] else { return }
        let imageConfig = RequestsFactory.PixabayRequests.imagesConfig(url: url)
        requestSender.send(config: imageConfig, completionHandler: { [weak self] (result) in
            switch result {
            case .success(let image):
                self?.images[row] = image.image
                DispatchQueue.main.async {
                    // assuming there is only one section in collection view
                    self?.collectionView.reloadItems(at: [IndexPath.init(row: row, section: 0)])
                }
            case .error(let description):
                print(description)
            }
        })
    }

}

// MARK: - UICollectionViewDataSource
extension ProfileImageSearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "internetImageCell", for: indexPath) as! ImageCollectionViewCell
        
        if let image = images[indexPath.row] {
            cell.imageView.image = image
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "placeholder-user")
            downloadImage(indexPathRow: indexPath.row)
        }
        
        // download more if scrolled down to bottom
        if indexPath.row == imageUrls.count - 1 {
            downloadImagesInfo()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: - Clear UICollectionView for new query
    func clearCollectionView() {
        imageUrls.removeAll()
        images.removeAll()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileImageSearchVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        if let image = cell.imageView.image {
            delegate?.didPick(image: image)
            dismiss(animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileImageSearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3.0
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


// MARK: - UISearchBarDelegate
extension ProfileImageSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        clearCollectionView()
        downloadImagesInfo()
        
        searchBar.resignFirstResponder()
    }
}
