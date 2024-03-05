workspace {

    model {
        
        p_OperationalWorker = person "Operational Worker"
        p_DataAnalyst = person "Data Analyst"
        p_DataModeler = person "Data Modeler"
        p_DatabaseAdmin = person "Database Admin"

        
        ss_app = softwareSystem "App"{
        }
        
        ss_app_sql = softwareSystem "App SQL DB"{
        }
        ss_app -> ss_app_sql "Writes Into"
        ss_app_sql -> ss_app "Reads From"

        ss_dba_sql = softwareSystem "administrators SQL DB"{
        }

        ss_datajobs = softwareSystem "Data Jobs"{
            dj_persistblitz = container "Persist Blitz SQL metrics"{
                persistblitz_auth = component "Get SQL credentials from ENV variable MSSQL_SA_PASSWORD"
                persistblitz_sqlconnect = component "Connect to 'dba' database"
                persistblitz_auth -> persistblitz_sqlconnect "next"
                persistblitz_sqlexec = component "Execute stored procedure sp_BlitzFirst"
                persistblitz_sqlconnect -> persistblitz_sqlexec "next"
                persistblitz_promlogger = component "Write Prometheus metrics to textfile"
                persistblitz_sqlexec -> persistblitz_promlogger "next"
            }
        }
        dj_persistblitz -> ss_dba_sql "Executes stored proc on every 5 minutes"
        p_DatabaseAdmin -> dj_persistblitz "Supports"
        p_DatabaseAdmin -> ss_app_sql "Supports"
        p_DatabaseAdmin -> ss_dba_sql "Supports"

        ss_data_warehouse = softwareSystem "Data Warehouse"{
            dw_vehicle_fact = container "vehicle_fact"
            dw_vehicle_dim = container "vehicle_dim"
        }
        ss_app_sql -> ss_data_warehouse  "Loads into"

        ss_ssas = softwareSystem "SSAS Tabular Model"{
        }
        ss_report = softwareSystem "reporting"{
            ss_report_powerbi = container "PowerBI"
            ss_report_tableau = container "Tableau"
            ss_report_crystal = container "Crystal Reports"
            ss_report_excel = container "Excel"
            ss_report_export = container "csv,tsv or some other plain export"
        }
        ss_data_warehouse -> ss_ssas  "Reads from into"
        p_OperationalWorker -> ss_app "Uses"
        p_DataModeler -> ss_ssas "Builds Models"
        p_DataModeler -> ss_report "Connects SSAS Models"

        p_DataAnalyst -> ss_report "Creates Reports"
        p_OperationalWorker -> ss_report "Consumes Reports"
        
    }

    views {
        styles {
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
        }
        systemLandscape "_system"{
            include *
            #autolayout
        }
        systemContext ss_app "app"{
            include *
            #autolayout
        }
        container ss_app "app_container"{
            include *
            #autolayout
        }   
        systemContext ss_data_warehouse "datawarehouse" {
            include *
            #autolayout
        }
        container ss_data_warehouse "datawarehouse_container" {
            include *
            #autolayout
        }
        systemContext ss_datajobs "datajob" {
            include *
            #autolayout
        }
        container ss_datajobs "datajob_container" {
            include *
            #autolayout
        }
        component dj_persistblitz "datajob_persistblitz" {
            include *
            #autolayout
        }
              
        
    }
    
}