//
//  RepositoryDetailView.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 21.04.2022.
//

import SwiftUI

struct RepositoryDetailsView: View {
    var model: RepositoryModel
    
    var body: some View {
        List {
            Section() {
                AsyncImage(url: model.owner.avatarUrl.flatMap { URL(string: $0) }) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .cornerRadius(5)
            }
            
            Section {
                SomeView(imageSystemName: "book.closed.fill", title: "Name", value: model.name)
                
                NavigationLink {
                    EmptyView()
                } label: {
                    SomeView(imageSystemName: "figure.wave", title: "User name", value: model.owner.login)
                }
                
                SomeView(imageSystemName: "arrow.triangle.branch", title: "Forks", value: String(model.forksCount))
                SomeView(imageSystemName: "cube.fill", title: "Preferred language", value: model.language ?? "unknown")
                SomeView(imageSystemName: "star.fill", title: "Who liked this repository", value: String(model.stargazersCount))
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
            RepositoryDetailsView(model: RepositoryModel(id: 421, name: "Sasha", forksCount: 123, stargazersCount: 42, watchersCount: 542, owner: .init(id: 654, login: "Sasha", avatarUrl: ""), language: "Swift"))
        }
    }
}
