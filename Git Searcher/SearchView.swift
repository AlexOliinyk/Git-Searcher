//
//  ContentView.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 15.04.2022.
//

import SwiftUI
import ComposableArchitecture
import Combine

enum SearchError: Error {
    case downloadError
    case decodingError
}


//struct SearchError: Error, Equatable {
//    static func == (lhs: SearchError, rhs: SearchError) -> Bool {
//        false
//    }
//
//    let internalError: Error
//}

enum SearchAction: Equatable {
    
    case search(String)
    case dataIsLoaded(Result<[RepositoryModel], SearchError>)
}

struct SearchState: Equatable {
    var searchText: String = ""
    var status: Status = .idle
    
    enum Status: Equatable {
        case idle
        case loading
        case dataLoaded([RepositoryModel])
        case emptyResult
        case error(SearchError)
    }
}

struct SearchEnvironment {
    var repositorySearch: (String) -> Effect<[RepositoryModel], SearchError>
    var mainQueue: DispatchQueue
}

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> { state, action, environment in
    
    switch action {
    case .search(let searchText):
        
        struct MyRepositoryID: Hashable {}
        
        state.searchText = searchText
        if searchText.isEmpty {
            state.status = .idle
            return .none
        }
        state.status = .loading
        return environment
            .repositorySearch(searchText)
        //            .receive(on: environment.mainQueue)
            .catchToEffect()
            .map(SearchAction.dataIsLoaded)
            .debounce(id: MyRepositoryID(), for: .seconds(0.5), scheduler: environment.mainQueue)
    case .dataIsLoaded(let result):
        switch result {
        case .success(let results):
            if results.count > 0 {
                state.status = .dataLoaded(results)
            } else {
                state.status = .emptyResult
            }
        case .failure(let error):
            state.status = .error(error)
        }
        return .none
    }
}
    .debug()

struct SearchView: View {
    let store: Store<SearchState, SearchAction>
    
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
                            NavigationLink(destination: RepositoryDetailView(model: model), label: {
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
            SearchView(store: .init(
                initialState: .init(),
                reducer: searchReducer,
                environment: .init(repositorySearch: dummyRepositorySearchEffect, mainQueue: .main)))
            .preferredColorScheme(.light)
            
            SearchView(store: .init(
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
