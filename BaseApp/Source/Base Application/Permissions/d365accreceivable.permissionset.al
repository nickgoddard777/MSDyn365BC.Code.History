permissionset 7862 "D365 ACC. RECEIVABLE"
{
    Access = Public;
    Assignable = true;
    Caption = 'Dyn. 365 Accounts receivable';

    IncludedPermissionSets = "Webhook - Edit";

    Permissions = tabledata "Analysis View" = rimd,
                  tabledata "Analysis View Entry" = rim,
                  tabledata "Analysis View Filter" = r,
                  tabledata "Applied Payment Entry" = RIMD,
                  tabledata "Approval Workflow Wizard" = RIMD,
                  tabledata "Avg. Cost Adjmt. Entry Point" = RIM,
                  tabledata "Bank Acc. Reconciliation" = RIMD,
                  tabledata "Bank Acc. Reconciliation Line" = RIMD,
                  tabledata "Bank Account" = RM,
                  tabledata "Bank Account Ledger Entry" = Rim,
                  tabledata "Bank Account Posting Group" = R,
                  tabledata "Bank Account Statement" = RimD,
                  tabledata "Bank Account Statement Line" = Rimd,
                  tabledata "Bank Pmt. Appl. Rule" = RIMD,
                  tabledata "Bank Pmt. Appl. Settings" = RIMD,
                  tabledata "Batch Processing Parameter" = Rimd,
                  tabledata "Batch Processing Session Map" = Rimd,
                  tabledata Bin = R,
                  tabledata "Cancelled Document" = Rimd,
                  tabledata "Check Ledger Entry" = Rimd,
                  tabledata "Close Opportunity Code" = R,
                  tabledata "Contact Business Relation" = R,
                  tabledata "Credit Transfer Entry" = Rimd,
                  tabledata "CRM Post Buffer" = RIM,
                  tabledata Currency = RM,
                  tabledata "Currency Exchange Rate" = RIMD,
                  tabledata "Currency for Fin. Charge Terms" = R,
                  tabledata "Currency for Reminder Level" = R,
                  tabledata "Cust. Invoice Disc." = RIMD,
                  tabledata "Cust. Ledger Entry" = RiMd,
                  tabledata Customer = RIMD,
                  tabledata "Customer Bank Account" = RM,
                  tabledata "Date Compr. Register" = Rimd,
                  tabledata "Detailed Cust. Ledg. Entry" = Rimd,
                  tabledata "Detailed Employee Ledger Entry" = Rimd,
                  tabledata "Detailed Vendor Ledg. Entry" = Rimd,
                  tabledata "Dtld. Price Calculation Setup" = RIMD,
                  tabledata "Duplicate Price Line" = RIMD,
                  tabledata "Employee Ledger Entry" = Rimd,
                  tabledata "Exch. Rate Adjmt. Reg." = Rimd,
                  tabledata "Fin. Charge Comment Line" = RIMD,
                  tabledata "Finance Charge Interest Rate" = RIMD,
                  tabledata "Finance Charge Memo Header" = RIMD,
                  tabledata "Finance Charge Memo Line" = RIMD,
                  tabledata "Finance Charge Text" = RIMD,
                  tabledata "G/L - Item Ledger Relation" = RIMD,
                  tabledata "G/L Entry - VAT Entry Link" = Ri,
                  tabledata "G/L Entry" = Rimd,
                  tabledata "G/L Register" = Rimd,
                  tabledata "Gen. Journal Line" = RIMD,
                  tabledata "General Ledger Setup" = RIM,
                  tabledata "Incoming Document" = Rimd,
                  tabledata "Interaction Log Entry" = Rimd,
                  tabledata "Interaction Template" = R,
                  tabledata "Interaction Tmpl. Language" = R,
                  tabledata "Intrastat Jnl. Line" = RIMD,
                  tabledata "Issued Fin. Charge Memo Header" = Rimd,
                  tabledata "Issued Fin. Charge Memo Line" = Rimd,
                  tabledata "Issued Reminder Header" = Rimd,
                  tabledata "Issued Reminder Line" = Rimd,
                  tabledata "Item Charge" = R,
                  tabledata "Item Charge Assignment (Purch)" = RIMD,
                  tabledata "Item Charge Assignment (Sales)" = RIMD,
                  tabledata "Item Cross Reference" = RIMD,
                  tabledata "Item Entry Relation" = R,
                  tabledata "Item Journal Line" = RIMD,
                  tabledata "Item Ledger Entry" = Rimd,
                  tabledata "Item Reference" = RIMD,
                  tabledata "Item Register" = Rimd,
                  tabledata "Item Tracing Buffer" = Rimd,
                  tabledata "Item Tracing History Buffer" = Rimd,
                  tabledata "Item Tracking Code" = R,
                  tabledata "Job Ledger Entry" = Rimd,
                  tabledata "Job Queue Category" = RIMD,
                  tabledata "Line Fee Note on Report Hist." = Rim,
                  tabledata "Lot No. Information" = RIMD,
                  tabledata "Notification Entry" = RIMD,
                  tabledata "O365 Document Sent History" = RimD,
                  tabledata Opportunity = R,
                  tabledata "Opportunity Entry" = RIM,
                  tabledata "Order Address" = RIMD,
                  tabledata "Order Promising Line" = RiMD,
                  tabledata "Package No. Information" = RIMD,
                  tabledata "Payment Matching Details" = RIMD,
                  tabledata "Payment Method" = RIMD,
                  tabledata "Payment Terms" = RMD,
                  tabledata "Phys. Invt. Counting Period" = RIMD,
                  tabledata "Phys. Invt. Item Selection" = RIMD,
                  tabledata "Planning Assignment" = Ri,
                  tabledata "Planning Component" = Rm,
                  tabledata "Post Value Entry to G/L" = i,
                  tabledata "Posted Payment Recon. Hdr" = RIMD,
                  tabledata "Posted Payment Recon. Line" = RIMD,
                  tabledata "Posted Whse. Shipment Header" = R,
                  tabledata "Posted Whse. Shipment Line" = R,
                  tabledata "Price Asset" = RIMD,
                  tabledata "Price Calculation Buffer" = RIMD,
                  tabledata "Price Calculation Setup" = RIMD,
                  tabledata "Price Line Filters" = RIMD,
                  tabledata "Price List Header" = RIMD,
                  tabledata "Price List Line" = RIMD,
                  tabledata "Price Source" = RIMD,
                  tabledata "Purch. Rcpt. Header" = i,
                  tabledata "Purch. Rcpt. Line" = Ri,
                  tabledata "Purchase Header" = Rimd,
                  tabledata "Purchase Line" = RIMD,
                  tabledata "Record Buffer" = Rimd,
                  tabledata "Reminder Comment Line" = RIMD,
                  tabledata "Reminder Header" = RIMD,
                  tabledata "Reminder Level" = R,
                  tabledata "Reminder Line" = RIMD,
                  tabledata "Reminder Text" = R,
                  tabledata "Reminder/Fin. Charge Entry" = Rimd,
                  tabledata "Resource Cost" = R,
                  tabledata "Resource Price" = R,
                  tabledata "Resource Unit of Measure" = R,
                  tabledata "Restricted Record" = RIMD,
                  tabledata "Return Reason" = R,
                  tabledata "Return Receipt Header" = Rim,
                  tabledata "Return Receipt Line" = Rim,
                  tabledata "Sales Cr.Memo Header" = RimD,
                  tabledata "Sales Cr.Memo Line" = Rimd,
                  tabledata "Sales Discount Access" = RIMD,
                  tabledata "Sales Header" = RIMD,
                  tabledata "Sales Header Archive" = RIMD,
                  tabledata "Sales Invoice Header" = RimD,
                  tabledata "Sales Invoice Line" = Rimd,
                  tabledata "Sales Line" = RIMD,
                  tabledata "Sales Line Archive" = RIMD,
                  tabledata "Sales Line Discount" = RIMD,
                  tabledata "Sales Planning Line" = Rimd,
                  tabledata "Sales Price" = RIMD,
                  tabledata "Sales Price Access" = RIMD,
                  tabledata "Sales Price Worksheet" = RIMD,
                  tabledata "Sales Shipment Header" = RimD,
                  tabledata "Sales Shipment Line" = Rimd,
                  tabledata "Serial No. Information" = RIMD,
                  tabledata "Ship-to Address" = RIMD,
                  tabledata "Shipping Agent Services" = R,
                  tabledata "Standard Customer Sales Code" = RIMD,
                  tabledata "Standard General Journal Line" = RIMD,
                  tabledata "Standard Item Journal" = RIMD,
                  tabledata "Standard Item Journal Line" = RIMD,
                  tabledata "Standard Sales Code" = RIMD,
                  tabledata "Standard Sales Line" = RIMD,
                  tabledata "Stockkeeping Unit" = R,
                  tabledata "Substitution Condition" = R,
                  tabledata "Tax Detail" = RIMD,
                  tabledata "Time Sheet Chart Setup" = RIMD,
                  tabledata "Time Sheet Comment Line" = RIMD,
                  tabledata "Time Sheet Detail" = RIMD,
                  tabledata "Time Sheet Header" = RIMD,
                  tabledata "Time Sheet Line" = RIMD,
                  tabledata "Time Sheet Posting Entry" = RIMD,
                  tabledata "To-do" = RM,
                  tabledata "Tracking Specification" = Rimd,
                  tabledata "Transaction Type" = R,
                  tabledata "Transport Method" = R,
                  tabledata "User Task Group" = RIMD,
                  tabledata "User Task Group Member" = RIMD,
                  tabledata "Value Entry Relation" = R,
                  tabledata "VAT Amount Line" = RIMD,
                  tabledata "VAT Entry" = Rimd,
                  tabledata "VAT Rate Change Conversion" = R,
                  tabledata "VAT Rate Change Log Entry" = Ri,
                  tabledata "VAT Rate Change Setup" = R,
                  tabledata "VAT Registration No. Format" = RIMD,
                  tabledata "Vendor Invoice Disc." = R,
                  tabledata "Vendor Ledger Entry" = Rimd,
                  tabledata "Warehouse Register" = r,
                  tabledata "Warehouse Request" = RIMD,
                  tabledata "Whse. Item Entry Relation" = R,
                  tabledata "Whse. Pick Request" = RIMD,
                  tabledata "Work Type" = R,
                  tabledata "Workflow - Table Relation" = RIMD,
                  tabledata Workflow = RIMD,
                  tabledata "Workflow Event" = RIMD,
                  tabledata "Workflow Event Queue" = RIMD,
                  tabledata "Workflow Response" = RIMD,
                  tabledata "Workflow Rule" = RIMD,
                  tabledata "Workflow Step" = RIMD,
                  tabledata "Workflow Step Argument" = RIMD,
                  tabledata "Workflow Step Instance" = RIMD,
                  tabledata "Workflow Table Relation Value" = RIMD,
                  tabledata "Workflow User Group" = RIMD,
                  tabledata "Workflow User Group Member" = RIMD;
}
