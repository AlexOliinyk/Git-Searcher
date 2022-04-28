import Foundation

enum UserDetailsError: Error {
    case downloadError
    case decodingError
}

enum RepositoryDetailsAction: Equatable {
    case presentUserDetails
    case dismissUserDetails
    case didAppear
    case readMeIsLoaded(Result<String, SearchError>)
}
