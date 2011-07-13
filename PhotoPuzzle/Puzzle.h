//
//  Puzzle.h
//  PhotoPuzzle
//
//  Created by Gustav Lindbergh on 2011-07-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Puzzle : NSObject 
{
    NSString *puzzleName;
    NSString *imageKey;
    int bestScore;
    UIImage *thumbnail;
    NSData *thumbnailData;
    UIImage *image;
    NSData *imageData;
}

@property (nonatomic, copy) NSString *puzzleName;
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic) int bestScore;
@property (readonly) UIImage *thumbnail;
@property (readonly) UIImage *image;

+ (id) dummyPuzzle;
- (id) initWithPuzzleName:(NSString *)name;
- (void) setThumbnailDataFromImage:(UIImage *)image;
- (void) setImageData:(UIImage *)image;

@end
