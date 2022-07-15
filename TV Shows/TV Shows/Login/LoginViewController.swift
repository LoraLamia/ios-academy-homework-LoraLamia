

import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailValueTextField: UITextField!
    @IBOutlet weak var passwordValueTextField: UITextField!
    
    @IBOutlet weak var rememberMeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
  
    @IBAction func emailValueTextFieldChanged() {
    }
    
    @IBAction func passwordValueTextFieldChanged() {
    }
    
    
    
    
    func setUp () {
        
        descriptionLabel.isHidden = true
        
        emailValueTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8)]
        )
        passwordValueTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8)]
        )
        
        rememberMeButton.backgroundColor = .clear
        rememberMeButton.layer.borderColor = UIColor.white.cgColor
        rememberMeButton.layer.borderWidth = 3
        rememberMeButton.layer.cornerRadius = 5
        
        
        
        
    }
}
