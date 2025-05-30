//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by Infinum on 25.07.2022..
//

import UIKit
import Alamofire
import MBProgressHUD

protocol WriteReviewViewControllerDelegate: AnyObject {
    func addReview(_ newReview: Review)
}

final class WriteReviewViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var commentTextView: UITextView!
    
    // MARK: - Properties
    
    weak var delegate: WriteReviewViewControllerDelegate?
    var authInfo: AuthInfo?
    var showId: Int?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        commentTextView.layer.cornerRadius = 10;
        submitButton.layer.cornerRadius = 24
    }
    
    // MARK: - Actions
    
    @IBAction func submitReviewButton() {
        
        guard let showId = showId, let authInfo = authInfo else { return }
    
        let parameters: [String: Any] = [
            "rating": ratingView.rating,
            "comment": commentTextView.text ?? "",
            "show_id": showId
        ]
        
        AF.request(
              Urls.review.rawValue,
              method: .post,
              parameters: parameters,
              headers: HTTPHeaders(authInfo.headers)
          )
          .validate()
          .responseDecodable(of: ReviewResponse.self) { [weak self] dataResponse in
              guard let self = self else { return }
              MBProgressHUD.hide(for: self.view, animated: true)
              switch dataResponse.result {
              case .success(let reviewResponse):
                  self.handleSuccessCase(reviewResponse: reviewResponse)
              case .failure:
                  self.handleErrorCase()
              }
          }
    }
    
    // MARK: - Utility methods
    
    private func setupUI() {
        
        ratingView.delegate = self
        submitButton.isEnabled = false
        submitButton.setTitleColor(.white, for: .disabled)
        submitButton.backgroundColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 0.5)
        commentTextView.clipsToBounds = true;
    }
    
    private func setupNavigationBar() {
        title = "Write a Review"
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.94)
        navigationController?.navigationBar.tintColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closePressed(_:)))
    }
    
    private func handleSuccessCase(reviewResponse: ReviewResponse) {
        delegate?.addReview(reviewResponse.review)
        dismiss(animated: true, completion: nil)
    }
    
    private func handleErrorCase() {
        let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Action handlers

private extension WriteReviewViewController {

    @objc
    func closePressed(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Delegates

extension WriteReviewViewController: RatingViewDelegate {
    func didChangeRating(_ rating: Int) {
        submitButton.isEnabled = true
        submitButton.backgroundColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
        submitButton.tintColor = .white
    }
}
