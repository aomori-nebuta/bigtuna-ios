//
//  ProfileViewController.swift
//  BigTuna
//
//  Created by Christine Tsou on 2/9/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {
    @IBOutlet weak var userProfileIcon: UIImageView!
    @IBOutlet weak var userUserName: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userPostCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO
        //https://www.iconfinder.com/icons/211605/contact_icon
        //profileIcon.image =
        
        //TODO, https requests only in the future
        //see https://stackoverflow.com/questions/32712155/app-transport-security-policy-requires-the-use-of-a-secure-connection-ios-9 and undo
        let userId = "5c8024aaee8a82615babe2a9"; //TODO
        let baseURL = "http://localhost:8000"; //TODO
        let userInfoUrl = baseURL + "/users/" + userId;
        let userPostsURL = userInfoUrl + "/posts";
        
        // Do any additional setup after loading the view.
        Alamofire.request(
            userInfoUrl,
            method: .get
        ).validate()
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                let JSON = data as! [String: Any];
                //TODO guard
                self.userUserName.text = (JSON["userName"] as! String);
                self.userFullName.text = (JSON["fullName"] as! String);
                self.userDescription.text = (JSON["description"] as! String);
                //let profileUri = "empty" //TODO
                //TODO location
                //let location = JSON["location"] as! [String: Any];
                
                break;
            case .failure(let error):
                print(error);
                break;
            }
        }
    
        
        Alamofire.request(
            userPostsURL,
            method: .get
        ).validate()
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                let JSON = data as! Array<[String: Any]>;
                
                for rawPostJSON in JSON {
                    let userPost = self.parseUserPost(postData: rawPostJSON);
                }
                break;
            case .failure(let error):
                print(error);
                break;
            }
        }
    }
    
    //TODO, also make a UserPost class and use it (we call it this to not confuse with other vague Post terms like http post
    func parseUserPost(postData: [String: Any]) {
        let postId = postData["_id"] as! String;
        print ("post id: ", postId);
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
