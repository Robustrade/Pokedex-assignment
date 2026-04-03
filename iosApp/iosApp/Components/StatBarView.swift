import SwiftUI

struct StatBarView: View {
    
    let label: String
    let value: Int32
    
    var body: some View {
        HStack(spacing: 12) {
            Text(label.capitalized)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Text("\(value)")
                .font(.caption.weight(.semibold).monospacedDigit())
                .frame(width: 32,alignment: .leading)
            
            ProgressView(value: Double(value)/100.0)
                .progressViewStyle(.linear)
                .tint(StatColor.color(for: value))
        }
    }
}
