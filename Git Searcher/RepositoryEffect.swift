//
//  RepositoryEffect.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 19.04.2022.
//

import Foundation
import ComposableArchitecture
import Combine

func repositoryEffect(searchText: String) -> Effect<[RepositoryModel], SearchError> {
    guard let url = URL(string: "https://api.github.com/search/repositories?q=" + searchText.lowercased()) else {
        fatalError("Error")
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    print(url)
    return URLSession.shared.dataTaskPublisher(for: url)
        .mapError { _ in SearchError.downloadError }
        .map { data, _ in data }
        .decode(type: GithubSearchResponse.self, decoder: decoder)
        .map { $0.items ?? [] }
        .mapError { inlineError in
            debugPrint(inlineError)
            return SearchError.decodingError
        }
        .eraseToEffect()
}


func dummyRepositorySearchEffect(searchText: String) -> Effect<[RepositoryModel], SearchError> {
   let result = repositoriesMock.filter {
       $0.name.lowercased().contains(searchText.lowercased())
    }
    return Just(result)
        .setFailureType(to: SearchError.self)
        .eraseToEffect()
}

func dummyRepositorySearchErrorEffect(searchText: String) -> Effect<[RepositoryModel], SearchError> {
    let error = SearchError.decodingError
    return Fail(error: error)
        .eraseToEffect()
}
