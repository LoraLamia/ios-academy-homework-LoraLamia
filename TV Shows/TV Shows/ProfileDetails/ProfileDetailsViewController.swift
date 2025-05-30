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

protocol ProfileDetailsViewControllerDelegate: AnyObject {
    func logout()
}

final class ProfileDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!
    @IBOutlet private weak var changePhotoButton: UIButton!
    @IBOutlet private weak var profilePictureImageView: UIImageView!
    
    // MARK: - Properties
    
    weak var delegate: ProfileDetailsViewControllerDelegate?
    var authInfo: AuthInfo?
    var userDetails: UserResponse?
    private let imagePicker = UIImagePickerController()
    
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
    
    // MARK: - Actions
    
    @IBAction func changePhotoButtonPressed() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
                
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonPressed() {
        
        dismiss(animated: true, completion: {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.authInfo.rawValue)
            self.delegate?.logout()
            })
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
            storeImage(pickedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func storeImage(_ image: UIImage) {
        guard let authInfo = authInfo, let userDetails = userDetails, let imageData = image.jpegData(compressionQuality: 0.9) else { return }

        let requestData = MultipartFormData()
        requestData.append(
            imageData,
            withName: "image",
            fileName: "image.jpg",
            mimeType: "image/jpg"
        )
        
        requestData.append(Data(userDetails.user.email.utf8), withName: "email")
    
        AF
            .upload(
                multipartFormData: requestData,
                to: Urls.user.rawValue,
                method: .put,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                switch dataResponse.result {
                case .success(let userResponse):
                    self.handleSuccessCase(userResponse: userResponse)
                case .failure:
                    self.handleErrorCase()
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
    
    private func handleSuccessCase(userResponse: UserResponse) {
        
        self.userDetails = userResponse
        guard let userDetails = userDetails else { return }
        emailLabel.text = userDetails.user.email
        
        guard let url = userDetails.user.imageUrl else { return }
        profilePictureImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ic-profile-placeholder")
        )
    }
    
    private func handleErrorCase() {
        
        let alert = UIAlertController(title: "Oops!", message: "Something went wrong, please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Action handlers

private extension ProfileDetailsViewController {

    @objc
    func closePressed(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


