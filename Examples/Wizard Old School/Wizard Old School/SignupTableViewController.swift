//
//  SignupTableViewController.swift
//  Wizard Old School
//
//  Created by Mike Runnals on 2/24/21.
//

import UIKit

class SignupTableViewController: UITableViewController {
    
    @IBOutlet weak var wizardNameButton: UIButton!
    @IBOutlet weak var passwordLockButton: UIButton!
    @IBOutlet weak var passwordAgainLockButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Replace the system person.circle with a app provided asset since iOS 12.4 get nil for these (SF Symbols only exist in iOS 13+
        SignupTableViewController.handleMissingIcon(wizardNameButton, "Name")
        SignupTableViewController.handleMissingIcon(passwordLockButton, "Passwd")
        SignupTableViewController.handleMissingIcon(passwordAgainLockButton, "Passwd")
    }
    
    static func handleMissingIcon(_ button: UIButton, _ replacement: String) {
        if button.currentImage == nil {
            button.setTitle(replacement, for: .normal)
            button.setTitleColor(.black, for: .normal)
        }
    }

}
