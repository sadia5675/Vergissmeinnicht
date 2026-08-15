//
//  GardenView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import SwiftUI

/// Zentrale Gartenübersicht mit Hinweisen, Kategorie-Filterung und Zugriff auf das Hinzufügen von Beziehungen und Momenten
struct GardenView: View {

    // MARK: - Properties

    @StateObject private var viewModel = GardenViewModel()
    @StateObject private var hintViewModel = HintViewModel()

    @State private var selectedTab: GardenTab = .wellCared
    @State private var showAddRelationship = false
    @State private var showQuickMoment = false
    @State private var gardenName = ""
    @State private var editingGardenName = false
    @FocusState private var nameFocused: Bool

    private var currentRelationships: [Relationship] {

        switch selectedTab {

        case .wellCared:
            return viewModel.wellCaredRels

        case .needsAttention:
            return viewModel.needsAttentionRels

        case .resting:
            return viewModel.restingRels
        }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            
            ZStack {
                Color("Background")
                    .ignoresSafeArea()
               
                VStack(spacing: 0) {

                    // MARK: - Header

                    GardenHeader(
                        viewModel: viewModel,
                        showAddRelationship: $showAddRelationship,
                        showQuickMoment: $showQuickMoment,
                        editingGardenName: $editingGardenName,
                        gardenName: $gardenName,
                        nameFocused: $nameFocused
                    )

                    ScrollView {
                        VStack {

                            // MARK: - Hints

                            if !hintViewModel.hints.isEmpty {
                                VStack(spacing: 12) {
                                    ForEach(hintViewModel.hints) { hint in
                                        HintView(
                                            hint: hint,
                                            onDismiss: {
                                                hintViewModel.dismissHint(hint.id)
                                            }
                                        )
                                    }
                                }
                                .padding()
                            }

                            // MARK: - Content

                            if viewModel.isLoading {
                                ProgressView()

                            } else if viewModel.relationships.isEmpty {
                                EmptyStateView(
                                    title: "Dein Garten ist leer",
                                    subtitle: "Füge deine erste Beziehung hinzu!",
                                    icon: "leaf"
                                )
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 500)

                            } else {
                                VStack(alignment: .leading, spacing: 20) {
                                    GardenTabBar(
                                        selectedTab: $selectedTab
                                    )
                                    if currentRelationships.isEmpty {
                                        EmptyStateView(
                                            title: nil,
                                            subtitle: """
                                            Sobald eine Beziehung zu dieser
                                            Kategorie gehört, erscheint sie hier.
                                            """,
                                            icon: "leaf"
                                        )
                                    } else {
                                        RelationshipGrid(
                                            relationships: currentRelationships
                                        )
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
            .sheet(
                isPresented: $showAddRelationship,
                onDismiss: {
                    viewModel.loadRelationships()
                }
            ) {
                AddRelationshipView()
            }
            .sheet(
                isPresented: $showQuickMoment,
                onDismiss: {
                    viewModel.loadRelationships()
                    hintViewModel.loadHints(for: viewModel.relationships)
                }
            ) {
                MomentView(
                    viewModel: MomentViewModel(),
                    showHeader: false
                )
            }
            .onAppear {
                viewModel.loadRelationships()
                hintViewModel.loadHints(
                    for: viewModel.relationships
                )
            }
            .onChange(of: viewModel.relationships.count) {
                hintViewModel.loadHints(for: viewModel.relationships)
            }
        }
    }
}

#Preview {
    GardenView()
}
