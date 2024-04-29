//
//  TipStore.swift
//  BuildingATipJar
//
//  Created by Marcin Jędrzejak on 29/04/2024.
//

import Foundation
import StoreKit

enum TipsError: Error {
    case failedVerification
}

enum TipsAction {
    case successful
}

typealias PurchaseResult = Product.PurchaseResult

final class TipStore: ObservableObject {

    @Published private(set) var items = [Product]()
    @Published private(set) var action: TipsAction?

    init() {
        Task { [weak self] in
            await self?.retrieveProducts()
        }
    }

    func purchase(_ item: Product) async {
        do {
            let result = try await item.purchase()
            
            try await handlePurchase(from: result)
        } catch {
            // TODO: Handle Error
            print(error)
        }
    }

    func reset() {
        action = nil
    }
}

private extension TipStore {

    @MainActor
    func retrieveProducts() async {
        do {
            let products = try await Product.products(for: myTipProductIdentifiers).sorted(by: { $0.price < $1.price })
            items = products
        } catch {
            // TODO: Handle Error
            print(error)
        }
    }

    func handlePurchase(from result: PurchaseResult) async throws {
        switch result {

        case .success(let verification):
            print("Purchase was a success, now it's time to verify their purchase")

            let transaction = try checkVerified(verification)

            action = .successful
            
            await transaction.finish()

        case .pending:
            print("The user needs to complete some action on their account before they can complete purchase")

        case .userCancelled:
            print("The user hit cancel before their transaction started")

        default:
            break
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(let signedType, let verificationError):
            print("The verification of the user failed")
            throw TipsError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}
