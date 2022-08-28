//
//  SMSCodeViewController.swift
//  PhoneAuthWithFirebase
//
//  Created by Mishana on 27.08.2022.
//

import UIKit

class SMSCodeViewController: UIViewController, UITextFieldDelegate {

    private let mask = MaskNumber()
    
    private let smsField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .secondarySystemBackground
        field.placeholder = "XXX-XXX"
        field.returnKeyType = .continue
        field.textAlignment = .center
        field.keyboardType = .numberPad
        return field
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.configuration = .tinted()
        button.setTitle("Verify Code", for: .normal)
        button.configuration?.baseForegroundColor = .systemGray
        button.configuration?.baseBackgroundColor = .systemGray
        button.setImage(UIImage(systemName: "lock.open.iphone"), for: .normal)
        button.configuration?.imagePadding = 15
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(codeClick), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Enter code"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        addButtonConstraints()
        addTextFieldConstraints()
    }
    
    
    @objc func codeClick() {
        textFieldShouldReturn(smsField)
    }
    
    func textField(_ smsField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let text = smsField.text else {return false}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        smsField.text = mask.formatter(mask: "XXX-XXX", phoneNumber: newString)
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty {
            let changeCode = text.filter{$0 != "-"}
            let code = "\(changeCode)"
            AuthManager.shared.verfyCode(smsCode: code) { [weak self] success in
                if success{
                    let vc = UserViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: nil)
                } else {
                    self?.smsField.text = ""
                    let alert = UIAlertController(title: "Ошибка", message: "Некорректный код, введите проверьте правильность кода и попробуйте заново.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(action)
                    self?.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        return true
    }
}

extension SMSCodeViewController {
    private func addButtonConstraints() {
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
        view.addSubview(smsField)
        smsField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            smsField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            smsField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            smsField.widthAnchor.constraint(equalToConstant: 300),
            smsField.heightAnchor.constraint(equalToConstant: 80)
        ])
        smsField.delegate = self
    }
}
