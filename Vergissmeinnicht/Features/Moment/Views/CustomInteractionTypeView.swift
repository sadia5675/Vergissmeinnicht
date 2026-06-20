//
//  CustomInteractionTypeView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 26.05.26.
//

import SwiftUI

struct CustomInteractionTypeView: View {
    @StateObject var viewModel = CustomInteractionTypeViewModel()
    @Environment(\.dismiss) var dismiss
    
    let onSave: (InteractionType) -> Void  // Callback
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 5)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Was passt zu eurem Moment?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Text("Wähle ein Symbol aus.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Suche...z.B Kino, Sport", text: $viewModel.searchText)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.filteredSymbols, id: \.self) { symbol in
                            Button(action: { viewModel.selectedSymbol = symbol }) {
                                Image(systemName: symbol)
                                    .font(.system(size: 24))
                                    .foregroundColor(viewModel.selectedSymbol == symbol ? .white : .green)
                                    .frame(width: 50, height: 50)
                                    .background(viewModel.selectedSymbol == symbol ? Color.green : Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ausgewählt:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: viewModel.selectedSymbol)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.green)
                            .cornerRadius(8)
                        
                        TextField("Name für euren Moment...", text: $viewModel.customTypeName)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    if let newType = viewModel.save() {
                        onSave(newType)  // Callback
                        dismiss()
                    }
                }) {
                    Text("Moment benennen")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.customTypeName.isEmpty ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(viewModel.customTypeName.isEmpty)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Neues Symbol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }
}
