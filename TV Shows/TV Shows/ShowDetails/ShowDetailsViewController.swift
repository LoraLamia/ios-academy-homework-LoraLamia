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
    
    //MARK: - Outlets
    
    @IBOutlet weak var writeReviewButton: UIButton!
    @IBOutlet private weak var descriptionTableView: UITableView!
    
    //MARK: - Properties
    
    var authInfo: AuthInfo?
    var showId: String = ""
    var show: Show?
    var reviews: [Review] = []
    
    //MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        fetchReviews()
    }
    
    //MARK: - Utility methods
    
    @IBAction private func writeReviewButtonPressed() {
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
    
    private func setUp() {
        descriptionTableView.delegate = self
        descriptionTableView.dataSource = self
        writeReviewButton.layer.cornerRadius = 24
        writeReviewButton.tintColor = .white
        writeReviewButton.backgroundColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
        
    }
    
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("funcija 1 pozvana")
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("f-ja 2 pozvana")
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableViewCell", for: indexPath) as! DescriptionTableViewCell
        
        guard let show = show else {
            print("there is no show")
            return UITableViewCell.init() }
        guard let showDescription = show.description else {
            print("there is no description")
            return UITableViewCell.init()
        }
        cell.setShowDescription(text: showDescription)
        

        return cell
    }
}

extension ShowDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
//        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
//        let showDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ShowDetailsViewController") as! ShowDetailsViewController
//        showDetailsViewController.authInfo = authInfo
//        showDetailsViewController.showId = showsList[indexPath.row].id
//        showDetailsViewController.show = showsList[indexPath.row]
//        navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
}


