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
        addSubview(categoryCollectionView)
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self

        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCellIdentifier)
        
        categoryCollectionView.topAnchor.constraint(equalTo: discoverLabel.bottomAnchor).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": categoryCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-[v1]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": discoverLabel, "v1": categoryCollectionView]))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let topInset = (collectionView.frame.height * 0.2)

        return UIEdgeInsets(top: topInset, left: 14, bottom: 0, right: 14)
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
        let width = collectionView.frame.width * 0.15
        let height = collectionView.frame.height * (0.6)

        return CGSize(width: width, height: height)
    }

}

class CategoryCell: UICollectionViewCell {
    
    var categoryImageViewWidthConstraintToHeight: NSLayoutConstraint?
    var categoryImageViewHeightConstraintToHeight: NSLayoutConstraint?
    
    var categoryImageViewWidthConstraintToWidth: NSLayoutConstraint?
    var categoryImageViewHeightConstraintToWidth: NSLayoutConstraint?
    
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

        categoryImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true

        categoryImageViewWidthConstraintToHeight = categoryImageView.widthAnchor.constraint(equalTo: heightAnchor)
        categoryImageViewHeightConstraintToHeight = categoryImageView.heightAnchor.constraint(equalTo: heightAnchor)
        
        categoryImageViewWidthConstraintToWidth = categoryImageView.widthAnchor.constraint(equalTo: widthAnchor)
        categoryImageViewHeightConstraintToWidth = categoryImageView.heightAnchor.constraint(equalTo: widthAnchor)
    }
    
    override func updateConstraints() {
        super.updateConstraints()

        let width = frame.width * 0.5
        let height = frame.height * 0.5
        
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
    }
    
}

// Based on https://stackoverflow.com/a/37259630
extension UIImageView {
    func setRounded() {
        print("WIDTH AFTER: \(self.frame.size.width)")
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}

