//
//  RepositorySearchEnvironment.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 27.04.2022.
//

import Foundation
import ComposableArchitecture

struct SearchEnvironment {
    var repositorySearch: (String) -> Effect<[RepositoryModel], SearchError>
    var mainQueue: DispatchQueue
}
