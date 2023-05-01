import RevenueCat
import StoreKit

class StoreViewModel: NSObject, ObservableObject {
    // MARK: - Constants

    // This must match the value in the file Configuration.storekit.
    let productId = "r.mark.volkmann.gmail.com.GiftTrack"
    let revenueCatAPIKey = "appl_oYZoWVaTYyQNiKMuecCeaRxNdal"

    // MARK: - Initializer

    override init() {
        super.init()
        Task {
            do {
                Purchases.configure(withAPIKey: revenueCatAPIKey)
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

    var package: Package? // RevenueCat

    // We only offer one product and it is non-consumable
    // meaning that once purchased it is owned forever.
    private var product: Product!

    // MARK: - Methods

    func checkEntitlement() async {
        // This app only has one entitlement corresponding
        // to the one and only in-app purchase option.

        /* StoreKit approach
        let entitlement = await product.currentEntitlement
        switch entitlement {
        case .none:
            break
        case .some:
            Task { @MainActor in appPurchased = true }
        }
        */

        // RevenueCat approach
        do {
            appPurchased = try await Purchases.shared.customerInfo()
                .entitlements["pro"]?.isActive ?? false
        } catch {
            appPurchased = false
            Task { @MainActor in
                message = "Error: \(error)"
                haveMessage = true
            }
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
        // StoreKit approach
        /*
        let products = try await Product.products(for: [productId])
        product = products.first!
        */

        // RevenueCat approach
        let offerings = try await Purchases.shared.offerings()
        guard let currentOffering = offerings.current else {
            throw "Couldn't find the current offering!"
        }
        let packages = currentOffering.availablePackages
        package = packages.first
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
                // StoreKit approach
                /*
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
                }
                */

                // RevenueCat approach
                guard let package = package else {
                    throw "Couldn't find the package."
                }
                let result = try await Purchases.shared
                    .purchase(package: package)
                self.appPurchased = result.customerInfo.entitlements["pro"]?
                    .isActive ?? false
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
