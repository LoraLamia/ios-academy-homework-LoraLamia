

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var visibilityButton: UIButton!
    
    // MARK: - Properties
    
    private var rememberMe = false
    private var visibility = false
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visibilityButton.isHidden = true
        textFieldsSetUp()
        setButtonsDisabled()
        setButtonImages()
    }
    
    // MARK: - Actions
    
    @IBAction private func emailTextFieldChanged() {
        updateButtons()
    }
    
    @IBAction private func passwordTextFieldChanged() {
        updateButtons()
        visibilityButton.isHidden = false
    }
    
    @IBAction private func rememberMeButtonPressed() {
        rememberMeButton.isSelected.toggle()
    }
    
    @IBAction private func visibilityButtonPressed() {
        visibilityButton.isSelected.toggle()
        passwordTextField.isSecureTextEntry = !visibilityButton.isSelected
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
        visibilityButton.setImage(UIImage(named: "ic-visible"), for: .normal)
        visibilityButton.setImage(UIImage(named: "ic-invisible"), for: .selected)
    }
    
    private func setButtonsDisabled() {
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        loginButton.layer.cornerRadius = 24
        loginButton.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        
        registerButton.isEnabled = false
        registerButton.backgroundColor = .clear
        registerButton.layer.cornerRadius = 24
        registerButton.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        
        descriptionLabel.isHidden = true
    }
    
    private func setButtonsEnabled() {
        loginButton.isEnabled = true
        loginButton.backgroundColor = .white
        loginButton.tintColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
        
        registerButton.isEnabled = true
        registerButton.tintColor = .white
        descriptionLabel.isHidden = false
    }
    
    private func updateButtons() {
        guard let emailText = emailTextField.text, let passwordText = passwordTextField.text else { return }
        
        if !emailText.isEmpty && !passwordText.isEmpty {
            setButtonsEnabled()
        } else {
            setButtonsDisabled()
        }
    }
    
}
