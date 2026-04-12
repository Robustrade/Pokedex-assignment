//
//  ListView.swift
//  iosApp
//
//  Created by Akash K on 12/04/26.
//

import SwiftUI

struct ListView: View {
    
    @StateObject private var viewModel = ListViewModel()
    @State private var searchText = ""
    
    private let column = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: column) {
                RoundedRectangle(cornerRadius: 12)
            }
        }
    }
}

#Preview {
    ListView()
}
