//
//  CategoryCell.swift
//  BigTuna

//
//  Created by James Wu on 3/23/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit

class CategoryHeader: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let data = ["data1", "data2", "data3", "data4", "data5", "data6", "data7", "data8"]
    
    private let widthMultiplier = CGFloat(0.15)
    private let heightMultplier = CGFloat(0.6)
    
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
        label.text = "Discover Near "
        return label
    }()
    
    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.alwaysBounceVertical = false
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func setupViews() {
        addSubview(discoverLabel)
        addSubview(categoryCollectionView)
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self

        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCellIdentifier)
        
        categoryCollectionView.topAnchor.constraint(equalTo: discoverLabel.bottomAnchor).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": categoryCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-[v1]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": discoverLabel, "v1": categoryCollectionView]))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    // Conforms to protocol UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryCell
        cell.updateConstraints()
        cell.categoryLabel.text = data[indexPath.row]
        cell.categoryImageView.image = UIImage(named: "SurprisedPikachu")
        cell.categoryImageView.setRounded()
        return cell
    }

    // Conforms to protocol UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * widthMultiplier
        let height = collectionView.frame.height * heightMultplier
        return CGSize(width: width, height: height)
    }
    
    func reloadHeader() {
        // Based on https://stackoverflow.com/a/13611230
        categoryCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
    }

}

class CategoryCell: UICollectionViewCell {
    
    private let multiplier = CGFloat(0.75)
    
    var categoryImageViewWidthConstraintToHeight: NSLayoutConstraint?
    var categoryImageViewHeightConstraintToHeight: NSLayoutConstraint?
    
    var categoryImageViewWidthConstraintToWidth: NSLayoutConstraint?
    var categoryImageViewHeightConstraintToWidth: NSLayoutConstraint?
    
    var categoryImageViewTopConstraint: NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Required init not implemented for PostCell!")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        setupViews()
    }
    
    let categoryImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(categoryImageView)
        addSubview(categoryLabel)

        categoryImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        categoryImageViewWidthConstraintToHeight = categoryImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier)
        categoryImageViewHeightConstraintToHeight = categoryImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier)
        
        categoryImageViewWidthConstraintToWidth = categoryImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier)
        categoryImageViewHeightConstraintToWidth = categoryImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier)
        
        categoryImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo:categoryImageView.bottomAnchor).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        categoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    }
    
    /**
     Updates constraints to use screen orientation's frame anchors.
     
     In order to achieve a circular image to display in the cell, the width and height must be set to the same value.
     Furthermore, when the screen orientation changes it is necessary to update constraints so that they conform to
     the new orientation's frame.
     
     After the screen changes:
        - If the width is greater than the height, then use the cell's height anchor to keep the image within bounds.
        - Otherwise, use the cell's width anchor to keep the image within bounds
     */
    override func updateConstraints() {
        let width = frame.width * multiplier
        let height = frame.height * multiplier
        
        if (width > height) {
            categoryImageView.frame.size.width = height
            categoryImageView.frame.size.height = height
            categoryImageViewHeightConstraintToHeight?.isActive = true
            categoryImageViewWidthConstraintToHeight?.isActive = true
            categoryImageViewHeightConstraintToWidth?.isActive = false
            categoryImageViewWidthConstraintToWidth?.isActive = false
        } else {
            categoryImageView.frame.size.width = width
            categoryImageView.frame.size.height = width
            categoryImageViewHeightConstraintToHeight?.isActive = false
            categoryImageViewWidthConstraintToHeight?.isActive = false
            categoryImageViewHeightConstraintToWidth?.isActive = true
            categoryImageViewWidthConstraintToWidth?.isActive = true
        }

        super.updateConstraints()

    }
    
}

// Based on https://stackoverflow.com/a/37259630
extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}

