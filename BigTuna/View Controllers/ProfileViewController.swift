//
//  ProfileViewController.swift
//  BigTuna
//
//  Created by Christine Tsou on 2/9/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var primaryStackView = UIStackView()
    
    var posts = Array<Post>();
    var user: User = User(userName: "", fullName: "", profilePicture: UIImage(), followers: Array<User>(), posts: Array<Post>(), description: "");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO, wrap all of this data fetching in a function
        
        //TODO
        //https://www.iconfinder.com/icons/211605/contact_icon
        //profileIcon.image =
        
        //TODO, https requests only in the future
        //see https://stackoverflow.com/questions/32712155/app-transport-security-policy-requires-the-use-of-a-secure-connection-ios-9 and undo
        let hostName = "ec2-18-217-215-145.us-east-2.compute.amazonaws.com"; //TODO
        let port = "8010"; //TODO
        let baseURL = "http://" + hostName + ":" + port; //TODO
        let userId = "5c8727ba2556d0e49c820591"; //TODO
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
                self.user.userName = (JSON["userName"] as! String);
                self.user.description = (JSON["description"] as! String);
                self.user.fullName = (JSON["fullName"] as! String);
                //TODO profileURI
                //TODO location
                //let location = JSON["location"] as! [String: Any];
                //TODO set user here; or call a function like parseUser
                
                self.displayUI();
                
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
                let JSON = data as? Array<[String: Any]> ?? [];
                
                for rawPostJSON in JSON {
                    let userPost = self.parseUserPost(postData: rawPostJSON);
                    
                    self.posts.append(userPost);
                }
                
                self.displayUI();
                
                break;
            case .failure(let error):
                print(error);
                break;
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath);
        let imageView = UIImageView.init();
        imageView.kf.setImage(with: self.posts[indexPath.item].postImageLink);
        myCell.addSubview(imageView);
        myCell.backgroundColor = UIColor.gray;
        return myCell;
    }
    
    //TODO, also make a UserPost class and use it (we call it this to not confuse with other vague Post terms like http post
    func parseUserPost(postData: [String: Any]) -> Post {
        //let postId = postData["_id"] as! String;
        let recommended = true; //TODO, is this per item or per post
        let priceRange = 5; //TODO is this per item or per post
        let menuItems = Array<String>(); //TODO, is this tied to each image??
        let tags = postData["tags"] as? [String] ?? [];
        let rating = postData["rating"] as? Int ?? 5;
        let description = postData["description"] as? String ?? "";
        let createdAtString = postData["createdAt"] as! String;
        let updatedAtString = postData["updatedAt"] as! String;
        let formatter = DateFormatter();
        formatter.locale = Locale(identifier: "en_US");
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"; //TODO set constant
        let createdAt = formatter.date(from: createdAtString);
        let updatedAt = formatter.date(from: updatedAtString);
        let images = postData["items"] as? Array<[String: Any]> ?? [];
        let previewImageURL = images[0]["imageUri"] as? String ?? "";//TODO default white when no images
        //let url = URL(string: previewImageURL + ".jpg"); //TODO get correct extension properly
        let url = URL(string: "https://d17fnq9dkz9hgj.cloudfront.net/breed-uploads/2018/09/dog-landing-hero-lg.jpg");
        let post = Post(uploader: self.user, recommended: recommended, postImageLink: url, priceRange: PriceRange(rawValue: priceRange), menuItems: menuItems, tags: tags, rating: Rating(rawValue: rating), description: description, uploadDate: createdAt, lastEdited: updatedAt); //TODO handle when created/updated are null
        
        return post;
    }
    
    func displayUI() {
        
        
        
        let userProfileIcon = UIImageView();
        let userUserName = UILabel();
        let userFullName = UILabel();
        let userDescription = UILabel();
        let userLocation = UILabel();
        let userPostCount = UILabel();
        
        userUserName.text = user.userName;
        userFullName.text = user.fullName;
        userDescription.text = user.description;
        userPostCount.text = String(self.posts.count) + " posts";
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 100, height: 100)
        
        
        let myCollectionView = UICollectionView(frame: CGRect(x: 10, y: 210, width: 300, height: 300), collectionViewLayout: layout); //todo resizable frame
        myCollectionView.dataSource = self as UICollectionViewDataSource
        myCollectionView.delegate = self as UICollectionViewDelegate
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView.backgroundColor = UIColor.white
        
        
        primaryStackView = UIStackView(arrangedSubviews: [
            userProfileIcon,
            userUserName,
            userFullName,
            userDescription,
            userLocation,
            userPostCount,
            myCollectionView
        ])
        
        view.addSubview(primaryStackView);
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
