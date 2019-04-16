//
//  LoginViewController.swift
//  iOSVjestina2019
//
//  Created by Jelena Šarić on 05/04/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit

/// Class which presents view controller for Login interface.
class LoginViewController: UIViewController {
    
    /// Login url.
    static let loginUrl = "https://iosquiz.herokuapp.com/api/session"
    /// Error message.
    static let errorMessage = "Neispravno korisničko ime i/ili lozinka!"
    
    /// Username text field.
    @IBOutlet weak var usernameField: UITextField!
    /// Password text field.
    @IBOutlet weak var passwordField: UITextField!
    /// Information label.
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBAction func loginTapped() {
        guard let username = usernameField.text,
              let password = passwordField.text else {
           
                return
        }
        
        LoginService().establishSession(
        urlString: LoginViewController.loginUrl,
        username: username,
        password: password)
        { (token) in
            if let unwrappedToken = token {
                UserDefaults.standard.set(unwrappedToken, forKey: "accessToken")
                DispatchQueue.main.async {
                    self.infoLabel.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.infoLabel.isHidden = false
                    self.infoLabel.text = LoginViewController.errorMessage
                }
            }
        }
    }
}
