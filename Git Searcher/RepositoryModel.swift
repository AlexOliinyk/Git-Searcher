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
    let name: String?
    let avatarUrl: String?
    let followers: Int?
    let following: Int?
    let bio: String?
    let location: String?
    let htmlUrl: String
    let blog: String?
    
    init(id: Int, login: String, name: String, avatarUrl: String? = nil, followers: Int, following: Int, bio: String, location: String, htmlUrl: String, blog: String) {
        self.id = id
        self.login = login
        self.name = name
        self.avatarUrl = nil
        self.followers = followers
        self.following = following
        self.bio = bio
        self.location = location
        self.htmlUrl = htmlUrl
        self.blog = blog
    }
}

struct ReadMe: Decodable, Equatable {
    let content: String
    
    var text: String {
        let newContent = content.components(separatedBy: .whitespacesAndNewlines).joined()
        guard let data = Data(base64Encoded: newContent) else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
}
