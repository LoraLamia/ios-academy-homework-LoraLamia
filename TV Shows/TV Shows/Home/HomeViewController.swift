
import UIKit

class HomeViewController: UIViewController {
    
    var user: UserResponse?
    var authInfo: AuthInfo?
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
