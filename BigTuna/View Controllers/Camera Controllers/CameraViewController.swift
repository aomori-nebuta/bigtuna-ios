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
        if (cameraSelection == CameraOptions.Camera) {
            self.imagePicker.sourceType = .camera
        }
        
        self.view.addSubview(imagePicker.view)
        self.addChild(imagePicker)
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.notDetermined {
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (videoGranted: Bool) -> Void in
                
                // User clicked ok
                if (!videoGranted) {
                    self.imagePicker.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        // check if an image was selected,
        // since a images are not the only media type that can be selected
        if let img = info[.originalImage] as? UIImage {
            self.displayImage.image = img
            self.navItems.leftBarButtonItem?.action = #selector(closeView(sender:))
            picker.view.removeFromSuperview()
            picker.removeFromParent()
        }
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
