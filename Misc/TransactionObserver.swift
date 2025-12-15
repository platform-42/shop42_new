//
//  Transactions.swift
//  shops42
//
//  Created by Diederick de Buck on 25/07/2024.
//


import Foundation
import StoreKit
import P42_utils


@MainActor
final class TransactionObserver: ObservableObject {
    
    @Published var hasSubscription: Bool
    var updates: Task<Void, Never>? = nil
    
    init() {
        self.hasSubscription = UserDefaults.standard.bool(forKey: UserDefaultsKey.hasLicense.rawValue)
        self.updates = newTransactionListenerTask()
    }


    deinit {
        self.updates?.cancel()
    }
    
    
    private func newTransactionListenerTask() -> Task<Void, Never> {
        Task(priority: .background) {
            print("\(String(describing: type(of: self))).\(#function)")
            for await verificationResult in Transaction.updates {
                self.handle(updatedTransaction: verificationResult)
            }
        }
    }
    
    
    private func handle(updatedTransaction verificationResult: VerificationResult<Transaction>) {
        print("\(String(describing: type(of: self))).\(#function)")
        guard case .verified(let transaction) = verificationResult else {
            // reject - unknown
            self.hasSubscription = false
            UserDefaults.standard.set(self.hasSubscription, forKey: UserDefaultsKey.hasLicense.rawValue)
            UserDefaults.standard.set(Date().toString(.date), forKey: UserDefaultsKey.renewalDate.rawValue)
            print("*** REJECT - UNKNOWN SOURCE ***")
            return
        }
        if let revocationDate = transaction.revocationDate {
            // reject - revoked
            print(revocationDate)
            self.hasSubscription = false
            UserDefaults.standard.set(self.hasSubscription, forKey: UserDefaultsKey.hasLicense.rawValue)
            UserDefaults.standard.set(Date().toString(.date), forKey: UserDefaultsKey.renewalDate.rawValue)
            print("*** REJECT - REVOKED ***")
            return
        }
        if let expirationDate = transaction.expirationDate, expirationDate < Date() {
            // reject - expired
            print(expirationDate)
            self.hasSubscription = false
            UserDefaults.standard.set(self.hasSubscription, forKey: UserDefaultsKey.hasLicense.rawValue)
            UserDefaults.standard.set(Date().toString(.date), forKey: UserDefaultsKey.renewalDate.rawValue)
            print("*** REJECT - EXPIRED ***")
            return
        }
        if transaction.isUpgraded {
            // do nothing - wait
            print("*** WAIT - IN PROGRESS ***")
            return
        }
        // accept - enable
        self.hasSubscription = true
        UserDefaults.standard.set(self.hasSubscription, forKey: UserDefaultsKey.hasLicense.rawValue)
        UserDefaults.standard.set(transaction.expirationDate?.toString(.date), forKey: UserDefaultsKey.renewalDate.rawValue)
        print("*** ACCEPTED - ENABLED ***")
    }
}

