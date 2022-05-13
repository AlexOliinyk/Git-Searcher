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
    case goToRepositoryDetails(RepositoryDetailsState)
    case dismissRepositoryDetails
    case details(RepositoryDetailsAction)
//    case testProgramNavigation
    case showRecentRepository
    case dismissRecentRepository
}
