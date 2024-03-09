import SwiftData
import SwiftUI

struct LensPicker: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var lens: Lens?
    @Query private var lenses: [Lens]
    
    var body: some View {
        List {
            ForEach(lenses) { lens in
                Button {
                    self.lens = lens
                    dismiss()
                } label: {
                    HStack {
                        Text("\(lens.make) \(lens.model)")
                        
                        Spacer()
                        
                        if lens == self.lens {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Lens")
    }
}
