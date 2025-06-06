

import UIKit
import Alamofire
import MBProgressHUD

final class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var passwordVisibilityButton: UIButton!
    
    // MARK: - Properties
    
    private var user: UserResponse?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordVisibilityButton.isHidden = true
        textFieldsSetUp()
        setLoginRegisterButtons(enabled: false)
        setButtonImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Actions
    
    @IBAction private func emailTextFieldChanged() {
        updateButtons()
    }
    
    @IBAction private func passwordTextFieldChanged() {
        updateButtons()
        guard let passwordText = passwordTextField.text else { return }
        passwordVisibilityButton.isHidden = passwordText.isEmpty
    }
    
    @IBAction private func rememberMeButtonPressed() {
        rememberMeButton.isSelected.toggle()
    }
    
    @IBAction private func visibilityButtonPressed() {
        passwordVisibilityButton.isSelected.toggle()
        passwordTextField.isSecureTextEntry = !passwordVisibilityButton.isSelected
    }
    
    @IBAction func loginButtonPressed() {
        guard
            let emailText = emailTextField.text,
            let passwordText = passwordTextField.text,
            !emailText.isEmpty,
            !passwordText.isEmpty
        else {
            return
        }
        
        let parameters: [String: String] = [
            "email": emailText,
            "password": passwordText
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)

        AF.request(
            Urls.signIn.rawValue,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            switch dataResponse.result {
            case .success(let responseUser):
                let headers = dataResponse.response?.headers.dictionary ?? [:]
                self.handleSuccesCase(responseUser: responseUser, headers: headers)
            case .failure:
                self.handleLoginErrorCase()
            }
        }
    }
    
    @IBAction func registerButtonPressed() {
        guard
            let emailText = emailTextField.text,
            let passwordText = passwordTextField.text,
            !emailText.isEmpty,
            !passwordText.isEmpty
        else {
            return
        }
        
        let parameters: [String: String] = [
            "email": emailText,
            "password": passwordText,
            "password_confirmation": passwordText
        ]
            
        MBProgressHUD.showAdded(to: view, animated: true)

        AF.request(
            Urls.user.rawValue,
            method: .post,
            parameters: parameters,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)
            switch dataResponse.result {
            case .success(let responseUser):
                let headers = dataResponse.response?.headers.dictionary ?? [:]
                self.handleSuccesCase(responseUser: responseUser, headers: headers)
            case .failure:
                self.handleRegisterErrorCase()
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
    
    private func pushHomeViewController(authInfo: AuthInfo, responseUser: UserResponse) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewController.authInfo = authInfo
        homeViewController.user = responseUser
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func handleSuccesCase(responseUser: UserResponse, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else { return }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(authInfo) {
            UserDefaults.standard.set(encoded, forKey: UserDefaultsKeys.authInfo.rawValue)
        }
        
        user = responseUser
        pushHomeViewController(authInfo: authInfo, responseUser: responseUser)
    }
    
    private func handleLoginErrorCase() {
        UIView.animate(withDuration: 0.7, animations: { self.loginButton.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7) }, completion: { (finish) in
            UIView.animate(withDuration: 0.3, animations: {
                self.loginButton.transform = CGAffineTransform.identity
            })
        })
        
        passwordTextField.shake()
        emailTextField.shake()
    }
    
    private func handleRegisterErrorCase() {
        let alert = UIAlertController(title: "Error", message: "Incorrect input", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

private extension UITextField {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
    }
}
