import Foundation
import ComposableArchitecture

public struct RepositoryDetailsEnvironment {
    var getReadMe: (_ userName: String, _ repoName: String) -> Effect<String, SearchError>
    var mainQueue: DispatchQueue

}
