//
//  RepositorySearchState.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 27.04.2022.
//

import Foundation
import ComposableArchitecture

struct SearchState: Equatable {
    var searchText: String = ""
    var status: Status = .idle
    
    enum Status: Equatable {
        case idle
        case loading
        case dataLoaded([RepositoryModel])
        case emptyResult
        case error(SearchError)
    }
}
