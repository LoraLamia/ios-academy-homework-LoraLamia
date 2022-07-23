//
//  HomeTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet private weak var showTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showTitleLabel.text = " "
    }
    
    func setShowTitle(text: String) {
        showTitleLabel.text = text
    }
}
