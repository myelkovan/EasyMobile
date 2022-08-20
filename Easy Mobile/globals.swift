//
//  globals.swift
//  Easy Mobile
//
//  Created by Helenex on 31.07.2022.
//

import Foundation




var DbColumns = [column]()
var SqlColumns = [column]()
var gsA_parameters = [String]()
var gsA_where_parameters = [String]()
var gsA_table_names = [String]()
var gs_updatable_table = ""

var gs_pk = ""
var gs_pk_type = ""
var gsA_updatable_columns = [String]()
var gs_appName = ""
var gs_last_appName = ""

var gb_select=false
var gb_delete=false
var gb_insert=false
var gs_select_sql = ""
var gs_insert_sql = ""
var gs_delete_sql = ""
var gs_update_sql = ""

var gs_template_folder = ""
var gs_default_folder = ""


var gi_viewtype = 1
var search_fields :[column] = []
var gs_storyboard_path = ""
var gs_created_storyboard_path = ""
var gs_picture_field = ""
var gb_reset_storyboard = true
var gb_create_view = true


struct column{
    var table_name: String
    var column_name: String?
    var column_type: String?
    var column_default : String?
    var is_null : String?
    var data_type : String?
    var column_lenght : Int?
    var column_precision : Int?
    var key: String?
}



func of_read_file(_ filename: String) ->String{
    var ls_path = gs_template_folder + filename
    
    
    let fileManager: FileManager = .default
        try! fileManager
            .url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
      
    if fileManager.fileExists(atPath: ls_path) == false {
        ls_path = gs_default_folder + filename
    }

    let ls_template = file().of_read( ls_path)
    if ls_template == ""{
        messagebox("Error", ls_path + " could not be read!")
        return ""
    }
   
    return ls_template
}



func of_getSwiftType (_ as_type: String) -> String {
    let ls_type = as_type.of_left("(")!.uppercased()
    
    switch ls_type {
    case "TINYINT", "SMALLINT","MEDIUMINT","INT","BIGINT":
        return "Int"
    case "FLOAT":
        return "Float"
    case "DECIMAL","DOUBLE":
        return "Double"
    default:
        return "String"
    }
}
    

// veritabani tipi string veya dat mi? basina sonuna tirnak lazim mi?
func of_isDBTypeString (_ as_type: String) -> Bool {
    switch as_type.of_left("(")!.lowercased(){
    case "char","varchar","longtext","text","date","datetime","timestamp","time","year","binary","varbinary":
        return true
    default:
        return false
    }
}
