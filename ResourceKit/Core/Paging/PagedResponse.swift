//
//  PagedResponse.swift
//  ResourceKit
//
//  Created by Bartosz Żmija on 10/02/2021.
//

/// Entity representing a one page in a set of paged results.
public struct PagedResponse<ItemType> {
    /// Items associated with this page.
    let items: [ItemType]
    /// A total count of all items.
    let totalCount: Int

    public init(items: [ItemType], totalCount: Int) {
        self.items = items
        self.totalCount = totalCount
    }

    /// Maps the paged response to other type.
    /// - Parameters:
    ///   - transform: Method describing how the item should be changed.
    func map<TargetItemType>(_ transform: (ItemType) -> TargetItemType) -> PagedResponse<TargetItemType> {
        PagedResponse<TargetItemType>(items: items.map(transform), totalCount: totalCount)
    }
}
