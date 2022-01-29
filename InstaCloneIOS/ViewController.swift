//
//  ViewController.swift
//  InstaCloneIOS
//
//  Created by serhat on 29.01.2022.
//

import UIKit
import SwiftUI
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var edtEmail: UITextField!
    @IBOutlet weak var edtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        if edtEmail.text != "" && edtPassword.text != ""{
            Auth.auth().signIn(withEmail: edtEmail.text!, password: edtPassword.text!) { authData, error in
                
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
                    return
                }
                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
            }
            
        }
       
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if edtEmail.text != "" && edtPassword.text != "" {
            Auth.auth().createUser(withEmail: edtEmail.text!, password: edtPassword.text!) { authData, error in
                
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "toFeedVC",sender: nil)
                }
            }
        }else{
            makeAlert(titleInput: "Error", messageInput: "Please enter your email and password!")
        }
    }
    
    func makeAlert(titleInput:String,messageInput:String){
        let alert =  UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated:true,completion:nil)
        
    }
}



