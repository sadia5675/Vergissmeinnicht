//
//  GardenView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import SwiftUI

struct GardenView: View {
    @StateObject var viewModel = GardenViewModel()
    @StateObject var hintViewModel = HintViewModel()
    @State var showAddRelationship = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
            VStack {
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
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.relationships.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("Dein Garten ist leer")
                            .font(.headline)
                        
                        Text("Füge deine erste Beziehung hinzu!")
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                } else {
                        VStack(alignment: .leading, spacing: 20) {
                            // Gut gepflegt
                            if !viewModel.wellCaredRels.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Gut gepflegt")
                                        .font(.headline)
                                    
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                        ForEach(viewModel.wellCaredRels) { rel in
                                            NavigationLink(destination: DetailView(
                                                viewModel: DetailViewModel(relationship: rel)
                                            )) {
                                                PlantCard(relationship: rel)
                                            }
                                        }
                                    }
                                }
                            }
                            // Wartet auf dich
                            if !viewModel.needsAttentionRels.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Wartet auf dich")
                                        .font(.headline)
                                    
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                        ForEach(viewModel.needsAttentionRels) { rel in
                                            NavigationLink(destination: DetailView(
                                                viewModel: DetailViewModel(relationship: rel)
                                            )) {
                                                PlantCard(relationship: rel)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    
                }
            }
        }
            .navigationTitle("Mein Garten")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddRelationship = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddRelationship) {
                AddRelationshipView()
            }
            .onAppear {
                print("Garden neu geladen")
                viewModel.loadRelationships()
            }

            .onChange(of: viewModel.relationships.count) {
                hintViewModel.loadHints(for: viewModel.relationships)
            }

            .onChange(of: showAddRelationship) { oldValue, newValue in
                if !newValue {
                    viewModel.loadRelationships()
                }
            }
        }
    }
}

#Preview {
    GardenView()
}
