//
//  DiscoverViewController.swift
//  BigTuna
//
//  Created by Christine Tsou on 2/9/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit

class DiscoverViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let postCellIdentifier = "PostCell"
    private let categoryHeaderIdentifier = "CategoryHeader"
    private let footerCellIdentifier = "FooterCell"

    private let estimatedWidth = 160.0
    private let cellMarginSize = 16.0
    
    let data = ["one", "two", "three", "four", "five"]
    
    // Reference to the category header
    var categoryHeader: CategoryHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Discover Page"
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .green
        
        collectionView.dataSource = self

        collectionView.register(PostCell.self, forCellWithReuseIdentifier: postCellIdentifier)
        collectionView.register(CategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: categoryHeaderIdentifier)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerCellIdentifier)
        
        setupGridView()
    }
    
    func setupGridView() {
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionHeadersPinToVisibleBounds = true
        flow.minimumInteritemSpacing = CGFloat(cellMarginSize)
        flow.minimumLineSpacing = CGFloat(cellMarginSize)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellIdentifier, for: indexPath) as! PostCell
        cell.setData(text: data[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: categoryHeaderIdentifier, for: indexPath) as! CategoryHeader
            categoryHeader = header
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerCellIdentifier, for: indexPath)
            return footer
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Wait for screen orientation change to finish, then reload the header with the new frame bounds
        coordinator.animate(alongsideTransition: nil) { _ in
            self.categoryHeader?.reloadHeader()
        }
    }
    
    // Implements UICollectionViewDelegateFlowLayout protocol
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateWidth()
        return CGSize(width: width, height: width)
    }
    
    // Implements UICollectionViewDelegateFlowLayout protocol
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    // Implements UICollectionViewDelegateFlowLayout protocol
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width * 0.3, height: view.frame.size.height * 0.25)
    }
    
    /**
     Dynamically calculate the width of each Post cell.
     
     - returns:
        A CGFloat of the needed width per CollectionView cell.
     
     Determines width of individual cells needed to fill each row, based on an estimate of the cell width and the number of cells that
     can fit per row.
     */
    func calculateWidth() -> CGFloat {
        // Based on https://www.youtube.com/watch?v=FMqX628vE1c
        let estimateWidth = CGFloat(estimatedWidth)
        let cellCount = floor(CGFloat(view.frame.size.width / estimateWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (view.frame.size.width - (CGFloat(cellMarginSize) * (cellCount - 1)) - margin) / cellCount

        return width
    }

}
