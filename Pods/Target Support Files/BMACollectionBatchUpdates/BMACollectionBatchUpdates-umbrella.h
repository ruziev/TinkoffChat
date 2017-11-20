#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BMACollectionUpdates.h"
#import "UICollectionView+BMABatchUpdates.h"
#import "UITableView+BMABatchUpdates.h"

FOUNDATION_EXPORT double BMACollectionBatchUpdatesVersionNumber;
FOUNDATION_EXPORT const unsigned char BMACollectionBatchUpdatesVersionString[];

