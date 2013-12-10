//
//  TransitionManager.h
//

#import <Foundation/Foundation.h>

@interface TransitionManager : NSObject

- (id)init:(UINavigationController *)navigationController;
- (void)rollBack;

@end
