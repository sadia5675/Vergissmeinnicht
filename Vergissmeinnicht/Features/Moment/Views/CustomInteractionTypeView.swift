//
//  CustomInteractionTypeView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 26.05.26.
//

import SwiftUI

/// Sheet zum Erstellen einer benutzerdefinierten Interaktionskategorie mit Symbolauswahl und Namen
struct CustomInteractionTypeView: View {

    // MARK: - Properties

    @StateObject var viewModel = CustomInteractionTypeViewModel()

    @Environment(\.dismiss) private var dismiss

    let onSave: (InteractionType) -> Void

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 5
    )

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Header

                Text("Was passt zu eurem Moment?")
                    .font(.title.bold())
                    .foregroundStyle(Color("PrimaryDark"))

                Text("Wähle ein Symbol und gib eurem Moment einen Namen.")
                    .foregroundStyle(Color("Primary"))

                // MARK: - Search

                BorderedTextField(
                    icon: "magnifyingglass",
                    placeholder: "Suche z.B. Kino oder Sport",
                    text: $viewModel.searchText
                )

                // MARK: - Symbols

                ScrollView {

                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(viewModel.filteredSymbols, id: \.self) { symbol in

                            Button {
                                viewModel.selectedSymbol = symbol

                            } label: {
                                Image(systemName: symbol)
                                    .font(.system(size: 24))
                                    .foregroundStyle(
                                        viewModel.selectedSymbol == symbol
                                        ? Color.white
                                        : Color("PrimaryDark")
                                    )
                                    .frame(width: 54, height: 54)
                                    .background(
                                        viewModel.selectedSymbol == symbol
                                        ? Color("PrimaryDark")
                                        : Color("Surface")
                                    )
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                Color("Border"),
                                                lineWidth: viewModel.selectedSymbol == symbol ? 0 : 2
                                            )
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Divider()

                // MARK: - Preview

                VStack(alignment: .leading, spacing: 14) {
                    Text("Moment")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color("PrimaryDark"))

                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("PrimaryDark"))
                            .frame(width: 56, height: 56)
                            .overlay {
                                Image(systemName: viewModel.selectedSymbol)
                                    .font(.system(size: 24))
                                    .foregroundStyle(Color.white)
                            }

                        BorderedTextField(
                            placeholder: "Name für euren Moment...",
                            text: $viewModel.customTypeName
                        )
                    }
                }

                Spacer()

                // MARK: - Save

                PrimaryButton(
                    title: "Moment benennen",
                    selected: !viewModel.customTypeName.isEmpty
                ) {

                    if let newType = viewModel.save() {
                        onSave(newType)
                        dismiss()
                    }
                }
                .disabled(
                    viewModel.customTypeName.isEmpty
                )
            }
            .padding()
            .background(Color("Background"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
        }
    }
}
