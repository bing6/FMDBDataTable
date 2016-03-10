//
//  FMDTUpdateObjectCommand.h
//  FMDataTable
//
//  Created by bing.hao on 16/3/9.
//  Copyright © 2016年 bing.hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDTCommand.h"

@interface FMDTUpdateObjectCommand : NSObject<FMDTCommand>

- (FMDTUpdateObjectCommand *)add:(FMDTObject *)obj;
- (FMDTUpdateObjectCommand *)addWithArray:(NSArray *)array;

- (void)saveChanges;
- (void)saveChangesInBackground:(void(^)())complete;

@end
