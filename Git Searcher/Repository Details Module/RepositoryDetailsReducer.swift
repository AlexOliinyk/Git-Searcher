import ComposableArchitecture
import Foundation

let RepositoryDetailsReducer = Reducer<RepositoryDetailsState, RepositoryDetailsAction, RepositoryDetailsEnvironment> { state, action, environment in
    
    switch action {
        
//    case .getUser(let userName):
//
//        state.userName = userName
//        if userName.isEmpty {
//            state.status = .idle
//            return .none
//        }
//        state.status = .loading
//        return environment
//            .getUserWithName(userName)
//            .receive(on: environment.mainQueue)
//            .catchToEffect()
//            .map(RepositoryDetailsAction.userDetailsIsLoaded)
//
//    case .userDetailsIsLoaded(let result):
//        switch result {
//        case .success(let user):
//            state.status = .userDataLoaded(user)
//        case .failure(let error):
//            state.status = .error(error)
//        }
//        return .none
    case .presentUserDetails:
        return .none
    case .dismissUserDetails:
        return .none
    }
}
