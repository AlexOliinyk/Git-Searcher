//
//  UserDetailsView.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 27.04.2022.
//

import SwiftUI
import ComposableArchitecture
import Combine
import WebKit

struct UserDetailsView: View {
    let store: Store<UserDetailsState, UserDetailsAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                switch viewStore.state.status {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                case .loaded(let user):
                    UserView(model: user)
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
            .background(.clear)
            .onAppear {
                viewStore.send(.viewAppear)
            }
            .navigationBarTitle(viewStore.userName, displayMode: .inline)
        }
    }
}

struct UserView: View {
    var model: GithubUser
    @State private var showWebView = false
    
    var body: some View {
        AsyncImage(url: model.avatarUrl.flatMap { URL(string: $0) }) { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 7)
                .padding()
                .listRowBackground(Color.clear)
            
        } placeholder: {
            ProgressView()
        }
        Section {
            SomeView(imageSystemName: "keyboard.fill", title: "User id", value: String(model.id))
            SomeView(imageSystemName: "person.fill", title: "Name", value: model.name ?? "Not Found")
            SomeView(imageSystemName: "location.circle.fill", title: "Location", value: model.location ?? "unknown")
            SomeView(imageSystemName: "figure.wave", title: "Followers", value: String(model.followers ?? 0))
            SomeView(imageSystemName: "person.crop.circle.fill.badge.checkmark", title: "Following", value: String(model.following ?? 0))
        }
        
        Section {
            SomeView(imageSystemName: "arrow.up.bin.fill", title: "bio", value: model.bio ?? "This user didn't add a bio.")
        }
        
        Section {
            Button {
                showWebView.toggle()
            } label: {
                SomeView(imageSystemName: "link.circle.fill", title: "Go to the User profile", value: model.htmlUrl)
            }
            .sheet(isPresented: $showWebView) {
                WebView(url: URL(string: model.htmlUrl)!)
            }
        }
        
        Section {
            Button {
                showWebView.toggle()
            } label: {
                SomeView(imageSystemName: "network", title: "blog", value: model.blog ?? "Not Found")
            }
            .sheet(isPresented: $showWebView) {
                WebView(url: URL(string: model.blog!)!)
            }
        }
    }
    
    struct WebView: UIViewRepresentable {
        var url: URL
        
        func makeUIView(context: Context) -> WKWebView {
            return WKWebView()
        }
        
        func updateUIView(_ webView: WKWebView, context: Context) {
            let request = URLRequest(url: url)
            webView.load(request)
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
