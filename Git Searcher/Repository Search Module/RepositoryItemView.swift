//
//  RepositoryListView.swift
//  Git Searcher
//
//  Created by Oleksandr Oliinyk on 19.04.2022.
//

import SwiftUI
import ComposableArchitecture

struct RepositoryItemView: View {
    let repository: RepositoryModel
    
    var body: some View {
        HStack {
            //                AsyncImage(url: repository.owner.avatarUrl.flatMap(URL.init(string: )))
            AsyncImage(url: repository.owner.avatarUrl.flatMap { URL(string: $0) }) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .scaledToFit()
            .frame(width: 70, height: 70)
            .cornerRadius(10)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(repository.name)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(repository.stargazersCount))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                HStack {
                    HStack {
                        Image(systemName: "arrow.triangle.branch")
                        Text(String(repository.forksCount))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text(repository.language ?? "unknown")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .padding()
        }
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RepositoryItemView(repository: RepositoryModel(id: 342, name: "Swift", forksCount: 34, stargazersCount: 456, watchersCount: 234, owner: .init(id: 663, login: "Yen", avatarUrl: "https://avatars.githubusercontent.com/u/7872329?v=4"), language: "Swift"))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            RepositoryItemView(repository: RepositoryModel(id: 342, name: "Swift", forksCount: 34, stargazersCount: 456, watchersCount: 234, owner: .init(id: 663, login: "Yen", avatarUrl: "https://avatars.githubusercontent.com/u/7872329?v=4"), language: "Java"))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
