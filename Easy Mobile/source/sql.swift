//
//  sqlparse.swift
//  MY Code Generator
//
//  Created by Murat Yelkovan on 18.06.2022.
//

import Foundation





func of_parseSql(_ as_sql: String){
    var li_pos = 0
    var li_fromPos = 0
    var ls_from = ""
    var li_selectCount = 1
    var li_fromCount = 0
    var li_prevFromPos = 0
    var tables = [String:String]()
    var ls_fromArray:[String]!
    var ls_col="", ls_table="", ls_col_in_db = ""
    var ls_sub_colname = ""
    var ls_sub_table = ""
    var ls_param:String?

    struct col{
        var colname:String
        var tablename:String
        var real_colname:String? //subquery de as den sonraki değil sql içindeki alan
    }
    var cols=[col]()


    
    
    //select m.a,user.b, (select c from x where a=1) as c,
    //(select c from x where a=1) as d
    //from x where z=(select a from
    //b where a=1) union select * from b
    gs_select_sql = as_sql
    var ls_sql = as_sql.lowercased().of_trim()!.of_removeNewLines()
    //select a,b, (select c from x where a=1) as a, (select c from x where a=1) as a from x where z=(select a from b where a=1)

    ls_sql = ls_sql.of_left(" union ")!
    ls_sql = ls_sql.of_left(" group by ")!
    ls_sql = ls_sql.of_left(" order by ")!
    //select a,b, (select c from x where a=1) as a, (select c from x where a=1) as a
    //from x where z=(select a from b where a=1)

    
    
    //*****************************************************************************************
    //select ile from arasında yine select varsa doğru fromu bulmamışızdır bulana kadar tekrar edeceğiz
    //ilk selectten sonrasını alıyoruz
    ls_sql = ls_sql.of_right("select ")!
    //a,b, (select c from x where a=1) as a, (select c from x where a=1) as a
    //from x where z=(select a from b where a=1)
   repeat{
        //a,b, (select c from   --> 14
        //a,b, (select c from x where a=1) as a, (select c from

        //ilk fromu bul
        li_prevFromPos = li_fromPos
        li_fromPos = ls_sql.of_pos(" from ", starting:li_fromPos)
        if (li_fromPos > 0){
            li_fromCount += 1
            
            //ilk bulduğumuz froma kadar olan kısmı al
            ls_from = ls_sql.of_left(li_fromPos)!
            
            //içinde select varsa
            li_pos = ls_from.of_pos("select ",starting: li_prevFromPos)
            if (li_pos > 0){
                li_selectCount += 1
  
                //select ve from sayısı eşitlendi ise doğru froma geldik demektir
                if (li_selectCount == li_fromCount){
                    break
                }else{
                     li_fromPos = li_fromPos + 6
                }
                
            }else{
                break
            }
        }else{
            break
        }
    } while true
    
   
    // Gerçek Fromu alınıyor
    ls_from = ls_sql.of_right(starting: li_fromPos + 5)!
    if let ls_from1 = ls_from.of_left(" where "){
        ls_from = ls_from1
    }else if let ls_from1 = ls_from.of_left(" group by "){
        ls_from = ls_from1
    }else if let ls_from1 = ls_from.of_left(" order by "){
        ls_from = ls_from1
    }
        
    
    //*****************************************************************************************
    //From'u parçalauyıp tablo adlarını bulacağız join veya = olabilir
    //table1 join table2 using() left join deneme
    if (ls_from.contains(" join ")){
        ls_fromArray = ls_from.components(separatedBy: " join ")
    }else{
        //table1 m, user, table2 m2
        ls_fromArray = ls_from.components(separatedBy: ",")
    }

    gsA_table_names = [String]()
    for var tableName in ls_fromArray
    {
        // table1 m LEFT/RIGHT/INNER/FULL/SELF OUTER JOIN Customers ON
        tableName = tableName.of_trim()!
        if tableName.contains(" left "){
            tableName = tableName.of_left(" left ")!
        }else if tableName.contains(" right "){
            tableName = tableName.of_left(" right ")!
        }else if tableName.contains(" inner "){
            tableName = tableName.of_left(" inner ")!
        }else if tableName.contains(" full "){
            tableName = tableName.of_left(" full ")!
        }else if tableName.contains(" self "){
            tableName = tableName.of_left(" self ")!
        }

        if (tableName.contains(" ")){
            // talo adı message m on(id) veya message m using(id) geldi
            let ls_table = tableName.of_left(" ")!
            var ls_alias = tableName.of_right(" ")!
            if (ls_alias.contains(" ")){
                ls_alias = ls_alias.of_left(" ")!
            }
            
            tables[ls_alias] = ls_table
            gsA_table_names.append(ls_table)
        }else{
            tables[tableName] = tableName
            gsA_table_names.append(tableName)
        }
    }
   
    
    //*****************************************************************************************
    //Select ile from arasındaki alanlar alınacak
    let ls_columns = ls_sql.of_left(li_fromPos)
    let ls_columnsArray = ls_columns!.components(separatedBy: ",")
 
    for var columnName in ls_columnsArray
    {
        columnName = columnName.of_trim()!
        //(select x from x) as isim veya "murat" as isim
        if (columnName.contains(" as ")){
            ls_col = columnName.of_right(" as ")!
            ls_table = ls_sub_table
            ls_col_in_db = ls_sub_colname
            ls_sub_table = ""
            ls_sub_colname = ""
        }
        //virgül varsa virgüle kadar olan kısmı alır ISNULL(1, 2) as isim   -->ISNULL(1,
        else if (columnName.contains("(") || columnName.contains(")")){
            if columnName.contains("select"){
                let ls_sub_select = columnName.of_right("select")!
                ls_sub_colname = ls_sub_select.of_left("from")!.of_trim()!
                let ls_sub_from = columnName.of_right("from")!
                ls_sub_table = ls_sub_from.of_left("where")!.of_trim()!
                continue
            }else{ //IFNULL(a,b)
                let ls_sub_select = columnName.of_right("(")!
                ls_sub_colname = ls_sub_select.of_left(",")!.of_trim()!
                ls_sub_colname = ls_sub_select.of_left(")")!.of_trim()!
                (ls_sub_table, ls_sub_colname) = of_parse_colname(ls_sub_colname)
            }
            continue
        //message.isim
        }else if (columnName.contains(".")){
            (ls_table, ls_col) = of_parse_colname(columnName)
            ls_sub_table = ""
            ls_sub_colname = ""
        }else{
            ls_col = columnName
            ls_table = gsA_table_names[0]  // tablo adı girilmemiş demekki tek tablo var, inşallah
            ls_sub_table = ""
            ls_sub_colname = ""
        }

        // tablo ve alan başında distinct olabilir distinct name bu yüzden boluktan sonrasını al
        if (ls_col.contains(" ")){
            ls_col = ls_col.of_right(" ")!
        }
 
        if (ls_table.contains(" ")){
            ls_table = ls_table.of_right(" ")!
        }
        
            
        //tablo adı m gibi alias olabilir gerçek tablo adını al
        if (ls_table != ""){
            ls_table = tables[ls_table] ?? ls_table
        }
        cols.append(col(colname: ls_col, tablename: ls_table, real_colname: ls_col_in_db))
    }
    
    
    func of_parse_colname(_ columnName: String) -> (tablename:String, colname:String){
        if columnName.contains(".") {
            let ls_colname = columnName.of_right(".")!
            let ls_table = columnName.of_left(".")!
            return (tablename: ls_table, colname:ls_colname)
        }
        return (tablename: "", colname:columnName)
    }
    
        
    //*****************************************************************************************
    //sqldeki column adlarını veritabanından okunan structurda bulup yeni bir structa kopyala
    SqlColumns = [column]()
    for col in cols
    {
        if let row = DbColumns.first(where: {$0.table_name.lowercased() == col.tablename && $0.column_name?.lowercased() == col.colname}) {
            SqlColumns.append(row)
        }else if  let row = DbColumns.first(where: {$0.table_name.lowercased() == col.tablename && $0.column_name?.lowercased() == col.real_colname}) {
                SqlColumns.append(row)
        }else{
            //FIXME: compute alanların tipini bulmak lazım
            SqlColumns.append(column(table_name: "",
                column_name: col.colname,
                column_type: "",
                column_default : "",
                is_null : "NO",
                data_type : "String",
                column_lenght : 10,
                column_precision : 0,
                key: "NO"))
        }
    }


    
   //*****************************************************************************************
   //Sql içinde geçen $id gibi parametreleri bulunup arraya yükleyeceğiz
    li_fromPos = 0
    repeat{
 
        li_fromPos = ls_sql.of_pos("$", starting:li_fromPos)
        if (li_fromPos > 0 ){
            li_pos = ls_sql.of_pos(" ", starting:li_fromPos)
            if (li_pos == 0){
                li_pos = ls_sql.count + 1
            }
                
            ls_param = ls_sql.of_mid(location: li_fromPos, length: li_pos - li_fromPos)?.of_trim()
            // Select'te (select x from x where id=$id) as a varsa parantezi uçur
            ls_param = ls_param?.of_left(")")!
            
            if gsA_parameters.contains(ls_param!) == false{
                gsA_parameters.append(ls_param!)
            }
            li_fromPos = li_pos
        }
        
    }while li_fromPos > 0 && li_fromPos < ls_sql.count

   

}
