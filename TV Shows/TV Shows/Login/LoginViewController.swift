

import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailValueTextField: UITextField!
    @IBOutlet weak var passwordValueTextField: UITextField!
    
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
        emailValueTextField.placeholder = "Email"
        passwordValueTextField.placeholder = "Password"
        
        
    }
}
