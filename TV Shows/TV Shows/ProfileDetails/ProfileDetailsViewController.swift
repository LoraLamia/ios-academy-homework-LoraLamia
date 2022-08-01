//
//  ProfileDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 01.08.2022..
//

import UIKit
import Alamofire
import MBProgressHUD
import Kingfisher

final class ProfileDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var changePhotoButton: UIButton!
    @IBOutlet private weak var profilePictureImageView: UIImageView!
    
    // MARK: - Properties
    
    var authInfo: AuthInfo?
    var userDetails: UserResponse? {
        didSet {
            self.reloadInputViews()
        }
    }
    let imagePicker = UIImagePickerController()
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        fetchUserDetails()
        setupNavigationBar()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        logoutButton.layer.cornerRadius = 24
    }
    
    // PARAMETERS????
    
    // MARK: - Actions
    
    @IBAction func changePhotoButtonPressed() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
                
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed() {
        
//        dismiss(animated: true, completion: {
//            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.authInfo.rawValue)
//            NotificationCenter.default.post(name: Notification.Name("Youlogedout"), object: nil)
//            })
    }
    
    // MARK: - Utility methods
    
    private func fetchUserDetails() {
        
        MBProgressHUD.showAdded(to: view, animated: true)
        guard let authInfo = authInfo else { return }
        AF.request(
              "https://tv-shows.infinum.academy/users/me",
              method: .get,
              parameters: [:],
              headers: HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              MBProgressHUD.hide(for: self.view, animated: true)
              switch dataResponse.result {
              case .success(let userResponse):
                  self.handleSuccessCase(userResponse: userResponse)
              case .failure:
                  self.handleErrorCase()
              }
          }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePictureImageView.contentMode = .scaleAspectFit
            //profilePictureImageView.image = pickedImage
            storeImage(pickedImage)
        }
        print("ova funckija se poziva")
        
        dismiss(animated: true, completion: nil)
    }
    
    // WEAK SELF I TO?????
    
    func storeImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else { return }

        let requestData = MultipartFormData()
        requestData.append(
            imageData,
            withName: "image",
            fileName: "image.jpg",
            mimeType: "image/jpg"
        )
        
        AF
            .upload(
                multipartFormData: requestData,
                to: "https://tv-shows.infinum.academy/users",
                method: .put
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { dataResponse in
                switch dataResponse.result {
                case .success(let userResponse):
                    //self.userDetails = userResponse
                    print("success")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.94)
        title = "My Account"
        navigationController?.navigationBar.tintColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closePressed(_:)))
    }
    
    private func setupUI() {
        
        logoutButton.isEnabled = true
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.backgroundColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
        changePhotoButton.setTitleColor(UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1), for: .normal)
        emailLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    // PLACEHOLDER???
    
    private func handleSuccessCase(userResponse: UserResponse) {
        
        self.userDetails = userResponse
        guard let userDetails = userDetails else { print("nema usera"); return }
        emailLabel.text = userDetails.user.email
        
        guard let image = userDetails.user.imageUrl else { return }
        let url = URL(string: image)
        profilePictureImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ic-profile-placeholder")
        )
    }
    
    private func handleGetImageSuccessCase(userResponse: UserResponse) {
        
    }
    
    private func handleErrorCase() {
        print("error")
    }
    
}

// MARK: - Action handlers

private extension ProfileDetailsViewController {

    @objc
    func closePressed(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


