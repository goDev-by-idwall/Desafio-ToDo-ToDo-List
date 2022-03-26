//
//  ToDoTableViewCell.swift
//  ToDo List
//
//  Created by Felipe Brigagão de Almeida on 26/03/22.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    static let identifier = "ToDoTableViewCell"
    
    lazy var taskImage: UIImageView = {
        let image = UIImageView()
        
        image.image = UIImage(systemName: "checkmark.circle.fill")
        image.tintColor = .green
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    lazy var taskLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Task"
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(taskImage)
        addSubview(taskLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            taskImage.widthAnchor.constraint(equalToConstant: 30),
            taskImage.heightAnchor.constraint(equalToConstant: 30),
            taskImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            taskImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            taskLabel.leadingAnchor.constraint(equalTo: taskImage.trailingAnchor, constant: 15),
            taskLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            taskLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            taskLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
}
