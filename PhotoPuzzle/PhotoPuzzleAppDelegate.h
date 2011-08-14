//
//  PhotoPuzzleAppDelegate.h
//  PhotoPuzzle
//
//  Created by Gustav Lindbergh on 2011-07-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PuzzleController;
@class PuzzleTableController;
@class NewPuzzleController;

@interface PhotoPuzzleAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    PuzzleController *puzzleController;
    PuzzleTableController *puzzleTableController;
    NewPuzzleController *newPuzzleController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) PuzzleController *puzzleController;

@end
