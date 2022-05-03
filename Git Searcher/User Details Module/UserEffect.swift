//
//  UserEffect.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 27.04.2022.
//

import Foundation
import ComposableArchitecture
import Combine

func userEffect(userName: String) -> Effect<GithubUser, UserDetailsError> {
    guard let url = URL(string: "https://api.github.com/users/" + userName) else {
        fatalError("Error")
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    return URLSession.shared.dataTaskPublisher(for: url)
        .mapError { _ in UserDetailsError.downloadError }
        .map { data, _ in data}
        .decode(type: GithubUser.self, decoder: decoder)
        .map { $0 }
        .mapError { inlineError in
            return UserDetailsError.decodingError
        }
        .eraseToEffect()
}

func dummyGetUserEffect(userName: String) -> Effect<GithubUser, UserDetailsError> {
    .init(value: GithubUser(id: 435, login: "Stepan", name: "Marzepan", followers: 352, following: 23, bio: "fdfds fwef fsfewf", location: "Kyiv, Ukraine", htmlUrl: "", blog: ""))
}
