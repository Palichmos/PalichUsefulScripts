# BOM & Formula Reports
# Target Cost BOM Report, BomQty Cost Report, BomQty Report

@author @kinerix Anna Fadeeva

http://palichmos.ru/

1) Before create functions need to create custom type. Source code of custom type in functions comment:
    1) Create custom type "target_Cost_bom" from comment in function code in file "01_target_cost_bom.sql".
    2) Create custom type "target_Cost_bom_ReverseSum" from comment in function code in file "01_target_cost_bom.sql".
    3) Create function from file "03_target_costprice.sql".
    4) Create function from file "02_target_cost_bom_onelevelline.sql".
    5) Create function from file "01_target_cost_bom.sql"
    6) Create function from file "04_target_cost_bom_subreport.sql'.

2) Add migration scripts from /migration.
3) Run process Role Access Update to view reports in Menu.
4) Run process Add missing translations.
5) Go on Tenant System and attach jrxml/jasper files in reports process from /BomQtyReport, /BomQtyCostReport, /TargetCostBOMReport.
6) If Manufacturing Management is diactivated - you need to activate some menus.

Video presentation: https://youtu.be/Xrda3AEE4Ek

Forum : https://groups.google.com/g/idempiere/c/p9fC5uzvCW8

Wiki: https://wiki.idempiere.org/en/TargetCostBOMReport

![New menu for Reports](https://github.com/Palichmos/PalichUsefulScripts/blob/main/Reports/TargetCostBOMReport/BOMReportsInMenu.png)
