//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit
import Alamofire
import MBProgressHUD

final class ShowDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var writeReviewButton: UIButton!
    @IBOutlet private weak var descriptionTableView: UITableView!
    
    // MARK: - Properties
    
    var authInfo: AuthInfo?
    var show: Show?
    
    private var reviews: [Review] = [] {
        didSet {
            descriptionTableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        fetchReviews()
    }
    
    override func viewDidLayoutSubviews() {
        writeReviewButton.layer.cornerRadius = 24
    }

    // MARK: - Actions
    
    @IBAction private func writeReviewButtonPressed() {
        
        guard let show = show else { return }
        
        let storyboard = UIStoryboard(name: "WriteReview", bundle: nil)
        let writeReviewViewController = storyboard.instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
        writeReviewViewController.authInfo = authInfo
        writeReviewViewController.showId = Int(show.id)
        writeReviewViewController.delegate = self
        let newNavigationController = UINavigationController(rootViewController: writeReviewViewController)
        navigationController?.present(newNavigationController, animated: true)
    }
    
    // MARK: - Utility methods
    
    private func fetchReviews() {
        guard let authInfo = authInfo, let show = show else { return }
        AF.request(
            "https://tv-shows.infinum.academy/shows/\(show.id)/reviews",
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
    }
    
    private func setupUI() {
        
        writeReviewButton.tintColor = .white
        writeReviewButton.backgroundColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
        title = show?.title
    }
    
    private func setupTableView() {
        
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        descriptionTableView.allowsSelection = false
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reviews.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let show = show else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
            
            let item = DescriptionTableViewCellModel(
                description: show.description,
                averageRating: show.averageRating,
                numberOfReviews: reviews.count,
                imageUrl: show.imageUrl
            )
            cell.configure(with: item)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as! ReviewTableViewCell
            
            let review = reviews[indexPath.row - 1]
            let item = ReviewTableViewCellModel(
                comment: review.comment,
                email: review.user.email,
                rating: review.rating,
                user: review.user
            )
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

extension ShowDetailsViewController: WriteReviewViewControllerDelegate {

    func addReview(_ newReview: Review) {
        
        reviews.insert(newReview, at: 0)
    }
}


