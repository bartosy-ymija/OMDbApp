//
//  Button.swift
//  CoreUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import UIKit

/// Generic button used in the app.
public final class Button: UIView {

    // MARK: Properties

    /// Title of the button.
    var title: String? {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }

    /// Action which should be performed on touch up inside.
    var action: (() -> Void)?

    public override var intrinsicContentSize: CGSize {
        button.intrinsicContentSize
    }

    // MARK: Private properties

    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(red: 0.36, green: 0.419, blue: 0.752, alpha: 1.0)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    // MARK: Initializers

    /// Initializes the receiver.
    public init() {
        super.init(frame: .zero)
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setupHierarchy() {
        addSubview(button)
    }

    private func setupConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc private func didTapButton() {
        action?()
    }
}
