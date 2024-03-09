import SwiftUI

struct LensEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let lens: Lens?
    
    @State private var make: String = ""
    @State private var model: String = ""
    @State private var maxAperture: Float?
    @State private var minAperture: Int?
    @State private var focalLength: Int?
    
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
            
            TextField("Max Aperture", value: $maxAperture, format: .number)
            #if !os(macOS) && !os(watchOS)
                .keyboardType(.decimalPad)
            #endif
            
            TextField("Min Aperture", value: $minAperture, format: .number)
            #if !os(macOS) && !os(watchOS)
                .keyboardType(.numberPad)
            #endif
            TextField("Focal Length", value: $focalLength, format: .number)
            #if !os(macOS) && !os(watchOS)
                .keyboardType(.decimalPad)
            #endif
        }.onAppear {
            make = lens?.make ?? ""
            model = lens?.model ?? ""
            maxAperture = lens?.maxAperture
            minAperture = lens?.minAperture
            focalLength = lens?.focalLength
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
        }
        .navigationTitle(navigationTitle)
        .macOSSheet()
    }
    
    func save() {
        if let lens {
            lens.make = make
            lens.model = model
            lens.maxAperture = maxAperture
            lens.minAperture = minAperture
            lens.focalLength = focalLength
        } else {
            modelContext.insert(
                Lens(make: make,
                     model: model,
                     maxAperture: maxAperture,
                     minAperture: minAperture,
                     focalLength: focalLength)
            )
        }
        
        try? modelContext.save()
    }
}
