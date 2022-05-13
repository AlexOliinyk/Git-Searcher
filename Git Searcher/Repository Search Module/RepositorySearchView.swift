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
    let store: Store<RepositorySearchState, RepositorySearchAction>
    
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
                            NavigationLink(
                                isActive: viewStore.binding(
                                    get: { state in
                                        state.selectedDetailsState?.model == model
                                    },
                                    send: { state in
                                        if state {
                                            return .goToRepositoryDetails(.init(model: model))
                                        } else {
                                            return .dismissRepositoryDetails
                                        }
                                    }),
                                destination: {
                                    IfLetStore(store.scope(
                                        state: \.selectedDetailsState,
                                        action: RepositorySearchAction.details
                                    )) { store in
                                        RepositoryDetailsView(
                                            store: store)
                                    }
                                },
                                label: {
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
                .navigationBarItems(trailing: IfLetStore(store.scope(
                    state: \.recentRepository,
                    action: RepositorySearchAction.details
                )) { store in
                    NavigationLink(
                        isActive: viewStore.binding(
                            get: \.isShowingRecentRepository,
                            send: { state in
                                if state {
                                    return .showRecentRepository
                                } else {
                                    return .dismissRecentRepository
                                }
                            }),
                        destination: {
                            RepositoryDetailsView(store: store)
                        },
                        label: {
                            Text("To the last repo")
                                .font(.caption)
                                .padding()
                                .background(.yellow)
                                .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                        })
                })
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
    .init(id: 1, name: "SwiftUI", forksCount: 45, stargazersCount: 345, watchersCount: 2, owner: .init(id: 324, login: "Apple", name: "Swift", followers: 352, following: 23, bio: "fdfds fwef fsfewf", location: "Kyiv, Ukraine", htmlUrl: "", blog: ""), language: "Swift"),
    .init(id: 2, name: "Python", forksCount: 321, stargazersCount: 356, watchersCount: 2, owner: .init(id: 6325, login: "Apple", name: "johny", avatarUrl: nil, followers: 352, following: 23, bio: "fdfds fwef fsfewf", location: "Kyiv, Ukraine", htmlUrl: "", blog: ""), language: "Python"),
    .init(id: 3, name: "JS", forksCount: 532, stargazersCount: 123, watchersCount: 2, owner: .init(id: 563432, login: "Apple", name: "FrontEnd", avatarUrl: nil, followers: 352, following: 23, bio: "fdfds fwef fsfewf", location: "Kyiv, Ukraine", htmlUrl: "", blog: ""), language: "Java"),
]
