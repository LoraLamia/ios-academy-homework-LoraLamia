//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by Infinum on 25.07.2022..
//

import UIKit

class WriteReviewViewController: UIViewController {
    
    
    @IBOutlet weak var ratingView: RatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ratingView.configure(withStyle: .small)
                ratingView.isEnabled = true

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
