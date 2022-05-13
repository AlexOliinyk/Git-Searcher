//
//  RepositoryDetailView.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 21.04.2022.
//

import SwiftUI
import ComposableArchitecture

struct RepositoryDetailsView: View {
    
    let store: Store<RepositoryDetailsState, RepositoryDetailsAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                Section {
                    SomeView(imageSystemName: "book.closed.fill", title: "Name", value: viewStore.state.model.name)
                    
                    NavigationLink {
                        UserDetailsView(store: .init(
                            initialState: .init(userName: viewStore.state.model.owner.login),
                            reducer: userDetailsReducer,
                            environment: .init(
                                getUserWithName: userEffect,
                                mainQueue: .main)))
                    } label: {
                        SomeView(imageSystemName: "figure.wave", title: "User name", value: viewStore.state.model.owner.login)
                    }
                    
                    SomeView(imageSystemName: "arrow.triangle.branch", title: "Forks", value: String(viewStore.state.model.forksCount))
                    SomeView(imageSystemName: "cube.fill", title: "Preferred language", value: viewStore.state.model.language ?? "unknown")
                    SomeView(imageSystemName: "star.fill", title: "Who liked this repository", value: String(viewStore.state.model.stargazersCount))
                }
                
                Section {
                    switch viewStore.status {
                    case .idle:
                        EmptyView()
                    case .loading:
                        ProgressView()
                    case .readMeIsLoaded(let readMe):
                        Text(.init(readMe))
                    case .error(let error):
                        Text(error.localizedDescription)
                    }
                }
            }
            .onAppear {
                viewStore.send(.didAppear)
            }
        }
    }
}

struct SomeView: View {
    let imageSystemName: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageSystemName)
            VStack(alignment: .leading) {
                Text(value)
                    .font(.headline)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
    }
}

struct RepositoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            RepositoryDetailsView(store: .init(
                initialState: .init(model: RepositoryModel(id: 421, name: "Sasha", forksCount: 123, stargazersCount: 42, watchersCount: 542, owner: .init(id: 654, login: "Sasha", name: "Oleksandr", followers: 352, following: 23, bio: "fdfds fwef fsfewf", location: "Kyiv, Ukraine", htmlUrl: "", blog: ""), language: "Swift"), status: .idle),
                reducer: repositoryDetailsReducer,
                environment: .init(getReadMe: dummyReadMe, mainQueue: .main)))
        }
    }
}

func dummyReadMe(userName: String, repoName: String) -> Effect<String, SearchError> {
    return Effect(value: "")
}
