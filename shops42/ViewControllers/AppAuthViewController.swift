//
//  AppAuthViewController.swift
//  shops24
//
//  Created by Diederick de Buck on 05/12/2022.
//

import Foundation
import UIKit
import AppAuth


class AppAuthViewController: UIViewController {
    
    private var authState: OIDAuthState?
    private var authorizationFlow: OIDExternalUserAgentSession?
    
    func setAuthState(_ authState: OIDAuthState?) {
        self.authState = authState
    }
    
//    func setAuthorizationFlow(_ authorizationFlow: OIDExternalUserAgentSession?) {
//        self.authorizationFlow = authorizationFlow
//    }
    
    static func createAuthorizeURL(shop: String, endpoint: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ShopifyURIComponent.schema.rawValue
        components.host = "\(shop)\(ShopifyURIComponent.host.rawValue)"
        components.path = endpoint
        return components
    }
    
    static func createAccessTokenURL(shop: String, endpoint: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = ShopifyURIComponent.schema.rawValue
        components.host = "\(shop)\(ShopifyURIComponent.host.rawValue)"
        components.path = endpoint
        return components
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let shop: String = UserDefaults.standard.string(forKey: UserDefaultsKey.selectedShop.rawValue)!
        super.viewDidAppear(true)
        
        
        let configuration = OIDServiceConfiguration(
            authorizationEndpoint:
                AppAuthViewController.createAuthorizeURL(
                    shop: shop,
                    endpoint: AppAuthEndpoint.authorize.rawValue).url!,
            tokenEndpoint:
                AppAuthViewController.createAccessTokenURL(
                    shop: shop,
                    endpoint: AppAuthEndpoint.access.rawValue).url!
        )
        let scopes = [
            AppAuthScope.read_customers.rawValue,
            AppAuthScope.read_orders.rawValue,
            AppAuthScope.read_products.rawValue,
            AppAuthScope.read_shipping.rawValue
        ]
        
        let request = OIDAuthorizationRequest(
            configuration: configuration,
            clientId: AppAuthSecrets.consumerKey.rawValue,
            clientSecret: AppAuthSecrets.consumerSecret.rawValue,
            scopes: scopes,
            redirectURL: URL(string: AppAuthSecrets.redirectURI.rawValue)!,
            responseType: OIDResponseTypeCode,
            additionalParameters: nil
        )
        self.authorizationFlow = OIDAuthState.authState(
            byPresenting: request,
            presenting: self
        ) { authState, error in
            if let authState = authState {
                self.setAuthState(authState)
                let secret: String = (authState.lastTokenResponse?.accessToken)!
                for tuple in authState.lastAuthorizationResponse.additionalParameters! {
                    if tuple.key == AppAuthToken.shop.rawValue {
                        let shop = tuple.value as! String
                            Security.authorizeShop(shop, secret: secret)
                    }
                }
            } else {
                self.setAuthState(nil)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
