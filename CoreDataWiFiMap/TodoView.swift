//
//  TodoView.swift
//  CoreDataWiFiMap
//
//  Created by Tyler on 2024-10-27.
//

import SwiftUI

struct TodoView: View {
    
    @State private var noteTitle: String = ""
    @State private var noteCompleted: String = ""
    private var noteTable = NotesTable.shared
    @State var allNotes = [Notes]()
    
    var body: some View {
        VStack {
            Group {
                TextField("Note title", text: $noteTitle)
                TextField("Note completed", text: $noteCompleted)
            }
            .padding()
            .onSubmit {
                if !noteTitle.isEmpty, !noteCompleted.isEmpty {
                    let isCompleted = Int(noteCompleted)!
                    let note = Notes(noteTitle: noteTitle, noteCompleted: isCompleted)
                    Task {
                        await noteTable.insert(note: note)
                    }
                }
            }
                    
            
            Button {
                Task {
                    let allNotes = await noteTable.getAllCompetedNotes()
                    self.allNotes = allNotes
                    print(allNotes)
                }
            } label: {
                Text("Get all notes")
            }
            .padding(.top, 50)
            
            List {
                ForEach(allNotes) { note in
                    TextField(note.noteTitle, text: $noteTitle)
                        .onSubmit {
                            Task {
                                var updateNode = note
                                updateNode.noteTitle = noteTitle
                                await noteTable.update(note: updateNode)
                            }
                        }
                }
            }
            .padding()

        }
    }
}

#Preview {
    TodoView()
}
