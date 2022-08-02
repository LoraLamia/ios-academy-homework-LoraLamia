//
//  HomeTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 23.07.2022..
//

import UIKit
import Kingfisher

final class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    // MARK: - Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Utility methods
    
    func configure(with item: HomeTableViewCellModel) {
        
        let url = item.imageUrl
        showTitleLabel.text = item.text
        iconImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ic-show-placeholder-vertical")
        )
        
        self.iconImageView.alpha = 0
        UIView.animate(withDuration: 1) { [weak self] in
            guard let self = self else { return }
            self.iconImageView.alpha = 1
        }
    }
}
