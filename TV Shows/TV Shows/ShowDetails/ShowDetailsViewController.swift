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
    
    //***Jel showId mora biti optional?
    
    var authInfo: AuthInfo?
    var showId: String = ""
    var show: Show?
    var reviews: [Review] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchReviews()
    }
    
    private func fetchReviews() {
        guard let authInfo = authInfo else { return }
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
              case .failure:
                  print("error")
                
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
    

    
}
