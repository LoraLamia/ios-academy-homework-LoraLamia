

import UIKit
import Alamofire
import MBProgressHUD

final class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var passwordVisibilityButton: UIButton!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordVisibilityButton.isHidden = true
        textFieldsSetUp()
        setLoginRegisterButtons(enabled: false)
        setButtonImages()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    // MARK: - Actions
    
    @IBAction private func emailTextFieldChanged() {
        updateButtons()
    }
    
    @IBAction private func passwordTextFieldChanged() {
        updateButtons()
        passwordVisibilityButton.isHidden = false
    }
    
    @IBAction private func rememberMeButtonPressed() {
        rememberMeButton.isSelected.toggle()
    }
    
    @IBAction private func visibilityButtonPressed() {
        passwordVisibilityButton.isSelected.toggle()
        passwordTextField.isSecureTextEntry = !passwordVisibilityButton.isSelected
    }
    
    @IBAction func LoginButtonPressed() {
        navigateToHomeViewController()
    }
    
    @IBAction func RegisterButtonPressed() {
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else { return }
        
        if !emailText.isEmpty && !passwordText.isEmpty {
            let parameters: [String: String] = [
                "email": emailText,
                "password": passwordText,
                "password_confirmation": passwordText
            ]
            
            MBProgressHUD.showAdded(to: view, animated: true)

            AF.request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: parameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let user):
                    print("Success: \(user)")
                    self.navigateToHomeViewController()
                case .failure:
                    print("error")
                }
            }
        }
    }
    
    // MARK: - Utility methods
    
    private func textFieldsSetUp() {
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8)]
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8)]
        )
    }
    
    private func setButtonImages() {
        rememberMeButton.setImage(UIImage(named: "ic-checkbox-selected"), for: .selected)
        rememberMeButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
        passwordVisibilityButton.setImage(UIImage(named: "ic-visible"), for: .normal)
        passwordVisibilityButton.setImage(UIImage(named: "ic-invisible"), for: .selected)
    }
    
    
    private func setLoginRegisterButtons(enabled: Bool) {
        if enabled {
            loginButton.tintColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
            registerButton.tintColor = .white
        } else {
            loginButton.layer.cornerRadius = 24
            loginButton.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
    
            registerButton.backgroundColor = .clear
            registerButton.layer.cornerRadius = 24
            registerButton.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        }
        
        loginButton.isEnabled = enabled
        loginButton.backgroundColor = enabled ? .white : UIColor.white.withAlphaComponent(0.3)
        registerButton.isEnabled = enabled
        descriptionLabel.isHidden = !enabled
    }
    
    private func updateButtons() {
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else { return }
        
        if !emailText.isEmpty && !passwordText.isEmpty {
            setLoginRegisterButtons(enabled: true)
        } else {
            setLoginRegisterButtons(enabled: false)
        }
    }
    
    private func navigateToHomeViewController() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
}
