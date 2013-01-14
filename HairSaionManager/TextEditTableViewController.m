//
//  TextEditTableViewController.m
//  HairSaionManager
//
//  Created by chen loman on 12-12-11.
//  Copyright (c) 2012年 chen loman. All rights reserved.
//

#import "TextEditTableViewController.h"
#import "TextEditTableCell.h"
#import "TextViewTableCell.h"
#import "ProductShowingDetail.h"

@interface TextEditTableViewController ()
@property (nonatomic, strong)NSString* oriStr;
@end

@implementation TextEditTableViewController
@synthesize oriStr;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"inputTextCell";
    TextEditTableCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell.textField setPlaceholder:self.item.name];
    cell.textField.delegate = self;
    //self.identifier = cell.reuseIdentifier;
    self.oriStr = [self getTextByIdentifier:self.identifier];
   // cell sete = UITableViewCellEditingStyleDelete;
    
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self setTextByIdentifier:self.identifier andValue:textField.text];
    [textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self setTextByIdentifier:self.identifier andValue:newString];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setTextByIdentifier:self.identifier andValue:textField.text];
}


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self setTextByIdentifier:self.identifier andValue:self.oriStr];
}


- (NSString*)getTextByIdentifier:(NSString*)identifier
{
    if ([identifier isEqualToString:@"nameTextCell"])
    {
        return self.item.name;
    }
    else if ([identifier isEqualToString:@"priceTextCell"])
    {
        return [NSString stringWithFormat:@"%@", ((ProductShowingDetail*)self.item).price];
    }
    
    return @"";

}


- (void)setTextByIdentifier:(NSString*)identifier andValue:(NSString*)text
{
    if ([identifier isEqualToString:@"nameTextCell"])
    {
        self.item.name = text;
    }
    else if ([identifier isEqualToString:@"priceTextCell"])
    {
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc]init];
        [formatter setFormatterBehavior:NSNumberFormatterDecimalStyle];
        ((ProductShowingDetail*)self.item).price = [formatter numberFromString:text];
    }
}


@end
