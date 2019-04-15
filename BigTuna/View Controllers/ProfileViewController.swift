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

class BorderWrapper: UIView {
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    private var border = CALayer();
    private var viewSide = ViewSide.Bottom;
    private var thicknessValue = CGFloat(0);
    
    convenience init(side: ViewSide, color: CGColor, thickness: CGFloat) {
        self.init();
        
        viewSide = side;
        border.backgroundColor = color;
        thicknessValue = thickness;
    }
    
    convenience init() {
        self.init(frame: CGRect());
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        setupView();
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding");
    }
    
    func setupView() {
        layer.addSublayer(border);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        switch viewSide {
        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thicknessValue, height: frame.height); break
        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thicknessValue, height: frame.height); break
        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thicknessValue); break
        case .Bottom: border.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: thicknessValue); break
        }
    }
}

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var headerView: HeaderView!;
    var primaryStackView: UIStackView!;
    var collectionView: UICollectionView!;
    
    var userProfileIconView: UIImageView!;
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
    let BORDER_THICKNESS: CGFloat = 1;
    
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
        
        headerView.setUsername(userName: user.userName);
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
        headerView = HeaderView();
        
        userFullNameView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21));
        userFullNameView.font = userFullNameView.font.withSize(20); //TODO constants
        userFullNameView.textColor = .gray;
        userFullNameView.sizeToFit();
        userDescriptionView = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21));
        userDescriptionView.font = userDescriptionView.font.withSize(16);
        userDescriptionView.textColor = .gray;
        userDescriptionView.sizeToFit();
        userLocationView = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 21));
        userLocationView.textAlignment = .right;
        userLocationView.font = userLocationView.font.withSize(18); //TODO constants
        userLocationView.textColor = .gray;
        userLocationView.sizeToFit();
        userPostCountView = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 21));
        userPostCountView.textAlignment = .left;
        userPostCountView.font = userPostCountView.font.withSize(18); //TODO constants
        userPostCountView.textColor = .gray;
        userPostCountView.sizeToFit();
        
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout());
        collectionView.dataSource = self as UICollectionViewDataSource
        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: profilePostCellIdentifer)
        
        let profileInfoStackView = UIStackView();
        profileInfoStackView.axis = .vertical;
        profileInfoStackView.distribution = .equalCentering;
        profileInfoStackView.alignment = .fill;
        
        let profilePictureAndUserInfoView = UIView();
        
        let profileNameAndDescriptionView = UIStackView();
        profileNameAndDescriptionView.axis = .vertical;
        profileNameAndDescriptionView.distribution = .fillEqually;
        profileNameAndDescriptionView.alignment = .center;
        profileNameAndDescriptionView.addArrangedSubview(userFullNameView);
        profileNameAndDescriptionView.addArrangedSubview(userDescriptionView);
        
        userProfileIconView = UIImageView();
        profilePictureAndUserInfoView.addSubview(userProfileIconView);
        profilePictureAndUserInfoView.addSubview(profileNameAndDescriptionView);
        
        let locationAndPostView = UIStackView();
        locationAndPostView.axis = .horizontal;
        locationAndPostView.alignment = .center;
        locationAndPostView.distribution = .fillEqually;
        locationAndPostView.spacing = 5;
        locationAndPostView.addArrangedSubview(userLocationView);
        locationAndPostView.addArrangedSubview(userPostCountView);
        
        profileInfoStackView.addArrangedSubview(profilePictureAndUserInfoView);
        profileInfoStackView.addArrangedSubview(locationAndPostView);
        let profileInfoStackViewWrapper = BorderWrapper(side: .Bottom, color: UIColor.lightGray.cgColor, thickness: BORDER_THICKNESS);
        profileInfoStackViewWrapper.addSubview(profileInfoStackView);
        
        primaryStackView = UIStackView(arrangedSubviews: [
            profileInfoStackViewWrapper,
            collectionView
            ]);
        primaryStackView.spacing = BORDER_THICKNESS; //borders aren't factored into frame height, so we must set spacing

        view.addSubview(headerView);
        view.addSubview(primaryStackView);
        
        setViewProperties();
        headerView.applyViewProperties(view: view);
        
        userProfileIconView.contentMode = .scaleAspectFit;
        userProfileIconView.heightAnchor.constraint(equalTo: profilePictureAndUserInfoView.heightAnchor).isActive = true;
        userProfileIconView.widthAnchor.constraint(equalTo: profilePictureAndUserInfoView.heightAnchor).isActive = true;
    }
    
    func setViewProperties() {
        primaryStackView.translatesAutoresizingMaskIntoConstraints = false
        primaryStackView.axis = .vertical
        primaryStackView.alignment = .center
        primaryStackView.distribution = .fill;
        
        primaryStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        primaryStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        primaryStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        primaryStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        primaryStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        primaryStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        let profileInfoStackViewWrapper = primaryStackView.subviews[0];
        profileInfoStackViewWrapper.translatesAutoresizingMaskIntoConstraints = false;
        profileInfoStackViewWrapper.topAnchor.constraint(equalTo: primaryStackView.topAnchor).isActive = true;
        profileInfoStackViewWrapper.heightAnchor.constraint(equalTo: primaryStackView.heightAnchor, multiplier: 0.25).isActive = true;
        profileInfoStackViewWrapper.leadingAnchor.constraint(equalTo: primaryStackView.leadingAnchor).isActive = true
        profileInfoStackViewWrapper.trailingAnchor.constraint(equalTo: primaryStackView.trailingAnchor).isActive = true
        
        
        let profileInfoStackView = profileInfoStackViewWrapper.subviews[0];
        profileInfoStackView.translatesAutoresizingMaskIntoConstraints = false;
        profileInfoStackView.leadingAnchor.constraint(equalTo: profileInfoStackViewWrapper.leadingAnchor).isActive = true;
        profileInfoStackView.trailingAnchor.constraint(equalTo: profileInfoStackViewWrapper.trailingAnchor).isActive = true;
        profileInfoStackView.heightAnchor.constraint(equalTo: profileInfoStackViewWrapper.heightAnchor, multiplier: 0.75).isActive = true;
        profileInfoStackView.centerYAnchor.constraint(equalTo: profileInfoStackViewWrapper.centerYAnchor).isActive = true;
        
        
        let profilePictureAndUserInfoView = profileInfoStackView.subviews[0];
        profilePictureAndUserInfoView.translatesAutoresizingMaskIntoConstraints = false;
        profilePictureAndUserInfoView.widthAnchor.constraint(equalTo: profileInfoStackView.widthAnchor, multiplier: 0.8).isActive
            = true;
        profilePictureAndUserInfoView.heightAnchor.constraint(equalTo: profileInfoStackView.heightAnchor, multiplier: 0.75).isActive = true;
        profilePictureAndUserInfoView.centerXAnchor.constraint(equalTo: profileInfoStackView.centerXAnchor).isActive = true;
        
        let profilePictureView = profilePictureAndUserInfoView.subviews[0];
        profilePictureView.translatesAutoresizingMaskIntoConstraints = false;
        
        let profileNameAndDescriptionView = profilePictureAndUserInfoView.subviews[1];
        profileNameAndDescriptionView.translatesAutoresizingMaskIntoConstraints = false;
        profileNameAndDescriptionView.leftAnchor.constraint(equalTo: profilePictureView.rightAnchor, constant: 10).isActive = true;
 
        /* //TODO - add padding between username and description
        let userNameAndDescription = profileNameAndDescriptionView.subviews[1];
        let descriptionView = userNameAndDescription.subviews[1];
        descriptionView.translatesAutoresizingMaskIntoConstraints = false;
        descriptionView.topAnchor.constraint(equalToSystemSpacingBelow: <#T##NSLayoutYAxisAnchor#>, multiplier: <#T##CGFloat#>)
         */
        
        //TODO - add padding between location and posts count
        
        let collectionView = primaryStackView.subviews[1];
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor).isActive = true;
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
