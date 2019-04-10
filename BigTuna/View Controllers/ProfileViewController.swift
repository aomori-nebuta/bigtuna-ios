//
//  ProfileViewController.swift
//  BigTuna
//
//  Created by Christine Tsou on 2/9/19.
//  Copyright © 2019 aomori nebuta. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreLocation

extension UIView {
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer();
        //border.backgroundColor = color
        border.borderColor = color;
        
        switch side {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        print("frame.minX: ", frame.minX);
        print("frame.maxY: ", frame.maxY);
        print("frame.width: ", frame.width);
        
        layer.addSublayer(border)
        layer.masksToBounds = true;
    }
}

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var primaryStackView: UIStackView!;
    var collectionView: UICollectionView!;
    
    var userProfileIconView: UIImageView!;
    var userUserNameView: UILabel!;
    var userFullNameView: UILabel!;
    var userDescriptionView: UILabel!;
    var userLocationView: UILabel!;
    var userPostCountView: UILabel!;
    
    var posts = Array<Post>();
    var user: User = User(userName: "", fullName: "", location: "", profilePicture: UIImage(), followers: Array<User>(), posts: Array<Post>(), description: "");
    
    let profilePostCellIdentifer: String = "profilePostCell";
    
    let ITEMS_PER_ROW: Int = 3;
    let INTER_ITEM_SPACING: Float = 2.5;
    let LINE_SPACING_FOR_SECTION: Float = 2.5;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayUI();
        loadProfile();
    }
    
    func getUserBaseURL() -> String {
        //TODO, https requests only in the future
        //see https://stackoverflow.com/questions/32712155/app-transport-security-policy-requires-the-use-of-a-secure-connection-ios-9 and undo
        let hostName = "ec2-18-217-215-145.us-east-2.compute.amazonaws.com"; //TODO
        let port = "8010"; //TODO
        let baseURL = "http://" + hostName + ":" + port; //TODO
        
        return baseURL;
    }
    
    func getUserProfileURL() -> String {
        let baseURL = getUserBaseURL();
        let userId = "5c8727ba2556d0e49c820591"; //TODO
        let userInfoURL = baseURL + "/users/" + userId;
        
        return userInfoURL;
    }
    
    func getUserPostURL() -> String {
        let userInfoUrl =  getUserProfileURL();
        let userPostsURL = userInfoUrl + "/posts";
        
        return userPostsURL;
    }
    
    func loadProfile() {
        //TODO
        //https://www.iconfinder.com/icons/211605/contact_icon
        DispatchQueue.global(qos: .utility).async {
            self.fetchUserInfo(userInfoURL: self.getUserProfileURL());
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.fetchUserPosts(userPostsURL: self.getUserPostURL());
        }
    }
    
    //TODO error handling
    //TODO handle international addresses
    func parseLocationFromPlacemark(placemarks: [CLPlacemark]?, error: Error?) {
        let placemark: CLPlacemark = placemarks?[0] as! CLPlacemark;
        let city = placemark.locality;
        let state = placemark.administrativeArea;
        let userLocationString = "\(city ?? "Unknown"), \(state ?? "Unknown")";
        
        user.location = userLocationString;
        
        self.updateUserProfileLocation();
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), completionHandler: completion)
    }
    
    func fetchUserInfo(userInfoURL: String) {
        Alamofire.request(
            userInfoURL,
            method: .get
            ).validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let JSON = data as! [String: Any];
                    //TODO guard
                    self.user.userName = (JSON["userName"] as! String);
                    self.user.description = (JSON["description"] as! String);
                    self.user.fullName = (JSON["fullName"] as! String);
                    //TODO profileURI
                    let location = JSON["location"] as! [String: Any];
                    let coordinates = location["coordinates"] as! [Double];
                    
                    self.geocode(latitude: coordinates[1], longitude: coordinates[0], completion: self.parseLocationFromPlacemark);
                    
                    self.displayUserInfo();
                    
                    break;
                case .failure(let error):
                    print(error);
                    break;
                }
        }
    }
    
    func fetchUserPosts(userPostsURL: String) {
        Alamofire.request(
            userPostsURL,
            method: .get
            ).validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    let JSON = data as? Array<[String: Any]> ?? [];
                    
                    for rawPostJSON in JSON {
                        let userPost = self.parseUserPost(postData: rawPostJSON);
                        
                        self.posts.append(userPost);
                    }
                    self.displayUserPosts();
                    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let whiteSpace: Int = (ITEMS_PER_ROW - 1) * Int(INTER_ITEM_SPACING);
        let spaceToDistribute: Int = Int(UIScreen.main.bounds.size.width) - whiteSpace;
        let size: Int = spaceToDistribute/ITEMS_PER_ROW;
        
        return CGSize(width: size, height: size);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(INTER_ITEM_SPACING);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(LINE_SPACING_FOR_SECTION);
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: profilePostCellIdentifer, for: indexPath);
        
        let imageURL = self.posts[indexPath.item].postImageLink;
        let imageView = UIImageView();
        
        Alamofire.request(imageURL!).responseImage { response in
            if let image = response.result.value {
                DispatchQueue.main.async {
                    imageView.image = image;
                }
            }
        }
        
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
    
    func updateUserProfileLocation() {
        userLocationView.text = user.location;
    }
    
    func displayUserInfo() {
        let loadUrl = "https://www.searchpng.com/wp-content/uploads/2019/02/Happy-Face-Emoji-PNG-Image-1024x1024.png"; //TODO actually use user profile URL
        Alamofire.request(loadUrl).responseImage { response in
            if let image = response.result.value {
                self.userProfileIconView.image = image;
            }
        }
        
        userUserNameView.text = user.userName;
        userFullNameView.text = user.fullName;
        userDescriptionView.text = user.description;
        userLocationView.text = user.location;
    }
    
    func displayUserPosts() {
        userPostCountView.text = "\(String(self.posts.count)) posts";
        
        collectionView.reloadData();
    }
    
    func displayUI() {
        //TOOD this first block must happen before displayUserInfo/posts or at least the initialization part of the block
        userUserNameView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21));
        userFullNameView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21));
        userFullNameView.font = userFullNameView.font.withSize(24); //TODO constants
        userFullNameView.textColor = .darkGray;
        userFullNameView.sizeToFit();
        userDescriptionView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21));
        userDescriptionView.textColor = .darkGray;
        userDescriptionView.sizeToFit();
        userLocationView = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 21));
        userLocationView.textAlignment = .right;
        userLocationView.font = userLocationView.font.withSize(20); //TODO constants
        userLocationView.textColor = .darkGray;
        userLocationView.sizeToFit();
        userPostCountView = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 21));
        userPostCountView.textAlignment = .left;
        userPostCountView.font = userPostCountView.font.withSize(20); //TODO constants
        userPostCountView.textColor = .darkGray;
        userPostCountView.sizeToFit();
        
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout());
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: profilePostCellIdentifer)
        collectionView.backgroundColor = .white;
        let collectionViewWrapper = UIView();
        
        
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
        
        userProfileIconView = UIImageView();
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
        let profileInfoStackViewWrapper = UIView();
        //profileInfoStackViewWrapper.addSubview(profileInfoStackView);
        //profileInfoStackViewWrapper.addBorder(toSide: .Bottom, withColor: UIColor.lightGray.cgColor, andThickness: 10.0);
        
        //todo, put mycollectionview and profileinfostackview into UIView containers and add borders to these containers instead
        
        primaryStackView = UIStackView(arrangedSubviews: [
            profileInfoStackView,//profileInfoStackViewWrapper,
            collectionView
            //collectionViewWrapper
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
        collectionView.addBorder(toSide: .Bottom, withColor: UIColor.lightGray.cgColor, andThickness: 10.0);
        
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
        
        //let userProfileIconView = profilePictureAndUserInfoStackView.subviews[0];//TODO constraints
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
