import SwiftUI

struct PaywallModalView: View {
    @Binding var isPresented: Bool
    var product: ProductProtocol?
    var message: String?
    var onBuy: (@escaping (Bool) -> Void) -> Void
    var onRestore: () -> Void
    @State private var animateIn = false
    @State private var isLoading = false
    @State private var purchaseSuccess = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()
                .onTapGesture { withAnimation { isPresented = false } }
            VStack(spacing: 20) {
                Image("Convertible")
                    .resizable()
                    .frame(width: 72, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    .shadow(radius: 6)
                Text("Upgrade to Pro")
                    .font(.title.bold())
                    .foregroundColor(Theme.accentColor)
                if let message = message {
                    Text(message)
                        .font(.headline)
                        .foregroundColor(Theme.accentColor)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 4)
                }
                Button(action: {
                    isLoading = true
                    onBuy { success in
                        isLoading = false
                        if success {
                            withAnimation { isPresented = false }
                        }
                    }
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Buy Pro \(product?.displayPrice ?? "$8.99")")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(Theme.accentColor)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                Button("Maybe Later") {
                    withAnimation { isPresented = false }
                }
                .font(.body)
                .foregroundColor(.gray)
            }
            .frame(maxWidth: 340)
            .padding()
            .background(Theme.backgroundColor)
            .cornerRadius(Theme.cornerRadius)
            .shadow(color: Theme.shadow, radius: Theme.shadowRadius)
            .scaleEffect(animateIn ? 1 : 0.8)
            .opacity(animateIn ? 1 : 0)
            .offset(y: animateIn ? 0 : 40)
            .onAppear { withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) { animateIn = true } }
            .onDisappear { animateIn = false }
        }
        .zIndex(2)
    }
} 
