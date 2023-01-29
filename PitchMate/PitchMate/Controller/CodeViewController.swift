//
//  SMSCodeViewController.swift
//  PitchMate
//
//  Created by user229720 on 28.12.2022.
//

import UIKit

class CodeViewController: UIViewController {

    @IBOutlet weak var smsCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        validateCode(smsCodeTextField)
    }

    func validateCode(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let inputText = textField.text, !inputText.isEmpty {
            let code = inputText
            AuthenticatePhoneNumber.shared.verifyCode(smsCode: code) { [weak self] success in
                guard success else { return }
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let mainScreenViewController = storyBoard.instantiateViewController(withIdentifier: "mainscreen")
                mainScreenViewController.modalPresentationStyle = .overFullScreen
                self!.present(mainScreenViewController, animated: true)
            }
        }
        
        return true
    }
}
