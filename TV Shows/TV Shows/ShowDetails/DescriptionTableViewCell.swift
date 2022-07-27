//
//  DescriptionTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 25.07.2022..
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet private weak var showDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with item: DescriptionTableViewCellModel) {
        
        showDescriptionLabel.text = item.description
    }
}
