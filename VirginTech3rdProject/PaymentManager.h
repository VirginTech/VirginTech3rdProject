//
//  PaymentManager.h
//  GalacticSaga
//
//  Created by OOTANI,Kenji on 2013/05/28.
//
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface PaymentManager : NSObject <SKPaymentTransactionObserver>{
    
}

-(BOOL)buyProduct:(SKProduct*)product;

@end
