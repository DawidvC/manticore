/** \file  OutlineViewDataSource.h
 * \author Korei Klein
 * \date 7/27/09
 *
 */

#import <Cocoa/Cocoa.h>
#import "GroupFilter.h"
@class LogDoc;
struct LogFileDesc;
struct Group;

/** OutlineViewDataSource implements the NSOutlineViewDataSource informal protocol.
 * It displays an outline for Groups.
 */
@interface OutlineViewDataSource : GroupFilter {
    struct LogFileDesc *desc;
    struct Group *root;
    NSMutableDictionary *map;
    
    NSMutableArray *boxes; //< For GC
}


- (OutlineViewDataSource *)initWithLogDesc:(struct LogFileDesc *)descVal
				    logDoc:logDocVal;


- (id)outlineView:(NSOutlineView *)outlineView
	    child:(NSInteger)index
	   ofItem:(id)item;

- (BOOL)outlineView:(NSOutlineView *)outlineView
   isItemExpandable:(id)item;

- (NSInteger)outlineView:(NSOutlineView *)outlineView
  numberOfChildrenOfItem:(id)item;

- (id)		  outlineView:(NSOutlineView *)outlineView
    objectValueForTableColumn:(NSTableColumn *)tableColumn
		       byItem:(id)item;


- (void)outlineView:(NSOutlineView *)outlineView
     setObjectValue:(id)object
     forTableColumn:(NSTableColumn *)tableColumn
	     byItem:(id)item;


@end