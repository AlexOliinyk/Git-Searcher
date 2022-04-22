import ComposableArchitecture
import Foundation

public let RepositoryDetailsReducer = Reducer<RepositoryDetailsState, RepositoryDetailsAction, RepositoryDetailsEnvironment>
    .combine(
        .init { state, action, environment in
            switch action {
            case .idle:
                return .none
            }
        }
    )
