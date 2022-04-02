//
//  NoCameraView.swift
//  VeriffI
//
//  Created by Christopher Alford on 30/3/22.
//

import UIKit

class NoCameraView: UIView {
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = message
        return label
    }()

    var title: String = "Title"
    var message = "Message"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addSubview(stack)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(messageLabel)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            stack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8),
            stack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8)
        ])
    }
    
    override func layoutSubviews() {
        titleLabel.text = title
        messageLabel.text = message
    }
}
