//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit
import Alamofire
import MBProgressHUD

class ShowDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var writeReviewButton: UIButton!
    @IBOutlet private weak var descriptionTableView: UITableView!
    
    //MARK: - Properties
    
    var authInfo: AuthInfo?
    var showId: String?
    var show: Show?
    var reviews: [Review] = [] {
        didSet {
            descriptionTableView.reloadData()
        }
    }
    
    //MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        fetchReviews()
    }
    
    //MARK: - Utility methods
    
    @IBAction private func writeReviewButtonPressed() {
        let storyboard = UIStoryboard(name: "WriteReview", bundle: nil)
        let writeReviewViewController = storyboard.instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
        let newNavigationController = UINavigationController(rootViewController: writeReviewViewController)
        navigationController?.present(newNavigationController, animated: true)
        
    }
    
    private func fetchReviews() {
        guard let authInfo = authInfo, let showId = showId else { return }
        AF.request(
              "https://tv-shows.infinum.academy/shows/\(showId)/reviews",
              method: .get,
              parameters: ["page": "1", "items": "100"],
              headers: HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: ReviewsResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              MBProgressHUD.hide(for: self.view, animated: true)
              switch dataResponse.result {
              case .success(let reviewsResponse):
                  self.handleSuccesCase(reviewsResponse: reviewsResponse)
              case .failure(let error):
                  print("Error : \(error.localizedDescription)")
                
              }
          }
    }
    
    private func handleSuccesCase(reviewsResponse: ReviewsResponse) {
        reviews = reviewsResponse.reviews
        print("succes")
    }
    
    private func handleErrorCase() {
        print("error")
    }
    
    private func setupUI() {
        
        writeReviewButton.layer.cornerRadius = 24
        writeReviewButton.tintColor = .white
        writeReviewButton.backgroundColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
    }
    
    private func setupTableView() {
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reviews.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let show = show else { return UITableViewCell.init() }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            
            let item = DescriptionTableViewCellModel(description: show.description)
            cell.configure(with: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
            
            let email = reviews[indexPath.row - 1].user.email
            let comment = reviews[indexPath.row - 1].comment
            let item = ReviewTableViewCellModel(comment: comment, email: email)
            cell.configure(with: item)
            
            return cell
        }
        
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


