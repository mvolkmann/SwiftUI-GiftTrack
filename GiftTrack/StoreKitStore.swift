import StoreKit
import MapKit

class StoreKitStore: NSObject, ObservableObject {
    @Published var appPurchased = false
    
    var productId = "r.mark.volkmann-gmail.com.gift-track"

    typealias FetchCompletionHandler = ([SKProduct]) -> Void
    typealias PurchaseCompletionHandler = (SKPaymentTransaction?) -> Void
    
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var fetchedProducts: [SKProduct] = []
    private var productsRequest: SKProductsRequest?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?

    override init() {
        super.init()
        
        startObservingPaymentQueue()
        
        fetchProducts { products in
            print("products =", products)
        }
    }
    
    private func buy(
        _ product: SKProduct,
        completion: @escaping PurchaseCompletionHandler
    ) {
        purchaseCompletionHandler = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    private func fetchProducts(
        _ completion: @escaping FetchCompletionHandler
    ) {
        guard productsRequest == nil else { return }
        fetchCompletionHandler = completion
        productsRequest =
            SKProductsRequest(productIdentifiers: [productId])
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    func purchaseApp() {
        let product = fetchedProducts.first
        if let product = product {
            purchaseProduct(product)
        } else {
            print("no product to purchase")
        }
    }
    
    private func purchaseProduct(_ product: SKProduct) {
        startObservingPaymentQueue()
        buy(product) { _ in } // no-op
    }
    
    private func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
}

extension StoreKitStore: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            var shouldFinishTransactions = false
            
            switch transaction.transactionState {
            case .failed:
                shouldFinishTransactions = true
            case .purchased, .restored:
                if transaction.payment.productIdentifier == productId {
                    appPurchased = true
                }
                shouldFinishTransactions = true
            default:
                break
            }
            
            if shouldFinishTransactions {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
        }
    }
    
    
}

extension StoreKitStore: SKProductsRequestDelegate {
    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        guard !loadedProducts.isEmpty else {
            print("failed to load products")
            if !invalidProducts.isEmpty {
                print("invalid products found: \(invalidProducts)")
            }
            productsRequest = nil
            return
        }

        // Cache the fetched products.
        fetchedProducts = loadedProducts

        // Notify listeners of fetched products.
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedProducts)
            self.fetchCompletionHandler = nil
            self.productsRequest = nil
        }
    }
}
