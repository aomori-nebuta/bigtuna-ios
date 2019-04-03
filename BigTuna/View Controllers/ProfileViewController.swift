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
    var primaryStackView: UIStackView!;
    var collectionView: UICollectionView!;
    
    var posts = Array<Post>();
    var user: User = User(userName: "", fullName: "", profilePicture: UIImage(), followers: Array<User>(), posts: Array<Post>(), description: "");
    
    let profilePostCellIdentifer: String = "profilePostCell";
    
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
                self.view.backgroundColor = .red; //debug
                self.getUserPosts(userPostsURL: userPostsURL);
                
                break;
            case .failure(let error):
                print(error);
                break;
            }
        }
        
    }
    
    func getUserPosts(userPostsURL: String) {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 50); //TODO constants for size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: profilePostCellIdentifer, for: indexPath);
        
        let imageURL = self.posts[indexPath.item].postImageLink;
        let imageView = UIImageView();
        imageView.kf.setImage(with: imageURL);
        
        myCell.contentView.addSubview(imageView);
        
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageView.heightAnchor.constraint(equalTo: myCell.contentView.heightAnchor).isActive = true;
        imageView.widthAnchor.constraint(equalTo: myCell.contentView.widthAnchor).isActive = true;
        imageView.centerXAnchor.constraint(equalTo: myCell.contentView.centerXAnchor).isActive = true;
        imageView.centerYAnchor.constraint(equalTo: myCell.contentView.centerYAnchor).isActive = true;
        
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
        let url = URL(string: previewImageURL); //TODO get correct extension properly
        let post = Post(uploader: self.user, recommended: recommended, postImageLink: url, priceRange: PriceRange(rawValue: priceRange), menuItems: menuItems, tags: tags, rating: Rating(rawValue: rating), description: description, uploadDate: createdAt, lastEdited: updatedAt); //TODO handle when created/updated are null
        
        return post;
    }
    
    func displayUI() {
        let userProfileIconView = UIImageView();
        userProfileIconView.backgroundColor = .green; //debug
        
        let loadUrl = self.posts[0].postImageLink; //TODO actually use user profile URL
        userProfileIconView.kf.setImage(with: loadUrl);
        
        let userUserNameView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21));
        userUserNameView.backgroundColor = .black; //debug
        let userFullNameView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21));
        userFullNameView.font = userFullNameView.font.withSize(24); //TODO constants
        userFullNameView.sizeToFit();
        userFullNameView.backgroundColor = .gray; //debug
        let userDescriptionView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21));
        userDescriptionView.sizeToFit();
        userDescriptionView.backgroundColor = .blue; //debug
        let userLocationView = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 21));
        userLocationView.textAlignment = .right;
        userLocationView.font = userLocationView.font.withSize(20); //TODO constants
        userLocationView.sizeToFit();
        userLocationView.backgroundColor = .yellow; //debug
        let userPostCountView = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 21));
        userPostCountView.textAlignment = .left;
        userPostCountView.font = userPostCountView.font.withSize(20); //TODO constants
        userPostCountView.sizeToFit();
        userPostCountView.backgroundColor = .orange; //debug
        
        userUserNameView.text = user.userName;
        userFullNameView.text = user.fullName;
        userDescriptionView.text = user.description;
        userLocationView.text = "Seattle, Washington"; //TODO parse later
        userPostCountView.text = String(self.posts.count) + " posts";
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5); //TODO remove hardcode
        layout.itemSize = CGSize(width: 150, height: 150); //TODO remove hardcode
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        let myCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout); //todo resizable frame
        myCollectionView.backgroundColor = UIColor.blue;
        myCollectionView.dataSource = self as UICollectionViewDataSource
        myCollectionView.delegate = self as UICollectionViewDelegate
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: profilePostCellIdentifer)
        self.collectionView = myCollectionView;
        
        let profileInfoStackView = UIStackView();
        profileInfoStackView.axis = .vertical;
        profileInfoStackView.distribution = .equalCentering;
        profileInfoStackView.alignment = .fill;
        
        let profilePictureAndUserInfoStackView = UIStackView();
        profilePictureAndUserInfoStackView.axis = .horizontal;
        profilePictureAndUserInfoStackView.alignment = .center;
        profilePictureAndUserInfoStackView.spacing = 15;
        
        let profileNameAndDescriptionView = UIStackView();
        profileNameAndDescriptionView.axis = .vertical;
        profileNameAndDescriptionView.addArrangedSubview(userFullNameView);
        profileNameAndDescriptionView.addArrangedSubview(userDescriptionView);
        
        profilePictureAndUserInfoStackView.addArrangedSubview(userProfileIconView);
        profilePictureAndUserInfoStackView.addArrangedSubview(profileNameAndDescriptionView);
        
        let locationAndPostView = UIStackView();
        locationAndPostView.axis = .horizontal;
        locationAndPostView.alignment = .center;
        locationAndPostView.distribution = .fill;
        locationAndPostView.spacing = 5;
        locationAndPostView.addArrangedSubview(userLocationView);
        locationAndPostView.addArrangedSubview(userPostCountView);
        
        profileInfoStackView.addArrangedSubview(profilePictureAndUserInfoStackView);
        profileInfoStackView.addArrangedSubview(locationAndPostView);
        
        primaryStackView = UIStackView(arrangedSubviews: [
            profileInfoStackView,
            myCollectionView
            ]);
        
        view.addSubview(primaryStackView);
        
        self.setViewProperties();
        
        //TODO
        userProfileIconView.contentMode = .scaleAspectFill;
        userProfileIconView.widthAnchor.constraint(equalTo: profilePictureAndUserInfoStackView.widthAnchor, multiplier: 0.25).isActive = true;
        userProfileIconView.heightAnchor.constraint(equalTo: profilePictureAndUserInfoStackView.heightAnchor, multiplier: 0.2).isActive = true;
    }
    
    func setViewProperties() {
        primaryStackView.translatesAutoresizingMaskIntoConstraints = false
        primaryStackView.axis = .vertical
        primaryStackView.alignment = .center
        primaryStackView.backgroundColor = .purple;
        primaryStackView.distribution = .fill;
        
        primaryStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        primaryStackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        primaryStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        primaryStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        primaryStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        primaryStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        primaryStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.heightAnchor.constraint(equalTo: primaryStackView.heightAnchor, multiplier: 0.7).isActive = true;
        collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true;
        
        let profileInfoStackView = primaryStackView.subviews[0];
        profileInfoStackView.translatesAutoresizingMaskIntoConstraints = false;
        profileInfoStackView.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor, multiplier: 0.8).isActive = true;
        
        let profilePictureAndUserInfoStackView = profileInfoStackView.subviews[0];
        profilePictureAndUserInfoStackView.translatesAutoresizingMaskIntoConstraints = false;
        let profileNameAndDescriptionView = profilePictureAndUserInfoStackView.subviews[0];
        profileNameAndDescriptionView.translatesAutoresizingMaskIntoConstraints = false;
        
        let locationAndPostView = profileInfoStackView.subviews[1];
        locationAndPostView.translatesAutoresizingMaskIntoConstraints = false;
        locationAndPostView.heightAnchor.constraint(equalTo: profileInfoStackView.heightAnchor, multiplier: 0.3).isActive = true;
        
        let userProfileIconView = profilePictureAndUserInfoStackView.subviews[0];//TODO constraints
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
