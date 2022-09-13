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
                try await listenForTransactions()
            } catch {
                print("StoreViewModel.init: error =", error)
            }
        }
    }

    // MARK: - Properties

    @Published var appPurchased = false
    @Published var purchaseFailed = false

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
            DispatchQueue.main.async { self.appPurchased = true }
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case let .unverified(_, error):
            throw error
        case .verified(let safe):
            return safe
        }
    }

    func getProduct() async throws {
        let products = try await Product.products(for: [productId])
        product = products.first!
    }

    private func listenForTransactions() async throws {
        // TODO: Why don't we get transactions on a new device?
        // TODO: Try with your iPhone and iPad where the app
        // TODO: is purchased on one and not on the other.
        for await result in Transaction.updates {
            let transaction = try self.checkVerified(result)
            try await self.updateCustomerProductStatus()

            print("StoreKitViewModel: listenForTransacgtions: transaction =", transaction)

            DispatchQueue.main.async { self.appPurchased = true }

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
                        DispatchQueue.main.async { self.appPurchased = true }
                    }
                case .userCancelled:
                    break
                default:
                    print("StoreViewModel.purchaseApp: failed, result =", result)
                    DispatchQueue.main.async { self.purchaseFailed = true }
                }
            } catch {
                print("StoreViewModel.purchaseApp: error =", error)
                DispatchQueue.main.async { self.purchaseFailed = true }
            }
        }
    }

    func restorePurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    private func updateCustomerProductStatus() async throws {
        for await result in Transaction.currentEntitlements {
            let transaction = try self.checkVerified(result)
            try await self.updateCustomerProductStatus()
            print("StoreKitViewModel: updateCustomerProductStatus: transaction =", transaction)
            if transaction.productType == .nonConsumable {
                DispatchQueue.main.async { self.appPurchased = true }
            }
        }
    }
}
