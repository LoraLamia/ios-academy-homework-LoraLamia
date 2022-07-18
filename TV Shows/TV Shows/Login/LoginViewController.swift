

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var passwordVisibilityButton: UIButton!
    
    // MARK: - Properties
    
    private var rememberMe = false
    private var visibility = false
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordVisibilityButton.isHidden = true
        textFieldsSetUp()
        setLoginRegisterButtons(enabled: false)
        setButtonImages()
    }
    
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
    
}
