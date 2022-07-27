//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by Infinum on 25.07.2022..
//

import UIKit

final class WriteReviewViewController: UIViewController {
    
    
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {

        commentTextView.textColor = UIColor.lightGray
        submitButton.layer.cornerRadius = 24
        submitButton.tintColor = .white
        submitButton.backgroundColor = UIColor(red: 82/255, green: 54/255, blue: 140/255, alpha: 1)
    }
    

}

extension WriteReviewViewController: UITextViewDelegate {
    
}
