//
//  UserDetailsReducer.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 28.04.2022.
//

import Foundation
import ComposableArchitecture

let userDetailsReducer = Reducer<UserDetailsState, UserDetailsAction, UserDetailsEnvironment> { state, action, environment in
    
    switch action {
    case .viewAppear:
        state.status = .loading
        
        return environment
            .getUserWithName(state.userName)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(UserDetailsAction.userDataIsLoaded)
    case .userDataIsLoaded(.success(let user)):
        state.status = .loaded(user)
        return .none
    case .userDataIsLoaded(.failure(let error)):
        state.status = .error(error)
        return .none
    }
}
