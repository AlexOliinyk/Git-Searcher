//
//  RepositoryModel.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 18.04.2022.
//

import Foundation
import ComposableArchitecture

struct GithubSearchResponse: Decodable {
    let items: [RepositoryModel]?
}

struct RepositoryModel: Decodable, Equatable, Identifiable {
    let id: Int
    let name: String
    let forksCount: Int
    let stargazersCount: Int
    let watchersCount: Int
    let owner: GithubUser
    let language: String?
}

struct GithubUser: Decodable, Equatable, Identifiable {
    let id: Int
    let login: String
    let avatarUrl: String?
}
