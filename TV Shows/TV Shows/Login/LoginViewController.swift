

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var emailValueTextField: UITextField!
    @IBOutlet private weak var passwordValueTextField: UITextField!
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
    }
    
    // MARK: - Actions
    
    @IBAction private func emailValueTextFieldChanged() {
        updateButtons()
    }
    
    @IBAction private func passwordValueTextFieldChanged() {
        updateButtons()
        visibilityButton.isHidden = false
    }
    
    @IBAction private func rememberMeButtonPressed() {
        if !rememberMe {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-selected"), for: .normal)
            rememberMe = true
        } else {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
            rememberMe = false
        }
    }
    
    @IBAction private func visibilityButtonPressed() {
        if visibility {
            visibilityButton.setImage(UIImage(named: "ic-visible"), for: .normal)
            visibility = false
            passwordValueTextField.isSecureTextEntry = true
        } else {
            visibilityButton.setImage(UIImage(named: "ic-invisible"), for: .normal)
            visibility = true
            passwordValueTextField.isSecureTextEntry = false
        }
    }
    
    // MARK: - Utility methods
    
    private func textFieldsSetUp () {
        
        emailValueTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8)]
        )
        passwordValueTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8)]
        )
    }
    
    private func setButtonsDisabled () {
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
    
    private func setButtonsEnabled () {
        loginButton.isEnabled = true
        loginButton.backgroundColor = .white
        loginButton.tintColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
        
        registerButton.isEnabled = true
        registerButton.tintColor = .white
        descriptionLabel.isHidden = false
    }
    
    private func updateButtons () {
        guard let emailText = emailValueTextField.text, let passwordText = passwordValueTextField.text else { return }
        
        if !emailText.isEmpty && !passwordText.isEmpty {
            setButtonsEnabled()
        } else {
            setButtonsDisabled()
        }
    }
    
}
