//
//  ContentView.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 15.04.2022.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct RepositorySearchView: View {
    let store: Store<SearchState, RepositorySearchAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack {
                    SearchBarView(searchText: viewStore.binding(get: { state in
                        state.searchText
                    }, send: { searchText in
                            .search(searchText)
                    }))
                    .padding([.top, .leading, .trailing])
                    switch viewStore.state.status {
                    case .idle:
                        Spacer()
                        Text("Start typing at the search bar above")
                            .foregroundColor(Color.secondary)
                        Spacer()
                    case .loading:
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    case .dataLoaded(let models):
                        List(models) { model in
                            NavigationLink(destination: RepositoryDetailsView(model: model), label: {
                                RepositoryItemView(repository: model)
                            })
                        }
                        .listStyle(PlainListStyle())
                        
                    case .emptyResult:
                        Spacer()
                        Text("We didn't find anything for you...")
                            .foregroundColor(Color.secondary)
                        Spacer()
                    case .error(let error):
                        Spacer()
                        Text(error.localizedDescription)
                        Spacer()
                    }
                }
                .navigationTitle("Search Repository")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RepositorySearchView(store: .init(
                initialState: .init(),
                reducer: searchReducer,
                environment: .init(repositorySearch: dummyRepositorySearchEffect, mainQueue: .main)))
            .preferredColorScheme(.light)
            
            RepositorySearchView(store: .init(
                initialState: .init(searchText: "", status: .loading),
                reducer: searchReducer,
                environment: .init(repositorySearch: dummyRepositorySearchErrorEffect, mainQueue: .main)))
        }
    }
}

let repositoriesMock: [RepositoryModel] = [
    .init(id: 1, name: "SwiftUI", forksCount: 45, stargazersCount: 345, watchersCount: 2, owner: .init(id: 324, login: "Apple", avatarUrl: nil), language: "Swift"),
    .init(id: 2, name: "Python", forksCount: 321, stargazersCount: 356, watchersCount: 2, owner: .init(id: 6325, login: "Apple", avatarUrl: nil), language: "Python"),
    .init(id: 3, name: "JS", forksCount: 532, stargazersCount: 123, watchersCount: 2, owner: .init(id: 563432, login: "Apple", avatarUrl: nil), language: "Java"),
]
