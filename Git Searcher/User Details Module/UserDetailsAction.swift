//
//  UserDetailsAction.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 28.04.2022.
//

import Foundation

enum UserDetailsAction: Equatable {
    case viewAppear
    case userDataIsLoaded(Result<GithubUser, UserDetailsError>)
}
