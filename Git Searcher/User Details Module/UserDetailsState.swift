//
//  UserDetailsState.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 28.04.2022.
//

import Foundation

struct UserDetailsState: Equatable {
    var userName: String
    var status: Status = .idle
    
    enum Status: Equatable {
        case idle
        case loading
        case loaded(GithubUser)
        case error(UserDetailsError)
    }
}
