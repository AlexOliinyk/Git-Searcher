import ComposableArchitecture
import Foundation
import SwiftUI

public struct RepositoryDetailsView: View {
    let store: Store<RepositoryDetailsState, RepositoryDetailsAction>
    @ObservedObject var viewStore: ViewStore<ViewState, RepositoryDetailsAction>

    public init(store: Store<RepositoryDetailsState, RepositoryDetailsAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: ViewState.init))
    }

    public var body: some View {
        EmptyView()
    }
}

extension RepositoryDetailsView {
    struct ViewState: Equatable {
        init(state: RepositoryDetailsState) {}
    }
}
