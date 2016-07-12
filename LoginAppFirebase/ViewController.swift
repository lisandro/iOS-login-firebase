//
//  ViewController.swift
//  LoginAppFirebase
//
//  Created by Lisandro Falconi on 7/11/16.
//  Copyright © 2016 Lisandro Falconi. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = FIRAuth.auth()?.currentUser {
            self.logoutButton.alpha = 1.0
            self.userNameLabel.text = user.email
        } else {
            self.logoutButton.alpha = 0.0
            self.userNameLabel.text = ""
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK - Buttons actions
    @IBAction func createAccountAction(sender: AnyObject) {
        if requiredFieldsAreNotEmpty() {
            FIRAuth.auth()?.createUserWithEmail(self.emailField.text!, password: self.passwordField.text!, completion: {
                    user, error in

                    if error == nil {
                        self.updateUIElements(user)
                    } else {
                        let alertController = self.createErrorAlert(nil, message: (error?.localizedDescription)!)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
            })
        } else {
            let alertController = createErrorAlert(nil, message: "Please enter an email and password")
            self.presentViewController(alertController, animated: true, completion: nil)
        }

    }
    @IBAction func loginAction(sender: AnyObject) {
        if requiredFieldsAreNotEmpty() {
            FIRAuth.auth()?.signInWithEmail(self.emailField.text!, password: self.passwordField.text!, completion: {
                    user, error in

                    if error == nil {
                        self.updateUIElements(user)

                    } else {
                        let alertController = self.createErrorAlert(nil, message: (error?.localizedDescription)!)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
            })
        } else {
            let alertController = createErrorAlert(nil, message: "Please enter an email and password")
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func logoutAction(sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()

        self.userNameLabel.text = ""
        self.logoutButton.alpha = 0.0
        self.emailField.text = ""
        self.passwordField.text = ""
    }

    func createErrorAlert(title: String?, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title ?? "Bad news", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(defaultAction)
        return alertController
    }

    func requiredFieldsAreNotEmpty() -> Bool {
        return !(self.emailField.text == "" || self.passwordField.text == "")
    }

    func updateUIElements(user: FIRUser?) -> Void {
        self.logoutButton.alpha = 1.0
        self.userNameLabel.text = user?.email
        self.emailField.text = ""
        self.passwordField.text = ""
    }
}
