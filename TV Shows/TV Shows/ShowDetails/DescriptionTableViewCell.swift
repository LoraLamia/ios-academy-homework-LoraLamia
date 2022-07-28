//
//  DescriptionTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 25.07.2022..
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet private weak var reviewInfoLabel: UILabel!
    @IBOutlet private weak var showDescriptionLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
        
    }
    
    func configure(with item: DescriptionTableViewCellModel) {
        
        showDescriptionLabel.text = item.description
        ratingView.setRoundedRating(item.averageRating ?? 0)
        reviewInfoLabel.text = "\(item.numberOfReviews ?? 0) REVIEWS, \(item.averageRating ?? 0) AVERAGE"
        
    }
}
