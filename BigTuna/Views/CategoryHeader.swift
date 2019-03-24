//
//  CategoryCell.swift
//  BigTuna

//
//  Created by James Wu on 3/23/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit

class CategoryHeader: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    

    let data = ["data1", "data2"]
    
    private let categoryCellIdentifier = "CategoryCell"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Required init not implemented for PostCell!")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .purple
        setupViews()
    }

    let discoverLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .orange
        label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 25)
        label.text = "Discover Near "
        return label
    }()
    
    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.alwaysBounceVertical = false
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func setupViews() {
        addSubview(discoverLabel)
        
        discoverLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        discoverLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        addSubview(categoryCollectionView)
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self

        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCellIdentifier)
        
        categoryCollectionView.topAnchor.constraint(equalTo: discoverLabel.bottomAnchor).isActive = true
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": categoryCollectionView]))
        
        categoryCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
        
        let flow = categoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let inset = CGFloat(8)
        flow.sectionInset = UIEdgeInsets(top: inset , left: inset, bottom: inset, right: inset)
    }
    
    // Conforms to protocol UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryCell
        cell.label.text = data[indexPath.row]
        return cell
    }

    // Conforms to protocol UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 0.2, height: frame.height * 0.55)
    }
}

class CategoryCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("Required init not implemented for PostCell!")
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        setupViews()
    }
    
    func setupViews() {
        addSubview(label)
        
        label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
}

