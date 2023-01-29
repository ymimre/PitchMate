//
//  LoginViewController.swift
//  PitchMate
//
//  Created by Yusuf Mert İmre on 27.12.2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        validatePhoneNumberWithDefault()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        validatePhoneNumber(phoneNumberTextField)
    }
    
    
    func validatePhoneNumberWithDefault() -> Bool {
        if let number = UserDefaults.standard.string(forKey: "defaultPhoneNumber")  {
            AuthenticatePhoneNumber.shared.startAuthentication(phoneNumber: number ) { [weak self] success in
                guard success else { return }
                self!.goToSMSCodeScreen()
            }
        }
        return true
    }
    
    func validatePhoneNumber(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let inputText = textField.text, !inputText.isEmpty {
            let number = "+90\(inputText)"
            UserDefaults.standard.set(number, forKey: "defaultPhoneNumber")
            AuthenticatePhoneNumber.shared.startAuthentication(phoneNumber: number) { [weak self] success in
                guard success else { return }
                
                self!.goToSMSCodeScreen()
            }
        }
        
        return true
    }
    
    func goToSMSCodeScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let codeViewController = storyBoard.instantiateViewController(withIdentifier: "code")
        codeViewController.modalPresentationStyle = .overFullScreen
        self.present(codeViewController, animated: true)
    }
}
