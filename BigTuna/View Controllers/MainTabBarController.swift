//
//  MainTabBarController.swift
//  BigTuna
//
//  Created by James Wu on 1/6/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    var selectedCameraOption: CameraOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func displayCameraActionSheet() {
        let cameraOptionMenu = UIAlertController(title: CameraActionSheetConstants.actionSheetTitle, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: CameraActionSheetConstants.cameraBtn, style: .default, handler: { action in self.goToCamera(selectedOption: CameraOptions.Camera) })
        let cameraRollAction = UIAlertAction(title: CameraActionSheetConstants.cameraRollBtn, style: .default, handler: { action in self.goToCamera(selectedOption: CameraOptions.CameraRoll) })
        
        let cancelAction = UIAlertAction(title: CameraActionSheetConstants.cancelBtn, style: .cancel)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        cameraOptionMenu.addAction(cameraAction)
        cameraOptionMenu.addAction(cameraRollAction)
        cameraOptionMenu.addAction(cancelAction)
        
        self.present(cameraOptionMenu, animated: true, completion: nil)
    }
    
    func goToCamera(selectedOption: CameraOptions) {
        guard self.hasCameraAuthorization(authType: .video) else {
            return
        }
        
        selectedCameraOption = selectedOption
        performSegue(withIdentifier: "CameraSegue", sender: self)
    }
    
    func hasCameraAuthorization(authType: AVMediaType) -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: authType)
        switch status {
        case .authorized, .notDetermined:
            return true
        default:
            showAlertForSettings()
            break
        }
        
        return false
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cameraVC = segue.destination as? CameraViewController {
            cameraVC.cameraSelection = selectedCameraOption
        }
    }
}
