//
//  RepositoryDetailView.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 21.04.2022.
//

import SwiftUI

struct RepositoryDetailView: View {
    var model: RepositoryModel
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: model.owner.avatarUrl.flatMap { URL(string: $0) }) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .cornerRadius(10)
                .padding(.horizontal)
                
                repositoryNameView
                    .background(.yellow)
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                repositoryOwnerView
                    .background(.yellow)
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                forksCountView
                    .background(.yellow)
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                preferredLanguageView
                    .background(.yellow)
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                stargazersCountView
                    .background(.yellow)
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
    }
    
    var repositoryNameView: some View {
        HStack(alignment: .center) {
            Image(systemName: "book.closed.fill")
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.headline)
                Text("Repository name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
    }
    
    var repositoryOwnerView: some View {
        HStack(alignment: .center) {
            NavigationLink(destination: EmptyView(), label: {
                Image(systemName: "figure.wave")
                VStack(alignment: .leading) {
                    Text(model.owner.login)
                        .font(.headline)
                    Text("User name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
            })
        }
        .padding()
    }
    
    var forksCountView: some View {
        HStack(alignment: .center) {
            Image(systemName: "arrow.triangle.branch")
            VStack(alignment: .leading) {
                Text(String(model.forksCount))
                    .font(.headline)
                Text("Forks")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
    }
    
    var preferredLanguageView: some View {
        HStack(alignment: .center) {
            Image(systemName: "cube.fill")
            VStack(alignment: .leading) {
                Text(model.language ?? "unknown")
                    .font(.headline)
                Text("Preferred language")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
    }
    
    var stargazersCountView: some View {
        HStack(alignment: .center) {
            Image(systemName: "star.fill")
            VStack(alignment: .leading) {
                Text(String(model.stargazersCount))
                    .font(.headline)
                Text("Who liked this repository")
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
        RepositoryDetailView(model: RepositoryModel(id: 421, name: "Sasha", forksCount: 123, stargazersCount: 42, watchersCount: 542, owner: .init(id: 654, login: "Sasha", avatarUrl: ""), language: "Swift"))
    }
}
