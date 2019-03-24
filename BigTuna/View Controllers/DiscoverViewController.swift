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
    
    let data = ["one", "two", "three"]
    
    let estimatedWidth = 160.0
    let cellMarginSize = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Discover Page"
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .green
        
        collectionView.dataSource = self
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: postCellIdentifier)
        
        setupGridView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setupGridView() {
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let inset = view.frame.width * 0.035
        flow.sectionInset = UIEdgeInsets(top: inset , left: inset, bottom: inset, right: inset)
        flow.minimumInteritemSpacing = CGFloat(cellMarginSize)
        flow.minimumLineSpacing = CGFloat(cellMarginSize)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellIdentifier, for: indexPath) as! PostCell
        print(indexPath.row)
        cell.setData(text: data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = calculateWidth()
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    // Based on https://www.youtube.com/watch?v=FMqX628vE1c
    func calculateWidth() -> CGFloat {
        let estimateWidth = CGFloat(estimatedWidth)
        let cellCount = floor(CGFloat(view.frame.size.width / estimateWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (view.frame.size.width - (CGFloat(cellMarginSize) * (cellCount - 1)) - margin) / cellCount

        return width
    }

}
