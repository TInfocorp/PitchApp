//
//  OCDView.m
//  OCDView
//
//  Created by Patrick Gibson on 2/15/13.
//

#import <QuartzCore/QuartzCore.h>

#import "OCDView.h"
#import "OCDView_Private.h"

#import "OCDNode.h"
#import "OCDSelection_Private.h"
#import "OCDNode_Private.h"

@interface OCDView ()

@end

@implementation OCDView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nodes = [[NSMutableArray alloc] initWithCapacity:10];
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
    }
    return self;
}
- (OCDSelection *)selectAllWithIdentifier:(NSString *)identifier;
{
    OCDSelection *selection = [[OCDSelection alloc] init];
    selection.identifier = identifier;
    
    // Search view for existing nodes with given identifier.
    NSMutableArray *existingNodes = [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray *existingData = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (OCDNode *node in self.nodes) {
        if ([node.identifier isEqualToString:identifier]) {
            [existingNodes addObject:node];
            [existingData addObject:node.data];
        }
    }
        
    // Attache the selection to the nodes.
    selection.selectedNodes = existingNodes;
    selection.dataArray = existingData;
    
    return selection;
}

- (void)appendNode:(OCDNode *)node;
{
    // Ensure the node doesn't already exist in the view
    if ([self.nodes containsObject:node]) {
        return;
    }
    
    // Add the sublayer
    node.view = self;
    
    [self.layer addSublayer:node.shapeLayer];
    [self.nodes addObject:node];
}

- (void)appendNode:(OCDNode *)node
    withTransition:(OCDNodeAnimationBlock)transition
        completion:(OCDNodeAnimationCompletionBlock)completion;
{
    [self appendNode:node];
    [node updateAttributes];
    [node setTransition:transition completion:completion];
    [node runAnimations];    
}

- (void)remove:(OCDNode *)node;
{
    [node.shapeLayer removeFromSuperlayer];
    [self.nodes removeObject:node];
}

@end
