
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
