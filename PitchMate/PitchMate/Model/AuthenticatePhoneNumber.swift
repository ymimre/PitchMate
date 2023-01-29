//
//  AuthenticatePhoneNumber.swift
//  PitchMate
//
//  Created by Yusuf Mert İmre on 27.12.2022.
//

import Foundation
import FirebaseAuth

class AuthenticatePhoneNumber {
    
    static let shared = AuthenticatePhoneNumber()
    private let auth = Auth.auth()
    private var verificationId: String?
    
    public func startAuthentication(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) {
            [weak self] verificationId, error in
            guard let verificationId = verificationId, error == nil else {
                completion(false)
                return
            }
            self?.verificationId = verificationId
            completion(true)
        }
    }
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
        guard let verificationId = verificationId else {
            completion(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationId,
            verificationCode: smsCode)
        
        auth.signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
}
