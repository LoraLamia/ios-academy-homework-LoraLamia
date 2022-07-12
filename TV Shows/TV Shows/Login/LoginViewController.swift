//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2022..
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var counterLabel: UILabel!
    
    // MARK: Properties
    
    private var counter = 0
    
    // MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: Actions
    
    @IBAction private func buttonClicked() {
        counter += 1
        counterLabel.text = "Number of clicks: \(counter)"
        if counter % 2 == 0 {
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }
    }
    
    // MARK: Utility methods
    
    private func setup(){
        counterLabel.text = "Number of clicks: \(counter)"
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.spinner.stopAnimating()
        }
    }
}
