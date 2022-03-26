//
//  NewToDoViewController.swift
//  ToDo List
//
//  Created by Felipe Brigagão de Almeida on 26/03/22.
//

import UIKit

class NewToDoViewController: UIViewController {
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        
        button.addTarget(self, action: #selector(closeScene), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New ToDo"

        view.backgroundColor = .systemBackground
        view.addSubview(closeButton)
        setupConstraints()
        
    }
    
    @objc private func closeScene() {
        dismiss(animated: true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -15)
        ])
    }
}
