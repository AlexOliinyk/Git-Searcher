//
//  Git_SearcherApp.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 15.04.2022.
//

import SwiftUI

@main
struct Git_SearcherApp: App {
    var body: some Scene {
        WindowGroup {
//            SearchView()
            SearchView(store: .init(
                initialState: .init(),
                reducer: searchReducer,
                environment: .init(repositorySearch: repositoryEffect, mainQueue: .main)))
        }
    }
}
