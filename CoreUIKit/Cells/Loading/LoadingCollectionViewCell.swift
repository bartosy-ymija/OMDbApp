//
//  LoadingCollectionViewCell.swift
//  CoreUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import UIKit

/// Cell presenting an activity indicator.
public final class LoadingCollectionViewCell: UICollectionViewCell {

    // MARK: Properties

    public static let identifier = "LoadingCollectionViewCellIdentifier"

    private let activityIndicator = UIActivityIndicatorView(style: .gray)

    // MARK: Initializers

    /// Initalizes the receiver.
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(activityIndicator)
        activityIndicator.center = contentView.center
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Methods

    public func start() {
        activityIndicator.startAnimating()
    }
}
