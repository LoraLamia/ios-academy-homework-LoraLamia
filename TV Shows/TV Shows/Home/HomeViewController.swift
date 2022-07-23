
import UIKit
import Alamofire
import MBProgressHUD

final class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var showTableView: UITableView!
    
    //MARK: - Properties
    
    var user: UserResponse?
    var authInfo: AuthInfo?
    private var showsList: [Show] = []
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        fetchShows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Utility methods
    
    private func handleSuccesCase(showsResponse: ShowsResponse) {
        
        self.showsList = showsResponse.shows
        showTableView.reloadData()
    }
    
    private func handleErrorCase() {
        let alert = UIAlertController(title: "Error", message: "Could not fetch data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
        NSLog("")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setUp() {
        
        self.navigationItem.title = "Shows"
        navigationController?.setViewControllers([self], animated: true)
        showTableView.delegate = self
        showTableView.dataSource = self
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    private func fetchShows() {
        
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
                  self.handleSuccesCase(showsResponse: showsResponse)
              case .failure:
                  self.handleErrorCase()
                
              }
          }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return showsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        let title = showsList[indexPath.row].title
        cell.setShowTitle(text: title)

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

