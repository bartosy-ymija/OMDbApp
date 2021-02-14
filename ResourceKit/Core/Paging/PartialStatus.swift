//
//  PartialStatus.swift
//  ResourceKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

/// Valid partial status.
public enum PartialStatus<Failure: Error>: Equatable {
    /// Partial items are loaded.
    case loading
    /// Partial items returned a failure.
    case failure(Failure)

    public static func ==(lhs: PartialStatus<Failure>, rhs: PartialStatus<Failure>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }
}
