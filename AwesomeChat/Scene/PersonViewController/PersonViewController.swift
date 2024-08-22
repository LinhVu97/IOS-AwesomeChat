//
//  PersonViewController.swift
//  AwesomeChat
//
//  Created by Linh Vu on 19/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol PersonViewControllerDelegate: AnyObject {
    func didLogout()
}

class PersonViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: PersonViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 30
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.regsiterCell(ofType: PersonInfoTableViewCell.self)
        tableView.regsiterCell(ofType: SettingTableViewCell.self)
        tableView.regsiterCell(ofType: LogoutTableViewCell.self)
        
        fetchData()
    }
    
    private func fetchData() {
        let auth = Auth.auth()
        
        if let user = auth.currentUser {
            let db = Firestore.firestore()
            let userId = user.uid
            
            db.collection("users").document(userId).getDocument { [weak self] document, error in
                guard let self = self else { return }
                
                if let document = document, document.exists {
                    let image = document.data()?["bannerImageUrl"] as? String
                    
                    if let url = URL(string: image ?? "") {
                        self.imageView.loadImage(url: url)
                    }
                }
            }
        }
    }
}

extension PersonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = indexPath.row
        
        switch cellType {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String.convertToString(PersonInfoTableViewCell.self), 
                                                     for: indexPath) as! PersonInfoTableViewCell
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String.convertToString(SettingTableViewCell.self), 
                                                     for: indexPath) as! SettingTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String.convertToString(LogoutTableViewCell.self),
                                                     for: indexPath) as! LogoutTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            AlertManager.shared.logout(vc: self) { [weak self] in
                guard let self = self else { return }
                self.delegate?.didLogout()
            }
        } else if indexPath.row == 3 {
            // Change to Edit Profile
        }
    }
}

extension PersonViewController: PersonInfoTableViewCellDelegate {
    func didUpdateProfileImage(image: UIImage) {
        imageView.image = image
        
        guard let imageData = image.jpegData(compressionQuality: 0.75),
              let user = Auth.auth().currentUser else {
            return
        }
        
        let storageRef = Storage.storage().reference().child("banner_images/\(user.uid).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { [weak self] metadata, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            storageRef.downloadURL { [weak self] url, error in
                guard let self = self else { return }
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let downloadUrl = url {
                    FirebaseManager.shared.updateProfileImageUrl(downloadUrl.absoluteString, "bannerImageUrl")
                }
            }
        }
    }
}
