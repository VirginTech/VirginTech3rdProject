//
//  PaymentManager.m
//  GalacticSaga
//
//  Created by OOTANI,Kenji on 2013/05/28.
//
//

#import "PaymentManager.h"
#import "GameManager.h"
//#import "InfoLayer.h"

@implementation PaymentManager

UIAlertView* mAlert;
SKProduct* product_;

-(BOOL)buyProduct:(SKProduct*)product{
    
    //NSLog(@"%@",product.localizedTitle);
    product_=product;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //端末設定チェック
    if([SKPaymentQueue canMakePayments]==NO){
        return NO;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    return YES;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
            // 購入処理中
            /*
             * 基本何もしなくてよい。処理中であることがわかるようにインジケータをだすなど。
             */
            mAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Processing",NULL)
                                                message:nil
                                                delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
            [mAlert show];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            indicator.center = CGPointMake(mAlert.bounds.size.width * 0.5f, mAlert.bounds.size.height * 0.5f +10);
            [indicator startAnimating];
            [mAlert addSubview:indicator];
            
        } else if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            // 購入処理成功
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Completed",NULL)
                                                message:[NSString stringWithFormat:
                                                    @"%@%@",product_.localizedTitle,NSLocalizedString(@"Purchase",NULL)]
                                                delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:NSLocalizedString(@"Ok",NULL), nil];
            [alert show];
            /*
             * ここでレシートの確認やアイテムの付与を行う。
             */
            [self bought:product_.productIdentifier];

            [queue finishTransaction:transaction];
            
        } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            // 購入処理エラー。ユーザが購入処理をキャンセルした場合もここにくる
            [queue finishTransaction:transaction];
            // エラーが発生したことをユーザに知らせる
            if (transaction.error.code == SKErrorUnknown) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                message:[transaction.error localizedDescription]
                                                delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:NSLocalizedString(@"Ok",NULL), nil];
                [alert show];
            }
            
        } else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            // リストア処理完了
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Restored",NULL)
                                                    message:[NSString stringWithFormat:
                                                        @"%@%@",product_.localizedTitle,NSLocalizedString(@"Get",NULL)]
                                                    delegate:nil
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Ok",NULL), nil];
            [alert show];
            /*
             * アイテムの再付与を行う
             */
            [self bought:product_.productIdentifier];
            
            [queue finishTransaction:transaction];
        } else {
            [queue finishTransaction:transaction];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 途中で止まった処理を再開する Consumable アイテムにも有効
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    // リストアの失敗
}
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    // 全てのリストア処理が終了
}

//終了処理
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [mAlert dismissWithClickedButtonIndex:0 animated:NO];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)bought:(NSString*)productIds
{
    
    if([productIds isEqualToString:@"VirginTech2ndProject_Ticket10"])
    {
        //[GameManager save_Ticket_Count:[GameManager load_Ticket_Count]+10];
    }
    else if([productIds isEqualToString:@"VirginTech2ndProject_Ticket20"])
    {
        //[GameManager save_Ticket_Count:[GameManager load_Ticket_Count]+20];
    }
    else if([productIds isEqualToString:@"VirginTech2ndProject_Ticket30"])
    {
        //[GameManager save_Ticket_Count:[GameManager load_Ticket_Count]+30];
    }
    else if([productIds isEqualToString:@"VirginTech2ndProject_Ticket50"])
    {
        //[GameManager save_Ticket_Count:[GameManager load_Ticket_Count]+50];
    }
    else if([productIds isEqualToString:@"VirginTech2ndProject_Ticket100"])
    {
        //[GameManager save_Ticket_Count:[GameManager load_Ticket_Count]+100];
    }

    //[InfoLayer update_Ticket];
    //NSLog(@"%@",productIds);
}

@end
