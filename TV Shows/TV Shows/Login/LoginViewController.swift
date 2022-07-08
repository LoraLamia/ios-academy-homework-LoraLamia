//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2022..
//

import UIKit

class LoginViewController: UIViewController {

    var counter = 0
    
    @IBOutlet weak var numberOfClicks: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfClicks.text = "Number of clicks: \(counter)"
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        counter+=1
        numberOfClicks.text = "Number of clicks: \(counter)"
    }
}
