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
    
    var imagePicker : UIImagePickerController = UIImagePickerController()

    init(cameraSelection: CameraOptions) {
        super.init(nibName: nil, bundle: nil)
        
        imagePicker.delegate = self
        if (cameraSelection == CameraOptions.Camera) {
            self.imagePicker.sourceType = .camera
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(imagePicker.view)
        self.addChild(imagePicker)
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.notDetermined {
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (videoGranted: Bool) -> Void in
                
                // User clicked ok
                if (videoGranted) {
                    
                    // User clicked don't allow
                } else {
                    self.imagePicker.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        // check if an image was selected,
        // since a images are not the only media type that can be selected
        if let img = info[.originalImage] {
            methodToPassImageToViewController(img)
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
