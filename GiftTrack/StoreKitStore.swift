import StoreKit

class StoreKitStore: NSObject, ObservableObject {
    // MARK: - Constants

    // This must match the value in the file Configuration.storekit.
    var productId = "r.mark.volkmann.gmail.com.GiftTrack"

    // MARK: - Initializer

    override init() {
        super.init()
        Task {
            do {
                try await getProduct()
                // print("product =", product)
                await checkEntitlement()
                await listenForTransactions()
            } catch {
                print("error while loading products: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Properties

    @Published var appPurchased = false
    // @Published var appPurchaseRestored = false
    @Published var purchaseFailed = false

    // We only offer one product and it is non-consumable
    // meaning that once purchased it is owned forever.
    private var product: Product!

    // MARK: - Methods

    func checkEntitlement() async {
        // This app only has one entitlement corresponding
        // to the one and only in-app purchase option.
        let entitlement = await product.currentEntitlement
        // print("checkEntitlement: entitlement =", entitlement)
        switch entitlement {
        case .none:
            break
        case .some:
            DispatchQueue.main.async { self.appPurchased = true }
        }
    }

    func getProduct() async throws {
        let products = try await Product.products(for: [productId])
        product = products.first!
    }

    func listenForTransactions() async {
        // print("listenForTransactions: entered")
        // TODO: Why don't we get transactions on a new device?
        // TODO: Try with your iPhone and iPad where the app
        // TODO: is purchased on one and not on the other.
        for await result in Transaction.updates {
            // print("listenForTransactions: result =", result)
            if case let .verified(transaction) = result {
                // print("listenForTransactions: transaction =", transaction)
                DispatchQueue.main.async { self.appPurchased = true }
                // TODO: Does this alone restore previous in-app purchases?
                await transaction.finish()
            }
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
                        print("purchase unverified")
                    case .verified:
                        print("purchase verified")
                        DispatchQueue.main.async { self.appPurchased = true }
                    }
                case .userCancelled:
                    break
                default:
                    // print("StoreKitStore.purchaseApp: failed, result =", result)
                    DispatchQueue.main.async { self.purchaseFailed = true }
                }
            } catch {
                print("purchase failed: error =", error)
                DispatchQueue.main.async { self.purchaseFailed = true }
            }
        }
    }

    func restorePurchase() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
