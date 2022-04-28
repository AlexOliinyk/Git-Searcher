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
            VStack {
                switch viewStore.state.status {
                case .idle:
                    EmptyView()
                case .loaded(let user):
                    Text(user.login)
                case .loading:
                    ProgressView()
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
            .onAppear {
                viewStore.send(.viewAppear)
            }
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView(store: .init(
            initialState: .init(userName: ""),
            reducer: userDetailsReducer,
            environment: .init(
                getUserWithName: dummyGetUserEffect,
                mainQueue: .main)))
    }
}

func dummyGetUserEffect(userName: String) -> Effect<GithubUser, UserDetailsError> {
    .init(value: GithubUser(id: 435, login: "Stepan", name: "Marzepan", followers: 352, following: 23, bio: "fdfds fwef fsfewf", location: "Kyiv, Ukraine"))
}
