import Foundation
import ComposableArchitecture

struct RepositoryDetailsState: Equatable {
//    var userName: String = ""
//    var status: Status = .idle
    var model: RepositoryModel
    var status: Status = .idle
    
    enum Status: Equatable {
        case idle
        case loading
        case readMeIsLoaded(String)
        case error(SearchError)
    }
}
