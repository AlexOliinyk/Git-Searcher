//
//  RepositorySearchReducer.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 27.04.2022.
//

import Foundation
import ComposableArchitecture

let searchReducer = Reducer<SearchState, RepositorySearchAction, SearchEnvironment> { state, action, environment in
    
    switch action {
    case .search(let searchText):
        
        struct MyRepositoryID: Hashable {}
        
        state.searchText = searchText
        if searchText.isEmpty {
            state.status = .idle
            return .none
        }
        state.status = .loading
        return environment
            .repositorySearch(searchText)
        //            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(RepositorySearchAction.dataIsLoaded)
            .debounce(id: MyRepositoryID(), for: .seconds(0.5), scheduler: environment.mainQueue)
    case .dataIsLoaded(let result):
        switch result {
        case .success(let results):
            if results.count > 0 {
                state.status = .dataLoaded(results)
            } else {
                state.status = .emptyResult
            }
        case .failure(let error):
            state.status = .error(error)
        }
        return .none
    }
}
    .debug()
