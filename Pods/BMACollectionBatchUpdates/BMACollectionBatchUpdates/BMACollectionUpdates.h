/*
 The MIT License (MIT)
 
 Copyright (c) 2015-present Badoo Trading Limited.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol BMAUpdatableCollectionItem <NSObject>
@property (nonatomic, readonly, copy) NSString *uid;
@optional
@property (nonatomic, readonly, nullable) id userInfo;

@end

@protocol BMAUpdatableCollectionSection <BMAUpdatableCollectionItem>
@property (nonatomic, copy) NSArray<id<BMAUpdatableCollectionItem>> *items;
@end

typedef NS_ENUM(NSInteger, BMACollectionUpdateType) {
    BMACollectionUpdateTypeInsert,
    BMACollectionUpdateTypeDelete,
    BMACollectionUpdateTypeMove,
    BMACollectionUpdateTypeReload
};

@interface BMACollectionUpdate : NSObject

@property (nonatomic, readonly) BMACollectionUpdateType type;
@property (nonatomic, readonly) id object;
@property (nonatomic, readonly, getter=isItemUpdate) BOOL itemUpdate;
@property (nonatomic, readonly, getter=isSectionUpdate) BOOL sectionUpdate;

/// Generates updates for UICollectionView/UITableView
/// @param oldSections old list of sections: array of BMAUpdatableCollectionSection instances
/// @param newSections new list of sections: array of BMAUpdatableCollectionSection instances
/// @param sectionsPriorityOrder array of section identifiers, in order for which sections are to be proceeded when checking items uniqueness; if nil then sections are processed in natural order; may contain not all section ids, only ones that should be processed first
/// @param eliminatesDuplicates flag indicating duplicated items in different sections are to be eliminated during update
/// @param completion block used to return results: sections and changes may be nil, in this case UICollectionview/UITableView is supposed be reload completely using -reloadData
+ (void)calculateUpdatesForOldModel:(NSArray<id<BMAUpdatableCollectionSection>> *)oldSections
                           newModel:(NSArray<id<BMAUpdatableCollectionSection>> *)newSections
              sectionsPriorityOrder:(nullable NSArray<NSString *> *)sectionsPriorityOrder
               eliminatesDuplicates:(BOOL)eliminatesDuplicates
                         completion:(void (^)(NSArray<id<BMAUpdatableCollectionSection>> *sections, NSArray<BMACollectionUpdate *> *__nullable updates))completion;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(BMACollectionUpdateType)type object:(id)object NS_DESIGNATED_INITIALIZER;

@end

@interface BMACollectionItemUpdate : BMACollectionUpdate

@property (nonatomic, nullable) NSIndexPath *indexPath;
@property (nonatomic, nullable) NSIndexPath *indexPathNew;

+ (instancetype)updateWithType:(BMACollectionUpdateType)type
                     indexPath:(nullable NSIndexPath *)indexPath
                  newIndexPath:(nullable NSIndexPath *)newIndexPath
                        object:(id)object;

@end

@interface BMACollectionSectionUpdate : BMACollectionUpdate

@property (nonatomic) NSUInteger sectionIndex;
@property (nonatomic) NSUInteger sectionIndexNew;

+ (instancetype)updateWithType:(BMACollectionUpdateType)type
                  sectionIndex:(NSUInteger)sectionIndex
               newSectionIndex:(NSUInteger)newSectionIndex
                        object:(id)object;

@end

NS_ASSUME_NONNULL_END
