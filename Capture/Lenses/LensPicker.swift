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
                    Text("\(lens.make) \(lens.model)")
                }
            }
        }
        .navigationTitle("Select Lens")
    }
}
