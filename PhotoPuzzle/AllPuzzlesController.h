//
//  AllPuzzlesController.h
//  PhotoPuzzle
//
//  Created by Gustav Lindbergh on 2011-08-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewPuzzleController, Puzzle, PuzzleController;

@protocol AllPuzzlesDelegate

- (void)receivePuzzle:(Puzzle *)message;
- (void)receiveRemoveOrder;

@end


@interface AllPuzzlesController : UIViewController <AllPuzzlesDelegate>
{ 
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *noPuzzlesLabel;
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIButton *infoButton;
    
    NSMutableArray *puzzles;
    
    NewPuzzleController *newPuzzleController;
    PuzzleController *puzzleController;
    
    Puzzle *selectedPuzzle;
    int currentIndex;

}

@property (nonatomic, retain) NSMutableArray *puzzles;

- (IBAction) newPuzzle:(id)sender;
- (IBAction) prevPuzzle:(id)sender;
- (IBAction) nextPuzzle:(id)sender;
- (IBAction) startGame:(id)sender;
- (IBAction) showInfo:(id)sender;

- (void) changePuzzleToIndex:(int)index inDirection:(int)direction;
- (void) enableButtons;

@end
