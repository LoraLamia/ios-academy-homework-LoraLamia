//
//  HomeTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var showTitleLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with item: HomeTableViewCellModel) {
        showTitleLabel.text = item.text
    }
}
