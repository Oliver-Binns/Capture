import SwiftUI

struct LensEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let lens: Lens?
    
    @State private var make: String = ""
    @State private var model: String = ""
    
    private var navigationTitle: String {
        lens == nil ?
            "Add Lens" :
            "Edit Lens"
    }
    
    private var isInvalid: Bool {
        make.isEmpty && model.isEmpty
    }
    
    var body: some View {
        Form {
            TextField("Make", text: $make)
            TextField("Model", text: $model)
        }.onAppear {
            make = lens?.make ?? ""
            model = lens?.model ?? ""
        }.toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Save") {
                    save()
                    dismiss()
                }.disabled(isInvalid)
            }
            
            if lens == nil {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }.navigationTitle(navigationTitle)
    }
    
    func save() {
        if let lens {
            lens.make = make
            lens.model = model
        } else {
            modelContext.insert(Lens(make: make, model: model))
        }
        
        try? modelContext.save()
    }
}
