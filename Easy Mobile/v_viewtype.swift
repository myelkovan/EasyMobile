import Foundation
import SwiftUI




class v_viewtype: ViewController{
    
    

    @IBOutlet weak var cb_tableview: NSButton!
    @IBOutlet weak var cb_collectionview: NSButton!
    @IBOutlet weak var cb_singleview: NSButton!
    @IBOutlet weak var cbx_search: NSButton!
    @IBOutlet weak var cb_search_field: NSButton!
    @IBOutlet weak var cb_picture: NSButton!
    @IBOutlet weak var cb_picture_field: NSButton!
    
    
    override func viewWillAppear() {
        if gs_search_field.count > 0{
            cb_search_field.title = gs_search_field
        }
    }
    
    @IBAction func cb_tableview_clicked(_ sender: Any) {
        of_select_tableview()
   }
 
    @IBAction func cb_collectionview_clicked(_ sender: Any) {
        of_select_collectionview()
    }
    
    @IBAction func cb_singleview_clicked(_ sender: Any) {
        of_select_singleview()
    }
    
    
    func of_select_tableview(){
        cb_tableview.alphaValue = 1
        cb_collectionview.alphaValue = 0.2
        cb_singleview.alphaValue = 0.2
        cbx_search.isEnabled = true
        cb_search_field.isEnabled = true
        gi_viewtype = 1
    }

    func of_select_collectionview(){
        cb_tableview.alphaValue = 0.2
        cb_collectionview.alphaValue = 1
        cb_singleview.alphaValue = 0.2
        cbx_search.isEnabled = true
        cb_search_field.isEnabled = true
        gi_viewtype = 2
    }
    
    
    func of_select_singleview(){
        cb_tableview.alphaValue = 0.2
        cb_collectionview.alphaValue = 0.2
        cb_singleview.alphaValue = 1
        cbx_search.isEnabled = false
        cb_search_field.isEnabled = false
        gi_viewtype = 3
    }
    
  
   
    override func prepare(for segue: NSStoryboardSegue, sender: Any? ) {
        let target = segue.destinationController as! v_columns
        target.ii_search_picture = sender as! Int
    }
    
    @IBAction func cb_noview_clicked(_ sender : NSButton) {
        if sender.state == NSButton.StateValue.on{
            cb_tableview.alphaValue = 0.2
            cb_collectionview.alphaValue = 0.2
            cb_singleview.alphaValue = 0.2
            cbx_search.isEnabled = false
            cb_search_field.isEnabled = false
            cb_picture.isEnabled = false
            cb_picture_field.isEnabled = false
            gb_create_view = false
            
        }else{
            gb_create_view = true
            cb_picture_field.isEnabled = true
            gb_create_view = true

            switch gi_viewtype{
            case 1:
                of_select_tableview()
            case 2:
                of_select_collectionview()
            default:
                of_select_singleview()
            }

        }
    }
    
    
    @IBAction func cbx_search_clicked(_ sender: NSButton) {
        if sender.state == NSButton.StateValue.on{
            cb_search_field.isEnabled = true
        }else{
            cb_search_field.isEnabled = false
            gs_search_field = ""
        }
     }

    
    @IBAction func cb_picture_clicked(_ sender: NSButton) {
        if sender.state == NSButton.StateValue.on{
            cb_picture_field.isEnabled = true
        }else{
            cb_picture_field.isEnabled = false
            gs_picture_field = ""
        }

    }
    
    @IBAction func cb_search_field_clicked(_ sender: NSButton) {
        performSegue(withIdentifier: "toColumn", sender: 1)
    }
    
    
    @IBAction func cb_picture_field_clicked(_ sender: NSButton) {
        performSegue(withIdentifier: "toColumn", sender: 2)
    }
 

    
}
