//
//  DetailView.swift
//  Vergissmeinnicht
//
//  Created by Sadia Miah on 22.05.26.
//

import SwiftUI
import UserNotifications

struct DetailView: View {
    @StateObject var viewModel: DetailViewModel
    @StateObject private var hintViewModel = HintViewModel()
    @Environment(\.dismiss) var dismiss
    @State var showMomentView = false
    @State var isEditing = false
    
    @State var showAddCustomReminder = false
    @State var editingReminder: CustomReminder?
    
    @State var editName = ""
    @State var editInterval = 0
    @State var editBirthDate: Date?
    @State var hasBirthDate = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: - Header mit Pflanze
                    PlantCard(relationship: viewModel.relationship, size: .large)
                    // HINT
                    if let hint = hintViewModel.detailHint {

                        HintView(
                            hint: hint,
                            onDismiss: {
                                hintViewModel.dismissHint(hint.id)
                            }
                        )
                    }
                    
                    // MARK: - Infos (editierbar)
                    VStack(alignment: .leading, spacing: 12) {
                        // Letzter Kontakt (nicht editierbar)
                        HStack {
                            Label("Letzter Kontakt", systemImage: "calendar")
                            Spacer()
                            Text(RelationshipDateFormatter.formatDaysSince(
                                viewModel.relationship.getDaysSinceLastContact()
                            ))
                            .fontWeight(.semibold)
                        }
                        
                        Divider()
                        
                        // Pflegeintervall (editierbar)
                        HStack {
                            Label("Pflegeintervall", systemImage: "hourglass")
                            Spacer()
                            if isEditing {
                                Picker("", selection: $editInterval) {
                                    ForEach(AppConstants.careRhythmPresets, id: \.self) { interval in
                                        Text("\(interval) Tage").tag(interval)
                                    }
                                }
                                .frame(width: 120)
                            } else {
                                Text("alle \(viewModel.relationship.careRhythm.interval) Tage")
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        Divider()
                        
                        // Geburtstag (editierbar)
                        HStack {
                            Label("Geburtstag", systemImage: "birthday.cake")
                            Spacer()
                            if isEditing {
                                Toggle("", isOn: $hasBirthDate)
                                    .onChange(of: hasBirthDate) { old, new in
                                        if !new {
                                            editBirthDate = nil
                                        } else if editBirthDate == nil {
                                            editBirthDate = Date()
                                        }
                                    }
                            } else {
                                if let bday = viewModel.relationship.birthDate {
                                    Text(bday.formatted(date: .abbreviated, time: .omitted))
                                        .fontWeight(.semibold)
                                } else {
                                    Text("nicht hinzugefügt")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        // DatePicker wenn Geburtstag aktiviert
                        if isEditing && hasBirthDate && editBirthDate != nil {
                            DatePicker(
                                "Datum",
                                selection: Binding(
                                    get: { editBirthDate ?? Date() },
                                    set: { editBirthDate = $0 }
                                ),
                                displayedComponents: [.date]
                            )
                            .padding(.leading, 40)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)
                    
                    
                    // MARK: - Custom Reminders
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Erinnerungen")
                                .font(.headline)
                            
                            Spacer()
                            
                            Button(action: { showAddCustomReminder = true }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        if viewModel.relationship.customReminders.isEmpty {
                            Text("Keine Erinnerungen")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(viewModel.relationship.customReminders) { reminder in
                                    CustomReminderCard(
                                        reminder: reminder,
                                        isEditing: isEditing,
                                        onToggle: { isActive in viewModel.updateReminder(reminder, isActive: isActive) },
                                        onDelete: { viewModel.deleteReminder(reminder) },
                                        onTap: {
                                            editingReminder = reminder
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    // Sheet 1: Neuen Reminder erstellen
                    .sheet(isPresented: $showAddCustomReminder) {
                        CustomReminderView(
                            viewModel: CustomReminderViewModel(relationship: viewModel.relationship)
                        )
                    }
                    .onChange(of: showAddCustomReminder) { oldValue, newValue in
                        if !newValue {
                            viewModel.loadRelationship()
                        }
                    }
                    
                    // Sheet 2: Existierenden Reminder bearbeiten
                    .sheet(item: $editingReminder) { reminder in
                        CustomReminderView(
                            viewModel: CustomReminderViewModel(relationship: viewModel.relationship, editing: reminder)
                        )
                    }
                    .onChange(of: editingReminder) { oldValue, newValue in
                        if newValue == nil {
                            viewModel.loadRelationship()
                        }
                    }
                    // MARK: - Action Buttons
                    HStack(spacing: 12) {
                        Button(action: { showMomentView = true }) {
                            Label("Moment", systemImage: "plus.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .sheet(isPresented: $showMomentView) {
                            MomentView(viewModel: MomentViewModel(relationship: viewModel.relationship))
                        }
                        .onChange(of: showMomentView) { oldValue, newValue in
                            if !newValue {
                                viewModel.loadRelationship()
                                viewModel.loadMoments()
                                hintViewModel.loadHint(
                                    for: viewModel.relationship
                                )
                            }
                        }
                    }
                    
                    // MARK: - Timeline
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Momente")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if viewModel.moments.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                
                                Text("Noch keine Momente")
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        } else {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(Array(viewModel.moments.enumerated()), id: \.element.id) { index, moment in
                                    TimelineCard(
                                        moment: moment,
                                        isLast: index == viewModel.moments.count - 1,
                                        photo: viewModel.photoFor(moment),
                                        participants: viewModel.participants(for: moment)
                                    )                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
                .navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Zurück") { dismiss() }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        if isEditing {
                            Button("Speichern") {
                                viewModel.saveChanges(name: editName, interval: editInterval, birthDate: editBirthDate)
                                isEditing = false
                            }
                            .disabled(editName.isEmpty)
                        } else {
                            Button("Bearbeiten") {
                                startEditing()
                                isEditing = true
                            }
                        }
                    }
                }
            }
            
        }
        .onAppear {
            print("DetailView appeared")
   
            hintViewModel.loadHint(
             for: viewModel.relationship
            )
        }
    }
    
    // MARK: - Helper Functions
    
    func startEditing() {
        editName = viewModel.relationship.name
        editInterval = viewModel.relationship.careRhythm.interval
        editBirthDate = viewModel.relationship.birthDate
        hasBirthDate = viewModel.relationship.birthDate != nil
    }
}
    
    /*#Preview {
        let rel = Relationship(
            name: "Anna",
            plant: Plant(type: "pansy"),
            careRhythm: CareRhythm(interval: 7)
        )
        DetailView(viewModel: DetailViewModel(relationship: rel))
    }*/
