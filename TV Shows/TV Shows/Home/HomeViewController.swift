
import UIKit
import Alamofire
import MBProgressHUD

final class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var showTableView: UITableView!
    
    // MARK: - Properties
    
    var user: UserResponse?
    var authInfo: AuthInfo?
    private var showsList: [Show] = [] {
        didSet {
            showTableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        setupProfileDetailsButton()
        fetchShows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Actions
    
    @objc
    private func profileDetailsActionHandler() {
          print("click")
    }
    
    // MARK: - Utility methods
    
    private func handleSuccesCase(showsResponse: ShowsResponse) {
        
        showsList = showsResponse.shows
    }
    
    private func handleErrorCase() {
        let alert = UIAlertController(title: "Error", message: "Could not fetch data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    private func setupUI() {
        
        MBProgressHUD.showAdded(to: view, animated: true)
        title = "Shows"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setViewControllers([self], animated: true)
        navigationController?.navigationBar.barTintColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 0.94)
        navigationController?.navigationBar.tintColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
    }
    
    private func setupTableView() {
        showTableView.delegate = self
        showTableView.dataSource = self
    }
    
    private func setupProfileDetailsButton() {
        let profileDetailsItem = UIBarButtonItem(
                  image: UIImage(named: "ic-profile"),
                  style: .plain,
                  target: self,
                  action: #selector(profileDetailsActionHandler)
                )
                navigationItem.rightBarButtonItem = profileDetailsItem
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
        let show = showsList[indexPath.row]
        let title = show.title
        let imageUrl = show.imageUrl
        let item = HomeTableViewCellModel(text: title,
                                          imageUrl: imageUrl)
        cell.configure(with: item)

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let showDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
        showDetailsViewController.authInfo = authInfo
        showDetailsViewController.show = showsList[indexPath.row]
        navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
}

