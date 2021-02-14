//
//  SearchBar.swift
//  CoreUIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import UIKit

/// Search bar which enables entering queries.
public final class SearchBar: UIView {

    // MARK: Properties

    /// Handler providing text updates.
    public var textChangeHandler: ((String) -> Void)?

    // MARK: Private properties

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true
        return textField
    }()

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        return view
    }()

    public static let height = CGFloat(40)

    // MARK: Initializers

    public init() {
        super.init(frame: .zero)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Private properties

    private func setupHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(textField)
    }

    private func setupConstraints() {
        [
            backgroundView,
            textField
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),

            textField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -8),
            textField.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
    }

    @objc private func didChangeText() {
        textChangeHandler?(textField.text ?? "")
    }
}
