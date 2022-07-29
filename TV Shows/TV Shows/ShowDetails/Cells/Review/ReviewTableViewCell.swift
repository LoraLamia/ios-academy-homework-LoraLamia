//
//  ReviewTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import UIKit

final class ReviewTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
    
    // MARK: - Utility methods
    
    func configure(with item: ReviewTableViewCellModel) {
        
        reviewLabel.text = item.comment
        emailLabel.text = item.email
        ratingView.rating = item.rating
        
        guard let imageUrl = item.user.imageUrl else { return }
        profilePictureImageView.kf.setImage(
            with: URL(string: imageUrl),
            placeholder: UIImage(named: "ic-profile-placeholder")
        )
    }
}
