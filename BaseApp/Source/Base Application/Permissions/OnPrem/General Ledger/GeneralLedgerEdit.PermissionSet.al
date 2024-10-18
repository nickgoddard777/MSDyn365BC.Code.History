permissionset 6720 "General Ledger - Edit"
{
    Access = Public;
    Assignable = false;
    Caption = 'G/L periodic activities';

    Permissions = tabledata "Accounting Period" = RIMD,
                  tabledata "Analysis View" = RIMD,
                  tabledata "Analysis View Budget Entry" = RIMD,
                  tabledata "Analysis View Entry" = RIMD,
                  tabledata "Analysis View Filter" = RIMD,
                  tabledata "Applied Payment Entry" = RIMD,
                  tabledata "Bank Acc. Reconciliation" = RIMD,
                  tabledata "Bank Acc. Reconciliation Line" = RIMD,
                  tabledata "Bank Account" = RM,
                  tabledata "Bank Account Ledger Entry" = RM,
                  tabledata "Bank Account Statement" = RI,
                  tabledata "Bank Account Statement Line" = RI,
                  tabledata "Bank Clearing Standard" = RM,
                  tabledata "Bank Export/Import Setup" = R,
                  tabledata "Bank Pmt. Appl. Rule" = RIMD,
                  tabledata "Bank Pmt. Appl. Settings" = RIMD,
                  tabledata "Bank Stmt Multiple Match Line" = RIMD,
                  tabledata "Batch Processing Parameter" = Rimd,
                  tabledata "Batch Processing Session Map" = Rimd,
                  tabledata "Business Unit" = RIMD,
                  tabledata "Business Unit Information" = RIMD,
                  tabledata "Business Unit Setup" = RIMD,
                  tabledata "Check Ledger Entry" = RM,
                  tabledata "Comment Line" = R,
                  tabledata "Consolidation Account" = RIMD,
                  tabledata "Credit Trans Re-export History" = RIMD,
                  tabledata "Credit Transfer Entry" = RIMD,
                  tabledata "Credit Transfer Register" = RIMD,
                  tabledata Currency = RMD,
                  tabledata "Currency Exchange Rate" = R,
                  tabledata "Cust. Ledger Entry" = Rmd,
                  tabledata Customer = R,
                  tabledata "Customer Bank Account" = R,
                  tabledata "Customer Posting Group" = R,
                  tabledata "Data Exch." = Rimd,
                  tabledata "Data Exch. Column Def" = R,
                  tabledata "Data Exch. Def" = R,
                  tabledata "Data Exch. Field" = Rimd,
                  tabledata "Data Exch. Field Mapping" = R,
                  tabledata "Data Exch. Line Def" = R,
                  tabledata "Data Exch. Mapping" = R,
                  tabledata "Data Exch. Field Grouping" = R,
                  tabledata "Data Exch. FlowField Gr. Buff." = R,
                  tabledata "Data Exchange Type" = Rimd,
				  tabledata "Data Exch. Table Filter" = Rimd,
                  tabledata "Date Compr. Register" = RimD,
                  tabledata "Detailed Cust. Ledg. Entry" = Rimd,
                  tabledata "Detailed Vendor Ledg. Entry" = Rimd,
                  tabledata "Employee Ledger Entry" = Rmd,
                  tabledata "Employee Posting Group" = R,
                  tabledata "Exch. Rate Adjmt. Reg." = RimD,
                  tabledata "Exch. Rate Adjmt. Ledg. Entry" = RimD,
                  tabledata "G/L Account" = R,
                  tabledata "G/L Budget Entry" = RIMD,
                  tabledata "G/L Budget Name" = RIMD,
                  tabledata "G/L Entry - VAT Entry Link" = Rimd,
                  tabledata "G/L Entry" = Rimd,
                  tabledata "G/L Register" = Rimd,
                  tabledata "Gen. Business Posting Group" = R,
                  tabledata "Gen. Jnl. Allocation" = RIMD,
                  tabledata "Gen. Journal Batch" = RId,
                  tabledata "Gen. Journal Line" = RIMD,
                  tabledata "Gen. Journal Template" = RI,
                  tabledata "Gen. Product Posting Group" = R,
                  tabledata "General Ledger Setup" = r,
                  tabledata "General Posting Setup" = R,
                  tabledata "Intermediate Data Import" = Rimd,
                  tabledata "Ledger Entry Matching Buffer" = RIMD,
#if not CLEAN20
                  tabledata "Native - Payment" = RIMD,
#endif
                  tabledata "Outstanding Bank Transaction" = RIMD,
                  tabledata "Payment Application Proposal" = RIMD,
                  tabledata "Payment Export Data" = Rimd,
                  tabledata "Payment Jnl. Export Error Text" = RIMD,
                  tabledata "Payment Matching Details" = RIMD,
                  tabledata "Payment Method" = R,
                  tabledata "Posted Payment Recon. Hdr" = RI,
                  tabledata "Posted Payment Recon. Line" = RI,
                  tabledata "Reason Code" = R,
                  tabledata "Referenced XML Schema" = RIMD,
                  tabledata "Source Code Setup" = R,
                  tabledata "Tax Area" = R,
                  tabledata "Tax Area Line" = R,
                  tabledata "Tax Detail" = R,
                  tabledata "Tax Group" = R,
                  tabledata "Tax Jurisdiction" = R,
                  tabledata "User Setup" = r,
                  tabledata "VAT Assisted Setup Bus. Grp." = R,
                  tabledata "VAT Assisted Setup Templates" = R,
                  tabledata "VAT Business Posting Group" = R,
                  tabledata "VAT Entry" = Rimd,
                  tabledata "VAT Posting Setup" = R,
                  tabledata "VAT Product Posting Group" = R,
                  tabledata "VAT Setup" = R,
                  tabledata "VAT Posting Parameters" = R,
                  tabledata "VAT Rate Change Conversion" = R,
                  tabledata "VAT Rate Change Log Entry" = Ri,
                  tabledata "VAT Rate Change Setup" = R,
                  tabledata "VAT Reg. No. Srv Config" = RIMD,
                  tabledata "VAT Reg. No. Srv. Template" = RIMD,
                  tabledata "VAT Registration Log" = RIMD,
                  tabledata "VAT Registration Log Details" = RIMD,
                  tabledata "VAT Setup Posting Groups" = R,
                  tabledata "VAT Statement Line" = RIMD,
                  tabledata "VAT Statement Name" = RIMD,
                  tabledata "VAT Statement Template" = RIMD,
                  tabledata Vendor = R,
                  tabledata "Vendor Bank Account" = R,
                  tabledata "Vendor Ledger Entry" = Rmd,
                  tabledata "Vendor Posting Group" = R,
                  tabledata "XML Buffer" = R,
                  tabledata "XML Schema" = RIMD,
                  tabledata "XML Schema Element" = RIMD,
                  tabledata "XML Schema Restriction" = RIMD;
}
