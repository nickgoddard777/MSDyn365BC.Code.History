﻿permissionset 5289 "D365 ACC. PAYABLE"
{
    Assignable = true;
    Caption = 'Dynamics 365 Accounts payable';

    IncludedPermissionSets = "D365 JOURNALS, POST",
                             "D365 PURCH DOC, POST";

    Permissions = tabledata "Analysis View" = rimd,
                  tabledata "Analysis View Entry" = rim,
                  tabledata "Analysis View Filter" = r,
                  tabledata "Applied Payment Entry" = RIMD,
                  tabledata "Bank Acc. Reconciliation" = RIMD,
                  tabledata "Bank Acc. Rec. Match Buffer" = RIMD,
                  tabledata "Bank Account" = M,
                  tabledata "Bank Account Ledger Entry" = d,
                  tabledata "Bank Account Statement" = RimD,
                  tabledata "Bank Account Statement Line" = Rimd,
                  tabledata "Credit Transfer Entry" = RIMD,
                  tabledata "Credit Transfer Register" = RIMD,
                  tabledata "Currency Exchange Rate" = D,
                  tabledata "Cust. Ledger Entry" = R,
                  tabledata "Date Compr. Register" = Rimd,
                  tabledata "Detailed Cust. Ledg. Entry" = R,
                  tabledata "Exch. Rate Adjmt. Reg." = Rimd,
                  tabledata "Exch. Rate Adjmt. Ledg. Entry" = Rimd,
                  tabledata "General Ledger Setup" = RM,
                  tabledata "G/L Correspondence" = Rimd,
                  tabledata "Item Analysis View" = RM,
                  tabledata "Item Analysis View Entry" = RIM,
                  tabledata "Item Charge Assignment (Purch)" = RIMD,
                  tabledata "Item Charge Assignment (Sales)" = Rm,
                  tabledata "Item Entry Relation" = R,
                  tabledata "Item Journal Line" = RIMD,
                  tabledata "Item Ledger Entry" = Rimd,
                  tabledata "Item Reference" = R,
                  tabledata "Item Register" = Rimd,
                  tabledata "Item Tracing Buffer" = Rimd,
                  tabledata "Item Tracing History Buffer" = Rimd,
                  tabledata "Item Tracking Code" = R,
                  tabledata "Job Ledger Entry" = Rimd,
                  tabledata "Job Queue Category" = RIMD,
                  tabledata "Lot No. Information" = RIMD,
                  tabledata "Notification Entry" = RIMD,
                  tabledata "Order Address" = RIMD,
                  tabledata "Package No. Information" = RIMD,
                  tabledata "Payable Employee Ledger Entry" = RIMD,
                  tabledata "Payable Vendor Ledger Entry" = RIMD,
                  tabledata "Payment Matching Details" = RIMD,
                  tabledata "Payment Rec. Related Entry" = RIMD,
                  tabledata "Pmt. Rec. Applied-to Entry" = RIMD,
                  tabledata "Posted Payment Recon. Hdr" = RIMD,
                  tabledata "Posted Payment Recon. Line" = RIMD,
                  tabledata "Posted Whse. Receipt Header" = R,
                  tabledata "Posted Whse. Receipt Line" = R,
                  tabledata "Price Asset" = RIMD,
                  tabledata "Price Calculation Buffer" = RIMD,
                  tabledata "Price Calculation Setup" = RIMD,
                  tabledata "Price Line Filters" = RIMD,
                  tabledata "Price List Header" = RIMD,
                  tabledata "Price List Line" = RIMD,
                  tabledata "Price Source" = RIMD,
                  tabledata "Price Worksheet Line" = RIMD,
                  tabledata "Purch. Cr. Memo Hdr." = RimD,
                  tabledata "Purch. Cr. Memo Line" = Rimd,
                  tabledata "Purch. Inv. Header" = RimD,
                  tabledata "Purch. Inv. Line" = Rimd,
                  tabledata "Purch. Rcpt. Header" = RimD,
                  tabledata "Purch. Rcpt. Line" = Rimd,
                  tabledata "Purchase Discount Access" = RIMD,
                  tabledata "Purchase Header" = RIMD,
                  tabledata "Purchase Header Archive" = RIMD,
                  tabledata "Purchase Line" = RIMD,
                  tabledata "Purchase Line Archive" = RIMD,
#if not CLEAN21
                  tabledata "Purchase Line Discount" = RIMD,
                  tabledata "Purchase Price" = RIMD,
#endif
                  tabledata "Purchase Price Access" = RIMD,
                  tabledata "Record Buffer" = Rimd,
                  tabledata "Remit Address" = RIMD,
                  tabledata "Requisition Line" = RIMD,
#if not CLEAN21
                  tabledata "Resource Cost" = R,
                  tabledata "Resource Price" = R,
#endif
                  tabledata "Resource Unit of Measure" = R,
                  tabledata "Sales Header" = RmD,
                  tabledata "Sales Invoice Line" = Rimd,
                  tabledata "Sales Line" = RIMD,
                  tabledata "VAT Registration No. Format" = IMD,
                  tabledata Vendor = D,
                  tabledata "Vendor Invoice Disc." = IMD,
                  tabledata "Work Type" = R;
}
