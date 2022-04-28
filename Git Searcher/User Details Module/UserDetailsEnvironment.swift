//
//  UserDetailsEnvironment.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 28.04.2022.
//

import Foundation
import ComposableArchitecture

struct UserDetailsEnvironment {
    var getUserWithName: (String) -> Effect<GithubUser, UserDetailsError>
    var mainQueue: DispatchQueue
}
