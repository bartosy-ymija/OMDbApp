//
//  MoviesListView.swift
//  MoviesUIKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

import UIKit
import CoreUIKit
import RxCocoa
import RxSwift
import RxDataSources

/// View displayed on the movies list screen.
final class MoviesListView: UIView {

    // MARK: Private properties

    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(
            MoviesListMovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MoviesListMovieCollectionViewCell.identifier
        )
        collectionView.register(
            LoadingCollectionViewCell.self,
            forCellWithReuseIdentifier: LoadingCollectionViewCell.identifier
        )
        collectionView.register(
            ErrorCollectionViewCell.self,
            forCellWithReuseIdentifier: ErrorCollectionViewCell.identifier
        )
        return collectionView
    }()

    private lazy var searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.textChangeHandler = { [unowned self] text in
            self.searchQueryRelay.accept(text)
        }
        return searchBar
    }()

    private let emptyContentView: TitledImageView = {
        guard let image = UIImage(named: "Empty Content", in: Bundle(for: MoviesListView.self), compatibleWith: nil) else {
          fatalError("Missing empty content image.")
        }
        let view = TitledImageView(
            configuration: .init(
                title: "Oops... We couldn't find any movies for your query!",
                image: image
            )
        )
        return view
    }()

    private let tooManyResultsView: TitledImageView = {
        guard let image = UIImage(named: "Too Many Results", in: Bundle(for: MoviesListView.self), compatibleWith: nil) else {
          fatalError("Missing too many results image.")
        }
        let view = TitledImageView(
            configuration: .init(
                title: "There are too many results for your query, try narrowing it down!",
                image: image
            )
        )
        return view
    }()

    private lazy var errorView = ErrorView(
        configuration: .init(
            title: "We couldn't load movies for your query at this time. Please try again later.",
            buttonTitle: "Try again",
            buttonAction: { self.reloadRelay.accept(()) }
        )
    )

    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray)

    fileprivate let reloadRelay = PublishRelay<Void>()

    fileprivate let searchQueryRelay = BehaviorRelay<String>(value: "")

    fileprivate let nextPageRelay = PublishRelay<Void>()

    fileprivate let selectedMovieRelay = PublishRelay<MovieHeaderRepresentable>()

    private let collectionViewItemsRelay = BehaviorRelay<[CollectionViewItem]>(value: [])

    private let disposeBag = DisposeBag()

    private static let nextPageThreshold = CGFloat(100)

    // MARK: Initializers

    /// Initializes the receiver.
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupHierarchy()
        setupConstraints()
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("Please initialize this object from code.")
    }

    // MARK: Methods

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        collectionView.contentInset = .init(top: 0, left: 8, bottom: -safeAreaInsets.bottom, right: 8)
    }

    // MARK: Private methods

    private func setupHierarchy() {
        [
            collectionView,
            searchBar,
            emptyContentView,
            errorView,
            activityIndicator,
            tooManyResultsView
        ].forEach(addSubview)
    }

    private func setupConstraints() {
        [
            collectionView,
            searchBar,
            emptyContentView,
            errorView,
            activityIndicator,
            tooManyResultsView
        ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: SearchBar.height),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            emptyContentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            emptyContentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            emptyContentView.centerYAnchor.constraint(equalTo: centerYAnchor),

            tooManyResultsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            tooManyResultsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            tooManyResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),

            errorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            errorView.centerYAnchor.constraint(equalTo: centerYAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupBindings() {
        let dataSource = self.dataSource()
        collectionViewItemsRelay
            .map { [CollectionViewItemSectionModel(items: $0)] }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        collectionView.rx.contentOffset
            .map { $0.y }
            .filter { $0 != 0 }
            .filter { [unowned self] in self.collectionView.contentSize.height - self.collectionView.bounds.height - $0 <= MoviesListView.nextPageThreshold }
            .map { _ in () }
            .bind(to: nextPageRelay)
            .disposed(by: disposeBag)
    }

    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<CollectionViewItemSectionModel> {
        RxCollectionViewSectionedReloadDataSource<CollectionViewItemSectionModel> { dataSource, collectionView, indexPath, item in
            let collectionViewCell: UICollectionViewCell?
            switch item {
            case let .movie(movieItem):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesListMovieCollectionViewCell.identifier, for: indexPath) as? MoviesListMovieCollectionViewCell
                cell?.bind(movie: movieItem)
                collectionViewCell = cell
            case .loading:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.identifier, for: indexPath) as? LoadingCollectionViewCell
                cell?.start()
                collectionViewCell = cell
            case .failure:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ErrorCollectionViewCell.identifier, for: indexPath) as? ErrorCollectionViewCell
                cell?.bind(
                    configuration: .init(
                        message: "We couldn't load next page.",
                        buttonTitle: "Try again",
                        buttonAction: { [unowned self] in self.nextPageRelay.accept(()) })
                )
                collectionViewCell = cell
            }
            return collectionViewCell ?? UICollectionViewCell()
        }
    }

    @objc private func didTapView() {
        searchBar.endEditing(true)
    }

    fileprivate func bind(state: MoviesListState) {
        toggleVisibility(using: state)
        updateItems(using: state)
    }

    private func toggleVisibility(using state: MoviesListState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            emptyContentView.isHidden = true
            errorView.isHidden = true
            tooManyResultsView.isHidden = true
            collectionView.isHidden = true
        case .failure(let error):
            activityIndicator.stopAnimating()
            emptyContentView.isHidden = true
            errorView.isHidden = error != .listNotLoaded
            tooManyResultsView.isHidden = error != .tooManyResults
            collectionView.isHidden = true
        default:
            activityIndicator.stopAnimating()
            emptyContentView.isHidden = !state.items.isEmpty
            errorView.isHidden = true
            tooManyResultsView.isHidden = true
            collectionView.isHidden = state.items.isEmpty
        }
    }

    private func updateItems(using state: MoviesListState) {
        var items = state.items.map { CollectionViewItem.movie($0) }
        switch state {
        case .partialLoading:
            items.append(.loading)
        case .partialFailure:
            items.append(.failure)
        default:
            break
        }
        collectionViewItemsRelay.accept(items)
    }

    // MARK: Enums

    enum CollectionViewItem {
        case movie(MovieHeaderRepresentable)
        case failure
        case loading
    }

    // MARK: Structs

    struct CollectionViewItemSectionModel: SectionModelType {
        init(items: [CollectionViewItem]) {
            self.items = items
        }
        init(original: MoviesListView.CollectionViewItemSectionModel, items: [CollectionViewItem]) {
            self.items = items
        }
        typealias Item = CollectionViewItem
        let items: [CollectionViewItem]
    }
}

// MARK: UICollectionViewDelegateFlowLayout conformance
extension MoviesListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = collectionViewItemsRelay.value[indexPath.item]
        switch item {
        case .movie:
            let collectionViewWidth = collectionView.bounds.width
            let width = (collectionViewWidth - (collectionView.contentInset.right + collectionView.contentInset.left) * 2) / 2
            return CGSize(width: width, height: width * 1.4)
        case .loading:
            return CGSize(width: collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right, height: 50)
        case .failure:
            return CGSize(width: collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right, height: 100)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionViewItemsRelay.value[indexPath.item]
        switch item {
        case let .movie(movie):
            searchBar.endEditing(true)
            selectedMovieRelay.accept(movie)
        default:
            break
        }
    }
}

// MARK: Reactive extensions
extension Reactive where Base == MoviesListView {
    /// Emits events when the content should be reloaded.
    var reloadTrigger: Observable<Void> {
        base.reloadRelay.asObservable()
    }
    /// Emits query from the search bar.
    var searchQuery: Observable<String> {
        base.searchQueryRelay.asObservable()
    }
    /// Emits events  when the new page should be requested.
    var nextPageTrigger: Observable<Void> {
        base.nextPageRelay.asObservable()
    }
    /// Emits selected movies.
    var movieSelected: Observable<MovieHeaderRepresentable> {
        base.selectedMovieRelay.asObservable()
    }
    /// Sink for the state of the movies list.
    var state: Binder<MoviesListState> {
        Binder(base) { view, state in
            view.bind(state: state)
        }
    }
}
