//
//  HomeTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit

final class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var showTitleLabel: UILabel!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Utility methods
    
    func configure(with item: HomeTableViewCellModel) {
        
        showTitleLabel.text = item.text
    }
}
