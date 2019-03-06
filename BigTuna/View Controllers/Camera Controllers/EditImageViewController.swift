//
//  EditImageViewController.swift
//  BigTuna
//
//  Created by Christine Tsou on 3/5/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var navItems: UINavigationItem!
    //    var selectedImage: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItems.leftBarButtonItem?.action = #selector(closeView(sender:))
    }
    
    @objc func closeView(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
