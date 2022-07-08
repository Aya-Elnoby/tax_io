//
//  AuthManager.swift
//  taxi
//
//  Created by Fatema Sherif on 4/28/22.
//


import Foundation
import FirebaseAuth


class AuthManager{
    static let shared = AuthManager()
    private let auth = Auth.auth()

    private var verficationId: String?

    public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void){
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil){ [weak self] verficationId, error in
            guard let verficationId = verficationId, error == nil else {
                completion(false)
                return
            }
            self?.verficationId = verficationId
            completion(true)
        }
    }

    public func verfiyCode(smsCode: String, completion: @escaping (Bool) -> Void){
        guard let verficationId = verficationId else {
                completion(false)
                return
            }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verficationId, verificationCode: smsCode)

        auth.signIn(with: credential ) { result, error in
            guard result != nil, error == nil else{
                completion(false)
                return
            }
            completion(true)
        }

        }
   
}
