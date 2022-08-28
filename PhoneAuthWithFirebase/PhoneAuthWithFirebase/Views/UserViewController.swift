//
//  UserViewController.swift
//  PhoneAuthWithFirebase
//
//  Created by Mishana on 27.08.2022.
//
import FirebaseAuth
import UIKit

class UserViewController: UIViewController {
    
    
    private let button: UIButton = {
        let button = UIButton()
        button.configuration = .tinted()
        button.setTitle("Log Out", for: .normal)
        button.configuration?.baseForegroundColor = .systemGray
        button.configuration?.baseBackgroundColor = .systemGray
        button.setImage(UIImage(systemName: "lock"), for: .normal)
        button.configuration?.imagePadding = 15
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logoutClick), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Mikki White"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = .nextBtn(target: self, action: #selector(logoutClick))
        navigationItem.rightBarButtonItem?.title = "Log Out"
        navigationItem.rightBarButtonItem?.tintColor = .systemGray
        addButtonConstraints()
    }
    
}

extension UIBarButtonItem {

    static func nextBtn(target: AnyObject, action: Selector) -> UIBarButtonItem {
        let title = "Log Out"
        return button(title: title, target: target, action: action)
    }

    private static func button(title: String, target: AnyObject, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: .done, target: target, action: action)
    }

}

extension UserViewController {
    
    private func addButtonConstraints() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 220),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func logoutClick() {
        AuthManager.shared.logout()
        let vc = PhoneNumberViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
