
import UIKit
import Alamofire
import MBProgressHUD

class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var showTableView: UITableView!
    
    //MARK: - Properties
    
    var user: UserResponse?
    var authInfo: AuthInfo?
    var showsList: ShowsResponse?
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
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
                  self.handleSuccesCase(showsList: showsResponse)
              case .failure:
                  self.handleErrorCase()
                
              }
          }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Utility methods
    
    private func handleSuccesCase(showsList: ShowsResponse) {
        
        self.showsList = showsList
        showTableView.reloadData()
        print("succes")
    }
    
    private func handleErrorCase() {
        
        print("error")
    }
    
    private func setUp() {
        
        self.navigationItem.title = "Shows"
        navigationController?.setViewControllers([self], animated: true)
        showTableView.delegate = self
        showTableView.dataSource = self
        MBProgressHUD.showAdded(to: view, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let showsList = showsList else { return 0 }
        return showsList.shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        guard let showsList = showsList else { return UITableViewCell() }
        let title = showsList.shows[indexPath.row].title
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

