//
//  MovieDetailsView.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 12/02/2021.
//

import UIKit
import CoreUIKit
import RxCocoa
import RxSwift

/// View displayed on the movie details screen.
final class MovieDetailsView: UIView {

    // MARK: Private properties

    private let scrollView = UIScrollView()

    private let containerView = UIView()

    private let closeContainerView = UIView()

    private let statusContainerView = UIView()

    private let activityIndicator = UIActivityIndicatorView(style: .gray)

    private var activityIndicatorContainerViewHeightConstraint: NSLayoutConstraint?

    private lazy var errorView = ErrorView(
        configuration: .init(
            title: "We couldn't download the details of this movie at this time. Please try again.",
            buttonTitle: "Try again",
            buttonAction: { [unowned self] in self.reloadRelay.accept(()) }
        )
    )

    fileprivate let closeButton: UIButton = {
        let button = UIButton()
        guard let image = UIImage(named: "Close", in: Bundle(for: MovieDetailsView.self), compatibleWith: nil) else {
          fatalError("Missing close image.")
        }
        button.tintColor = .black
        button.setImage(image, for: .normal)
        return button
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private let headerView = MovieHeaderView(
        configuration: .init(
            titleFontSize: 24,
            yearFontSize: 16
        )
    )

    private let descriptionView = MovieDescriptionView()

    private let castContainerView = MovieCastContainerView()

    private lazy var loadedViews = [
        descriptionView,
        castContainerView
    ]

    fileprivate let reloadRelay = PublishRelay<Void>()

    // MARK: Initializers

    /// Initializes the receiver.
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupHierarchy()
        setupConstraints()
        loadedViews.forEach {
            $0.alpha = 0
            $0.isHidden = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorContainerViewHeightConstraint?.constant = bounds.height - bounds.width * 0.8 - safeAreaInsets.bottom
    }

    // MARK: Private methods

    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        [
            contentStackView
        ].forEach(containerView.addSubview)
        closeContainerView.addSubview(closeButton)
        if #available(iOS 13, *) {} else {
            contentStackView.addArrangedSubview(closeContainerView)
        }
        [
            activityIndicator,
            errorView
        ].forEach(statusContainerView.addSubview)
        [
            headerView,
            statusContainerView,
            descriptionView,
            castContainerView
        ].forEach(contentStackView.addArrangedSubview)
    }

    private func setupConstraints() {
        [
            scrollView,
            contentStackView,
            containerView,
            closeContainerView,
            closeButton,
            activityIndicator,
            errorView
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor),

            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.trailingAnchor.constraint(equalTo: closeContainerView.trailingAnchor, constant: -8),
            closeButton.topAnchor.constraint(equalTo: closeContainerView.topAnchor, constant: 8),
            closeButton.bottomAnchor.constraint(equalTo: closeContainerView.bottomAnchor, constant: -8),

            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor),

            headerView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),

            activityIndicator.centerXAnchor.constraint(equalTo: statusContainerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: statusContainerView.centerYAnchor),

            errorView.leadingAnchor.constraint(equalTo: statusContainerView.leadingAnchor, constant: 8),
            errorView.trailingAnchor.constraint(equalTo: statusContainerView.trailingAnchor, constant: -8),
            errorView.centerYAnchor.constraint(equalTo: statusContainerView.centerYAnchor),
        ])
        activityIndicatorContainerViewHeightConstraint = statusContainerView.heightAnchor.constraint(equalToConstant: 0)
        activityIndicatorContainerViewHeightConstraint?.isActive = true
    }

    fileprivate func bind(state: MovieDetailsState) {
        switch state {
        case let .header(header):
            headerView.bind(header: header)
            errorView.isHidden = true
            activityIndicator.startAnimating()
        case let .failure(header):
            headerView.bind(header: header)
            errorView.isHidden = false
            activityIndicator.stopAnimating()
        case let .complete(header, details):
            statusContainerView.isHidden = true
            headerView.bind(header: header)
            descriptionView.bind(description: details)
            castContainerView.bind(cast: details)
            loadedViews.forEach { $0.isHidden = false }
            UIView.animate(withDuration: 0.2) {
                self.loadedViews.forEach {
                    $0.alpha = 1
                }
            }
        }
    }
}

// MARK: Reactive extensions
extension Reactive where Base == MovieDetailsView {
    /// Sink for the state of the movies list.
    var state: Binder<MovieDetailsState> {
        Binder(base) { view, state in
            view.bind(state: state)
        }
    }
    /// Emits close events.
    var closeTrigger: Observable<Void> {
        base.closeButton.rx.tap.asObservable()
    }
    /// Emits events when the view should be reloaded.
    var reloadTrigger: Observable<Void> {
        base.reloadRelay.asObservable()
    }
}
