//
//  LoginViewController.swift
//  BellTest
//
//  Created by Esteban on 2020-02-03.
//  Copyright © 2020 Transcriptics. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    var errorLabel = UILabel(frame: .zero)
    var titleLabel = UILabel(frame: .zero)
    var signInButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        configureUI()
        configureTitle()
        configureError()
        configureSignInButton()
    }
       
    func configureUI() {
        view.backgroundColor = .black
        view.addSubview(titleLabel)
        view.addSubview(signInButton)
        view.addSubview(errorLabel)
    }
    
    func configureTitle() {
        titleLabel.backgroundColor = .clear
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 26.0)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "Welcome to Esteban's Test"

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -60.0).isActive = true
    }
    
    func configureError() {
        errorLabel.backgroundColor = .red
        errorLabel.textColor = .white
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
    }
    
    func configureSignInButton() {
        signInButton.style = .wide
        signInButton.colorScheme = .dark
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    }
        
    func displayError(message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) { [weak self] in
            self?.errorLabel.text = ""
            self?.errorLabel.isHidden = true
        }
    }
}

