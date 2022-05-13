//
//  RepositorySearchState.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 27.04.2022.
//

import Foundation
import ComposableArchitecture

struct RepositorySearchState: Equatable {
    var searchText: String = ""
    var selectedDetailsState: RepositoryDetailsState?
    var recentRepository: RepositoryDetailsState?
    var isShowingRecentRepository = false
    var status: Status = .idle
    
    enum Status: Equatable {
        case idle
        case loading
        case dataLoaded([RepositoryModel])
        case emptyResult
        case error(SearchError)
    }
}
