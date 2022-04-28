//
//  UserDetailsView.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 27.04.2022.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct UserDetailsView: View {
    let store: Store<UserDetailsState, UserDetailsAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    switch viewStore.state.status {
                    case .idle:
                        EmptyView()
                    case .loading:
                        ProgressView()
                    case .loaded(let user):
                        UserView(model: user)
                        SomeView(imageSystemName: "person.fill", title: "Username", value: user.login)
                    case .error(let error):
                        Text(error.localizedDescription)
                    }
                }
                .onAppear {
                    viewStore.send(.viewAppear)
                }
                .navigationTitle(viewStore.userName)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct UserView: View {
    var model: GithubUser
    
    var body: some View {
        Section {
            AsyncImage(url: model.avatarUrl.flatMap { URL(string: $0) }) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .scaledToFit()
            .cornerRadius(5)
        }
        Section {
            SomeView(imageSystemName: "person.fill", title: "Username", value: model.login)
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView(store: .init(
            initialState: .init(userName: "Oleksandr"),
            reducer: userDetailsReducer,
            environment: .init(
                getUserWithName: dummyGetUserEffect,
                mainQueue: .main)))
    }
}
