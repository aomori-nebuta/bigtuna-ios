//
//  CameraViewController.swift
//  BigTuna
//
//  Created by Christine Tsou on 2/9/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit
import AVFoundation

enum CameraOptions {
    case Camera
    case CameraRoll
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var navItems: UINavigationItem!
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var cameraSelection: CameraOptions!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        imagePicker.delegate = self
        // Default camera source is photo library
        // Only need to change source when use camera is selected
        if (cameraSelection == CameraOptions.Camera) {
            self.imagePicker.sourceType = .camera
        }
        
        self.view.addSubview(imagePicker.view)
        self.addChild(imagePicker)
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.notDetermined {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (videoGranted: Bool) -> Void in
                // User denied camera permission
                if (!videoGranted) {
                    self.imagePicker.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        // check if an image was selected,
        // images are not the only media type that can be selected
        if let img = info[.originalImage] as? UIImage {
            self.displayImage.image = img
            self.navItems.leftBarButtonItem?.action = #selector(closeView(sender:))
            picker.view.removeFromSuperview()
            picker.removeFromParent()
            return
        }
        
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeView(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

class ScaledHeightImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
}
