//
//  MainTabBarController.swift
//  BigTuna
//
//  Created by James Wu on 1/6/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var discoverViewController: UIViewController!
    var cameraViewController: UIViewController!
    var profileViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.instantiateTabViewControllers()
    }
    
    func instantiateTabViewControllers() {
        discoverViewController = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController")
        cameraViewController = storyboard?.instantiateViewController(withIdentifier: "CameraViewController")
        profileViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
    }
    
    func displayCameraActionSheet() {
        let cameraOptionMenu = UIAlertController(title: "Upload Image From", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in self.cameraActionHandler() })
        let cameraRollAction = UIAlertAction(title: "Camera Roll", style: .default, handler: { action in self.cameraRollActionHandler() })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        cameraOptionMenu.addAction(cameraAction)
        cameraOptionMenu.addAction(cameraRollAction)
        cameraOptionMenu.addAction(cancelAction)
        
        self.present(cameraOptionMenu, animated: true, completion: nil)
    }
    
    func cameraActionHandler() {
        print("Camera Pressed!")
    }
    
    func cameraRollActionHandler() {
        print("Camera Roll Pressed!")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool
    {
        // Camera tab pressed
        if viewController.isKind(of: CameraViewController.self) {
            self.displayCameraActionSheet()
            return false
        }
        
        return true
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
