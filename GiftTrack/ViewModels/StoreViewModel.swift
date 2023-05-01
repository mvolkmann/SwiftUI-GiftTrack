import StoreKit

class StoreViewModel: NSObject, ObservableObject {
    // MARK: - Constants

    // This must match the value in the file Configuration.storekit.
    var productId = "r.mark.volkmann.gmail.com.GiftTrack"

    // MARK: - Initializer

    override init() {
        super.init()
        Task {
            do {
                try await getProduct()
                await checkEntitlement()
                restorePurchase()
                try await listenForTransactions()
            } catch {
                print("StoreViewModel.init: error =", error)
            }
        }
    }

    // MARK: - Properties

    @Published var appPurchased = false
    @Published var haveMessage = false
    @Published var message = ""

    // We only offer one product and it is non-consumable
    // meaning that once purchased it is owned forever.
    private var product: Product!

    // MARK: - Methods

    func checkEntitlement() async {
        // This app only has one entitlement corresponding
        // to the one and only in-app purchase option.
        let entitlement = await product.currentEntitlement
        switch entitlement {
        case .none:
            break
        case .some:
            Task { @MainActor in appPurchased = true }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case let .unverified(_, error):
            throw error
        case let .verified(safe):
            return safe
        }
    }

    func getProduct() async throws {
        let products = try await Product.products(for: [productId])
        product = products.first!
    }

    private func listenForTransactions() async throws {
        // print("StoreKitViewModel: listenForTransactions: entered")
        // TODO: Why don't we get transactions on a new device?
        // TODO: Try with your iPhone and iPad where the app
        // TODO: is purchased on one and not on the other.
        for await result in Transaction.updates {
            let transaction = try checkVerified(result)
            try await updateCustomerProductStatus()

            Task { @MainActor in appPurchased = true }

            // TODO: Does this restore previous in-app purchases?
            await transaction.finish()
        }
    }

    func purchaseApp() {
        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case let .success(verification):
                    switch verification {
                    case .unverified:
                        print("StoreViewModel.purchaseApp: purchase unverified")
                    case .verified:
                        Task { @MainActor in appPurchased = true }
                    }
                case .userCancelled:
                    break
                default:
                    Task { @MainActor in
                        message = "In-app purchase failed: \(result)"
                        haveMessage = true
                    }
                }
            } catch {
                Task { @MainActor in
                    message = "Error: \(error)"
                    haveMessage = true
                }
            }
        }
    }

    func restorePurchase() {
        Task { @MainActor in
            do {
                try await AppStore.sync()
                message = "Your in-app purchase was restored."
            } catch {
                print("StoreViewModel.restorePurchase: error =", error)
                message = "Failed to restore your in-app purchase."
            }
            haveMessage = true
        }
    }

    private func updateCustomerProductStatus() async throws {
        for await result in Transaction.currentEntitlements {
            let transaction = try checkVerified(result)
            try await updateCustomerProductStatus()
            if transaction.productType == .nonConsumable {
                Task { @MainActor in self.appPurchased = true }
            }
        }
    }
}
