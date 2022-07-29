//
//  ReviewTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import UIKit

final class ReviewTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var profilePictureImageView: UIImageView!
    @IBOutlet private weak var reviewLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
    
    // MARK: - Utility methods
    
    func configure(with review: ReviewTableViewCellModel) {
        
        reviewLabel.text = review.comment
        emailLabel.text = review.email
        ratingView.rating = review.rating

        guard let imageUrl = review.user.imageUrl else { return }
        profilePictureImageView.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "ic-profile-placeholder")
        )
    }
}
