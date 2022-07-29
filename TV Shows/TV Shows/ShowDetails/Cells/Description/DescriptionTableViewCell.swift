//
//  DescriptionTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 25.07.2022..
//

import UIKit

final class DescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var reviewInfoLabel: UILabel!
    @IBOutlet private weak var showDescriptionLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
    
    // MARK: - Utility methods
    
    func configure(with show: DescriptionTableViewCellModel) {
        
        showDescriptionLabel.text = show.description
        ratingView.setRoundedRating(show.averageRating ?? 0)
        reviewInfoLabel.text = "\(show.numberOfReviews ?? 0) REVIEWS, \(show.averageRating ?? 0) AVERAGE"
    }
}
