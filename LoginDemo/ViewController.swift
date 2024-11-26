//
//  ViewController.swift
//  LoginDemo
//
//  Created by Adam Chen on 2024/11/25.
//

import UIKit
import FacebookCore
import FacebookLogin
import GoogleSignIn
import AuthenticationServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
    }

    
    @IBAction func loginByFacebookButton(_ sender: UIButton) {
        let loginManager = LoginManager()
        guard let configuration = LoginConfiguration(permissions: ["public_profile", "email"], tracking: .limited, nonce: "123") else { return }
        
        loginManager.logIn(configuration: configuration) { result in
            switch result {
            case .cancelled, .failed:
                return
            case .success:
                let id = Profile.current?.userID
                let name = Profile.current?.name
                let email = Profile.current?.email
                
                print("id:\(String(describing: id))")
                print("name:\(String(describing: name))")
                print("email:\(String(describing: email))")

            }
        }
    }
    
    @IBAction func loginByGoogleButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let result = signInResult else { return }
            // If sign in succeeded, display the app's main content View.
            let user = result.user
            
            let id = user.userID
            let name = user.profile?.name
            let email = user.profile?.email
            
            print("id:\(String(describing: id))")
            print("name:\(String(describing: name))")
            print("email:\(String(describing: email))")
            
        }
    }
    
    @IBAction func loginByAppleButton(_ sender: UIButton) {
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

extension ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let id = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("id:\(String(describing: id))")
            print("fullName:\(String(describing: fullName))")
            print("email:\(String(describing: email))")
        }
    }
}

