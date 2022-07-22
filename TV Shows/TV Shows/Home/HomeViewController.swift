
import UIKit
import Alamofire
import MBProgressHUD

class HomeViewController: UIViewController {
    
    //MARK: Properties
    
    var user: UserResponse?
    var authInfo: AuthInfo?
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        MBProgressHUD.showAdded(to: view, animated: true)
        guard let authInfo = authInfo else { return }
        AF.request(
              "https://tv-shows.infinum.academy/shows",
              method: .get,
              parameters: ["page": "1", "items": "100"], 
              headers: HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: ShowsResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              MBProgressHUD.hide(for: self.view, animated: true)
              switch dataResponse.result {
              case .success(let showsResponse):
                  print("succes")
              case .failure:
                  print("error")
                
              }
          }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
