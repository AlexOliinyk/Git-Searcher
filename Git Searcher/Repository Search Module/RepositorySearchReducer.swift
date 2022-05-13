//
//  RepositorySearchReducer.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 27.04.2022.
//

import Foundation
import ComposableArchitecture

let searchReducer: Reducer<RepositorySearchState, RepositorySearchAction, SearchEnvironment> = .combine(
    
    repositoryDetailsReducer.optional().pullback(
        state: \.recentRepository,
        action: /RepositorySearchAction.details,
        environment: { _ in
            RepositoryDetailsEnvironment(getReadMe: readMeEffect, mainQueue: .main)
        }
    ),
    
    repositoryDetailsReducer.optional().pullback(
        state: \.selectedDetailsState,
        action: /RepositorySearchAction.details,
        environment: { _ in
            RepositoryDetailsEnvironment(getReadMe: readMeEffect, mainQueue: .main)
        }
    ),
    
    Reducer { state, action, environment in
        
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
        case .details(let action):
            print(action)
            return .none
        case .goToRepositoryDetails(let detailsState):
            state.selectedDetailsState = detailsState
            state.recentRepository = detailsState
            return .none
        case .dismissRepositoryDetails:
            state.selectedDetailsState = nil
            return .none
        case .showRecentRepository:
            state.isShowingRecentRepository = true
            return .none
        case .dismissRecentRepository:
            state.isShowingRecentRepository = false
            return .none
//        case .testProgramNavigation:
//            state.selectedDetailsState = .init(model: .init(id: 1, name: "SwiftUI", forksCount: 45, stargazersCount: 345, watchersCount: 2, owner: .init(id: 324, login: "Apple", name: "Swift", followers: 352, following: 23, bio: "fdfds fwef fsfewf", location: "Kyiv, Ukraine", htmlUrl: "", blog: ""), language: "Swift"))
//            return .none
        }
    }
)
.debug()
