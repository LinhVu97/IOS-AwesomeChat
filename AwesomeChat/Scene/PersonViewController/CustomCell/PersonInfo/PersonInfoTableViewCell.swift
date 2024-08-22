//
//  PersonInfoTableViewCell.swift
//  AwesomeChat
//
//  Created by Linh Vu on 21/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol PersonInfoTableViewCellDelegate: AnyObject {
    func didUpdateProfileImage(image: UIImage)
}

class PersonInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var imagePersonView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    weak var delegate: PersonInfoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupView() {
        imagePersonView.layer.cornerRadius = imagePersonView.frame.size.width / 2
        imagePersonView.layer.borderWidth = 3
        imagePersonView.layer.borderColor = UIColor(named: "blueColor")?.cgColor
        imagePersonView.isUserInteractionEnabled = true
        imagePersonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editProfileImage)))
        
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        let auth = Auth.auth()
        
        if let user = auth.currentUser {
            let db = Firestore.firestore()
            let userId = user.uid
            
            db.collection("users").document(userId).getDocument { [weak self] document, error in
                guard let self = self else { return }
                
                if let document = document, document.exists {
                    let username = document.data()?["username"] as? String
                    let email = document.data()?["email"] as? String
                    let image = document.data()?["profileImageUrl"] as? String
                    self.nameLabel.text = username
                    self.emailLabel.text = email
                    
                    if let url = URL(string: image ?? "") {
                        self.imagePersonView.loadImage(url: url)
                    }
                }
            }
            
        }
    }
    
    @objc private func editProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        if let viewController = self.parentViewController {
            viewController.present(imagePicker, animated: true)
        }
    }
    
    private func uploadImageToFirestore(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.75),
              let user = Auth.auth().currentUser else {
            return
        }
        
        let storageRef = Storage.storage().reference().child("user_images/\(user.uid).jpg")
        
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
                    FirebaseManager.shared.updateProfileImageUrl(downloadUrl.absoluteString, "profileImageUrl")
                    self.delegate?.didUpdateProfileImage(image: image)
                }
            }
        }
    }
    
    @IBAction func editInformation(_ sender: Any) {
    }
}

extension PersonInfoTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        imagePersonView?.image = image
        uploadImageToFirestore(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
