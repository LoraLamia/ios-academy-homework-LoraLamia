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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //TU ONE GLUPE STRUKTURE
    
    func configure(text: String, email: String) {
        
        reviewLabel.text = text
        emailLabel.text = email
    }

}
