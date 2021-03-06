//
//  SliderController.m
//  SliderPuzzleDemo
//
//  Created by Joshua Newnham on 15/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PuzzleController.h"
#import "Tile.h"
#import <QuartzCore/QuartzCore.h>

@interface PuzzleController()

@end


@implementation PuzzleController

@synthesize tiles, puzzleImage, toBeMoved;
@synthesize numVerticalPieces, numHorizontalPieces, numMoves;

- (void) viewWillAppear:(BOOL)animated
{
}

- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem *movesBarButtonItem = [[UIBarButtonItem alloc] init];
    movesBarButtonItem.title = @"0";
    [movesBarButtonItem setStyle:UIBarButtonItemStylePlain];
    
    [[self navigationItem] setRightBarButtonItem:movesBarButtonItem];
    
    [movesBarButtonItem release];
	
	self.tiles = [[NSMutableArray alloc] init];
	
	[self initPuzzle:puzzleImage];
    
    blackImageView = [[UIImageView alloc] init];
    
    [super viewDidLoad];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark -

/**
 * take a image path, load the image and break it into tiles to use as our puzzle pieces. 
 **/ 
-(void) initPuzzle:(UIImage *) imagePath {
	UIImage *orgImage = imagePath;
	
	if( orgImage == nil ){
		return; 
	}
	
	[self.tiles removeAllObjects];
	
	tileWidth = orgImage.size.width/numHorizontalPieces;
	tileHeight = orgImage.size.height/numVerticalPieces;
	
	
	
	for( int x=0; x<numHorizontalPieces; x++ ){
		for( int y=0; y<numVerticalPieces; y++ ){
			
			CGPoint orgPosition = CGPointMake(x,y); 
			
			CGRect frame = CGRectMake(tileWidth*x, tileHeight*y, 
									  tileWidth, tileHeight );
			CGImageRef tileImageRef = CGImageCreateWithImageInRect( orgImage.CGImage, frame );
			UIImage *tileImage = [UIImage imageWithCGImage:tileImageRef];
			
			CGRect tileFrame =  CGRectMake((tileWidth+TILE_SPACING)*x, (tileHeight+TILE_SPACING)*y, 
										   tileWidth, tileHeight );
			
			Tile *tileImageView = [[Tile alloc] initWithImage:tileImage];
			tileImageView.frame = tileFrame;
			tileImageView.originalPosition = orgPosition;
			tileImageView.currentPosition = orgPosition;

			CGImageRelease( tileImageRef );
			
			[tiles addObject:tileImageView];
			
			// now add to view
			[self.view insertSubview:tileImageView atIndex:0];
			[tileImageView release];
			
		}
	}
	
	[self shuffle];
}

#pragma mark tile handling methods 

-(void) shuffle
{
	srandom(time(NULL));
	
	for( int i=0; i<SHUFFLE_NUMBER; i++ ){
        
		// randomly select a piece to move 
		NSInteger A = random()%[tiles count];
        NSInteger B = random()%[tiles count];
		//NSLog(@"shuffleRandom using pick: %d from array of size %d", pick, [validMoves count]);
		[self swapTile:[tiles objectAtIndex:A] withTile:[tiles objectAtIndex:B] withAnimation:YES];
	}
    
    if ([self puzzleCompleted]) 
        [self shuffle];
    
    isGameStarted = YES;
}

- (void) playAgain
{
    isGameStarted = NO;
    [self shuffle];
    numMoves = 0;
    [[[self navigationItem] rightBarButtonItem] setTitle:[NSString stringWithFormat:@"%d",numMoves]];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark helper methods 
-(Tile *) getPieceAtPoint:(CGPoint) point
{    
	CGRect touchRect = CGRectMake(point.x, point.y, 1.0, 1.0);
	
	for( Tile *t in tiles ){
		if( CGRectIntersectsRect(t.frame, touchRect) ){
			return t; 
		}		
	}
	return nil;
}

-(BOOL) puzzleCompleted{
	for( Tile *t in tiles ){
		if( t.originalPosition.x != t.currentPosition.x || t.originalPosition.y != t.currentPosition.y ){
			return NO;
		}
	}
	
	return YES; 
}

- (void) swapTile:(Tile *) tile1 withTile:(Tile *) tile2 withAnimation:(BOOL) animate
{
    CGPoint temp = tile1.currentPosition;
	tile1.currentPosition = tile2.currentPosition;
    tile2.currentPosition = temp;
    
	
	int newX1 = tile1.currentPosition.x; 
	int newY1 = tile1.currentPosition.y;
    int newX2 = tile2.currentPosition.x; 
	int newY2 = tile2.currentPosition.y;
    
    //    NSLog(@"newX1: %d", newX1);
    //    NSLog(@"newY1: %d", newY1);
    //    NSLog(@"--------");
    //    NSLog(@"newX2: %d", newX2);
    //    NSLog(@"newY2: %d", newY2);
	
	if( animate ){
		[UIView beginAnimations:@"frame" context:nil];
	}
	tile1.frame = CGRectMake((tileWidth+TILE_SPACING)*newX1, (tileHeight+TILE_SPACING)*newY1, 
                             tileWidth, tileHeight );
    tile2.frame = CGRectMake((tileWidth+TILE_SPACING)*newX2, (tileHeight+TILE_SPACING)*newY2, 
                             tileWidth, tileHeight );
	if( animate ){
		[UIView commitAnimations];
	}
    
    if (isGameStarted && [self puzzleCompleted]) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Puzzle Completed!" message:[NSString stringWithFormat:@"Moves: %d",numMoves] 
                                                       delegate:self cancelButtonTitle:@"Return" otherButtonTitles:@"Play Again",nil];
        [alert show];
        [alert release];
    }
}

#pragma mark user input hanlding 

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
//    if ([self puzzleCompleted]) 
//    {
//        // Gå tillbaks till root
//       [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    
    
	UITouch *touch = [touches anyObject];
    CGPoint currentTouch = [touch locationInView:self.view];	
    
    
    NSLog(@"Touch at %f, %f!",currentTouch.x, currentTouch.y);
    
    
	Tile *t = [self getPieceAtPoint:currentTouch];
    if (t == nil) {
        return;
    }
    
    if (!isMoving) 
    {
//        [t.layer setBorderColor: [[UIColor redColor] CGColor]];
//        [t.layer setBorderWidth: 2.0];
        blackImageView.frame = t.frame;
        blackImageView.backgroundColor = [UIColor blackColor];
        blackImageView.alpha = 0.5;
        [self.view addSubview:blackImageView];
        
        
        [self setToBeMoved:t];
        isMoving = YES;
        
    }
    else
    {
        NSLog(@"Tile at %f, %f!",toBeMoved.currentPosition.x, toBeMoved.currentPosition.y);
        NSLog(@"To be moved to  %f, %f!",t.currentPosition.x, t.currentPosition.y);
        isMoving = NO;
//        [toBeMoved.layer setBorderColor: [[UIColor clearColor] CGColor]];
//        [toBeMoved.layer setBorderWidth: 2.0];
        
        [blackImageView removeFromSuperview];
        if (toBeMoved.currentPosition.x != t.currentPosition.x || toBeMoved.currentPosition.y != t.currentPosition.y) 
        {
            // Öka move count
            numMoves++;
            [[[self navigationItem] rightBarButtonItem] setTitle:[NSString stringWithFormat:@"%d",numMoves]];
            
            [self swapTile:toBeMoved withTile:t withAnimation:YES];
        }
    }
    
    
}

- (void)dealloc {
	[tiles release];
    [toBeMoved release];
    [puzzleImage release];
    
    [super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{ 
    switch(buttonIndex) 
    {
        case 0:
            [[self navigationController] popViewControllerAnimated:YES];
            break;
        case 1:
            [self playAgain];
            break;
        default:
            break;
    }
}


@end
