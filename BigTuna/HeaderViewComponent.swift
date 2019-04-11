//
//  HeaderViewComponent.swift
//  BigTuna
//
//  Created by William Wong on 4/10/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    private var displayName: UILabel!;
    private var bottomBorder = CALayer();
    
    convenience init() {
        self.init(frame: CGRect());
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupView();
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding");
    }
    
    private func setupView() {
        displayName = UILabel();
        displayName.textColor = .gray;
        displayName.font = displayName.font.withSize(24); //TODO constants
        displayName.sizeToFit();
        addSubview(displayName);
        
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor;
        layer.addSublayer(bottomBorder);
    }
    
    func setUsername(userName: String) {
        displayName.text = userName;
    }
    
    func applyViewProperties(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false;
        heightAnchor.constraint(equalToConstant: 75).isActive = true;
        leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        displayName.translatesAutoresizingMaskIntoConstraints = false;
        displayName.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true;
        displayName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        bottomBorder.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: 1);
    }
}
