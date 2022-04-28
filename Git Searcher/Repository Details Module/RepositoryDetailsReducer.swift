import ComposableArchitecture
import Foundation

let RepositoryDetailsReducer = Reducer<RepositoryDetailsState, RepositoryDetailsAction, RepositoryDetailsEnvironment> { state, action, environment in
    
    switch action {
    case .presentUserDetails:
        return .none
    case .dismissUserDetails:
        return .none
    case .didAppear:
        state.status = .loading
        
        return environment
            .getReadMe(state.model.owner.login, state.model.name)
            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(RepositoryDetailsAction.readMeIsLoaded)
        
    case .readMeIsLoaded(.success(let readMe)):
        state.status = .readMeIsLoaded(readMe)
        return .none
    case .readMeIsLoaded(.failure(let error)):
        state.status = .error(error)
        return .none
    }
}
