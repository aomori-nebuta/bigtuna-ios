//
//  MainTabBarController.swift
//  BigTuna
//
//  Created by James Wu on 1/6/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    struct SettingsAlertConstants {
        static let alertTitle = "App does not have access to your camera. To enable access, tap settings and turn on Camera."
        static let settingsBtn = "Settings"
        static let cancelBtn = "Cancel"
    }
    
    struct CameraActionSheetConstants {
        static let actionSheetTitle = "Upload Image From"
        static let cameraBtn = "Camera"
        static let cameraRollBtn = "Camera Roll"
        static let cancelBtn = "Cancel"
    }
    
    var discoverViewController: UIViewController!
    var profileViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.instantiateTabViewControllers()
    }
    
    func instantiateTabViewControllers() {
        discoverViewController = storyboard?.instantiateViewController(withIdentifier: "DiscoverViewController")
        profileViewController = storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")
    }
    
    func displayCameraActionSheet() {
        let cameraOptionMenu = UIAlertController(title: CameraActionSheetConstants.actionSheetTitle, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: CameraActionSheetConstants.cameraBtn, style: .default, handler: { action in self.getCameraAuthorizationStatus() })
        let cameraRollAction = UIAlertAction(title: CameraActionSheetConstants.cameraRollBtn, style: .default, handler: { action in self.cameraRollActionHandler() })
        
        let cancelAction = UIAlertAction(title: CameraActionSheetConstants.cancelBtn, style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        cameraOptionMenu.addAction(cameraAction)
        cameraOptionMenu.addAction(cameraRollAction)
        cameraOptionMenu.addAction(cancelAction)
        
        self.present(cameraOptionMenu, animated: true, completion: nil)
    }
    
    func cameraRollActionHandler() {
        print("Camera Roll Pressed!")
    }
    
    func getCameraAuthorizationStatus() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized, .notDetermined:
            // Camera permission is handled in CameraViewController
            if let cameraViewController = storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController {
                cameraViewController.cameraSelection = CameraOptions.Camera
                self.present(cameraViewController, animated: true, completion: nil)
            }
        default:
            showAlertForSettings()
            break
        }
    }
    
    func showAlertForSettings() {
        let cameraUnavailableAlertController = UIAlertController (title: SettingsAlertConstants.alertTitle , message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: SettingsAlertConstants.settingsBtn, style: .destructive) { (_) -> Void in
            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: SettingsAlertConstants.cancelBtn, style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(cancelAction)
        cameraUnavailableAlertController .addAction(settingsAction)
        self.present(cameraUnavailableAlertController , animated: true, completion: nil)
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
}
