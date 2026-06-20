//
//  MomentView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 23.05.26.
//

import SwiftUI

struct MomentView: View {
    @StateObject var viewModel: MomentViewModel
    @Environment(\.dismiss) var dismiss
    @State var showCustomTypePicker = false
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Header
                Section {
                    HStack {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.relationship.name)
                                .font(.headline)
                            Text("Moment festhalten")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                }
                
                // MARK: - Weitere Teilnehmer
                if !viewModel.allRelationships.isEmpty {
                    Section {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Wer war dabei?")
                                .font(.headline)
                            Text("Mehrere auswählen möglich.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        ForEach(viewModel.allRelationships) { rel in
                            Button(action: { viewModel.toggleParticipant(rel.id) }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(rel.name)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                        Text(RelationshipDateFormatter.formatDaysSince(
                                            rel.getDaysSinceLastContact()
                                        ))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: viewModel.additionalParticipants.contains(rel.id)
                                        ? "checkmark.circle.fill"
                                        : "circle"
                                    )
                                    .foregroundColor(viewModel.additionalParticipants.contains(rel.id)
                                        ? .green
                                        : .gray
                                    )
                                    .font(.title3)
                                }
                            }
                        }
                    }
                }
                
                // MARK: - Interaktionstyp
                Section("Was hast du gemacht?") {
                    Picker("Typ", selection: $viewModel.selectedInteractionType) {
                        ForEach(viewModel.interactionTypes, id: \.id) { type in
                            Label(type.name, systemImage: type.sfSymbol)
                                .tag(type)
                        }
                    }
                    
                    Button(action: { showCustomTypePicker = true }) {
                        Label("Sonstiges (eigenes Symbol)", systemImage: "plus.circle")
                            .foregroundColor(.green)
                    }
                }
                
                // MARK: - Notizen
                Section("Notizen (optional)") {

                    ScrollView(.horizontal, showsIndicators: false) {

                        HStack {

                            ForEach(viewModel.noteTemplates, id: \.self) { template in

                                Button(template) {

                                    if viewModel.notes.isEmpty {

                                        viewModel.notes = template

                                    } else {

                                        viewModel.notes += "\n" + template
                                    }
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Color.green.opacity(0.15)
                                )
                                .foregroundColor(.green)
                                .clipShape(Capsule())
                            }
                        }
                    }

                    TextEditor(text: $viewModel.notes)
                        .frame(height: 100)
                }
                
                // Nach Notizen-Section, vor Save-Button:
                Section("Foto (optional)") {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipped()
                            .cornerRadius(8)
                        
                        Button("Foto entfernen") {
                            viewModel.selectedImage = nil
                        }
                        .foregroundColor(.red)
                    } else {
                        Button(action: { showImagePicker = true }) {
                            Label("Foto hinzufügen", systemImage: "photo")
                        }
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $viewModel.selectedImage)
                }
                
                // MARK: - Save Button
                Section {
                    Button(action: save) {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Moment speichern")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .sheet(isPresented: $showCustomTypePicker) {
                CustomInteractionTypeView { newType in

                    viewModel.loadInteractionTypes()

                    viewModel.selectedInteractionType =
                        newType
                }
            }
            .navigationTitle("Neuer Moment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }
    
    private func save() {
        if viewModel.saveMoment() {
            dismiss()
        }
    }
}

/*#Preview {
    let rel = Relationship(
        name: "Anna",
        plant: Plant(type: "pansy"),
        careRhythm: CareRhythm(interval: 7)
    )
    MomentView(viewModel: MomentViewModel(relationship: rel))
}*/
