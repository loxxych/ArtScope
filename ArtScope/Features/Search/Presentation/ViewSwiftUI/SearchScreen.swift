//
//  SearchScreen.swift
//  ArtScope
//
//  Created by loxxy on 19.04.2026.
//

import SwiftUI

struct SearchScreen: View {
    let content: SearchContent
    @State private var query = ""

    private let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                Color.clear
                    .frame(height: 10)

                searchField

                SearchFeaturedCategoryCard(category: content.featuredCategory)

                Divider()
                    .overlay(Color.black.opacity(0.12))
                    .padding(.horizontal, -24)

                Text(content.styleSectionTitle)
                    .font(SearchTheme.pixelFont(size: 28))
                    .foregroundStyle(SearchTheme.text)
                    .multilineTextAlignment(.leading)

                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(content.styles) { style in
                        SearchStyleGridCard(item: style)
                    }
                }
                .padding(.bottom, 96)
            }
            .padding(.horizontal, 22)
            .padding(.top, 18)
        }
        .background(SearchTheme.background.ignoresSafeArea())
    }

    private var searchField: some View {
        HStack(spacing: 12) {
            TextField("", text: $query, prompt: Text(content.searchPlaceholder).foregroundStyle(SearchTheme.placeholder))
                .font(SearchTheme.regularFont(size: 15))
                .foregroundStyle(SearchTheme.text)

            Image(systemName: "magnifyingglass")
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(SearchTheme.text)
        }
        .padding(.horizontal, 20)
        .frame(height: 42)
        .background(
            RoundedRectangle(cornerRadius: 21)
                .stroke(SearchTheme.searchBorder, lineWidth: 1)
        )
    }
}

#Preview {
    SearchScreen(content: SearchSampleData.content)
}
