//
//  PhoneNumberViewController.swift
//  PhoneAuthWithFirebase
//
//  Created by Mishana on 27.08.2022.
//

import UIKit

class PhoneNumberViewController: UIViewController {
    
    let mask = MaskNumber()
    
    private let phoneField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "+7(XXX)XXX-XX-XX"
        field.returnKeyType = .continue
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.layer.cornerRadius = 10
        return field
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.configuration = .tinted()
        button.setTitle("Sign in", for: .normal)
        button.configuration?.baseForegroundColor = .systemGray
        button.configuration?.baseBackgroundColor = .systemGray
        button.setImage(UIImage(systemName: "iphone.and.arrow.forward"), for: .normal)
        button.configuration?.imagePadding = 15
//        button.backgroundColor =
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Enter phone"
        navigationController?.navigationBar.prefersLargeTitles = true
    
        addTextFieldConstraints()
        addButtonConstraints()
        
    }
    
    @objc func onClick() {
        textFieldShouldReturn(phoneField)
    }
}

extension PhoneNumberViewController: UITextFieldDelegate {
    func textField(_ phoneField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let text = phoneField.text else {return false}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        phoneField.text = mask.formatter(mask: "+X (XXX)XXX-XX-XX", phoneNumber: newString)
        return false
    }

    
    
    
    

     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            let editNumber = text.filter{ $0 != "-" && $0 != "(" && $0 != ")" && $0 != " "}
            let checkNum = text.filter {$0 != "+"}.first ?? "0"
            let number = "\(editNumber)"
            if number.count == 12 && checkNum == "7" {
                AuthManager.shared.startAuth(phoneNumber: number) { [weak self] success in
                    guard success else {return}
                    DispatchQueue.main.async {
                        let vc = SMSCodeViewController()
                        self?.navigationController?.pushViewController(vc, animated: true)
                        self?.phoneField.text = ""
                    }
                }
            }else {
                phoneField.text = ""
                let alert = UIAlertController(title: "Ошибка", message: "Некорректный номер, введите номер правильно и попробуйте заново.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
        }
        
        return true
    }
    
}


extension PhoneNumberViewController {
    private func addButtonConstraints () {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -350),
            button.widthAnchor.constraint(equalToConstant: 220),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addTextFieldConstraints() {
        view.addSubview(phoneField)
        phoneField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            phoneField.widthAnchor.constraint(equalToConstant: 300),
            phoneField.heightAnchor.constraint(equalToConstant: 80)
        ])
        phoneField.delegate = self
    }
}
