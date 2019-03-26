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
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationChanged), name: Notification.Name("UIDeviceOrientationDidChangeNotification"), object: nil)
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
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": categoryCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": categoryCollectionView]))
        categoryCollectionView.contentInset.top = frame.height/4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    // Conforms to protocol UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryCell
        cell.categoryLabel.text = data[indexPath.row]
        cell.categoryImageView.image = UIImage(named: "SurprisedPikachu")
        return cell
    }

    // Conforms to protocol UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width * 0.2, height: frame.height * 0.55)
    }
    
    @objc func deviceOrientationChanged() {
        setupViews()
        categoryCollectionView.reloadData()
    }
}

class CategoryCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("Required init not implemented for PostCell!")
    }
    
    let categoryImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let verticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.alignment = .center
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalStackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        setupViews()
    }
    
    func setupViews() {
        addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(categoryImageView)
        verticalStackView.addArrangedSubview(categoryLabel)
        
        categoryImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        categoryImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        categoryLabel.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor).isActive = true
        categoryLabel.bottomAnchor.constraint(equalTo: verticalStackView.bottomAnchor).isActive = true

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": verticalStackView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": verticalStackView]))
        
    }
}

