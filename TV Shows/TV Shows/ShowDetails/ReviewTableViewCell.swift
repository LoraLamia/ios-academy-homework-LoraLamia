//
//  ReviewTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 27.07.2022..
//

import UIKit

final class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.configure(withStyle: .small)
    }
    
    func configure(with item: ReviewTableViewCellModel) {
        
        reviewLabel.text = item.comment
        emailLabel.text = item.email

    }

}
