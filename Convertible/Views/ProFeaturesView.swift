import SwiftUI


struct ProFeaturesView: View {
    var onBuy: () -> Void
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("Pro Features")
                .font(.largeTitle.bold())
                .foregroundColor(Color(hex: "#913d63"))
            VStack(alignment: .leading, spacing: 20) {
                Label("Unlimited conversions", systemImage: "infinity")
                Label("Faster performance", systemImage: "bolt.fill")
                Label("Future premium export formats", systemImage: "star.fill")
            }
            .font(.title3)
            .foregroundColor(Color(hex: "#913d63"))
            .padding(.horizontal)
            Spacer()
            Button(action: onBuy) {
                Text("Buy Pro $8.99")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#913d63"))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .background(Color(hex: "#f0dfe6").ignoresSafeArea())
    }
}

#Preview {
    ProFeaturesView(onBuy: { return })
        .modelContainer(for: Item.self, inMemory: true)
}
