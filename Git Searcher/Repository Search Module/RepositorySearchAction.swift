//
//  RepositorySearchAction.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 25.04.2022.
//

import Foundation
import ComposableArchitecture

enum SearchError: Error {
    case downloadError
    case decodingError
}

enum RepositorySearchAction: Equatable {
    
    case search(String)
    case dataIsLoaded(Result<[RepositoryModel], SearchError>)
}

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
