permissionset 5729 "D365 CUSTOMER, EDIT"
{
    Assignable = true;

    Caption = 'Dynamics 365 Create customers';
    Permissions = tabledata "Bank Account Ledger Entry" = rm,
                  tabledata Bin = R,
                  tabledata "Check Ledger Entry" = r,
                  tabledata "Cont. Duplicate Search String" = RIMD,
                  tabledata Contact = RIMD,
                  tabledata "Contact Business Relation" = RImD,
                  tabledata "Contact Duplicate" = R,
                  tabledata "Contact Industry Group" = Rd,
                  tabledata "Contact Job Responsibility" = Rd,
                  tabledata "Contact Mailing Group" = Rd,
                  tabledata "Contact Profile Answer" = Rd,
                  tabledata "Contact Web Source" = Rd,
                  tabledata "Contract Gain/Loss Entry" = rm,
                  tabledata Currency = RM,
                  tabledata "Cust. Invoice Disc." = RIMD,
                  tabledata "Cust. Ledger Entry" = RM,
                  tabledata Customer = RIMD,
                  tabledata "Customer Bank Account" = RIMD,
                  tabledata "Customer Discount Group" = RIMD,
                  tabledata "Customer Template" = r,
                  tabledata "Detailed Cust. Ledg. Entry" = Rimd,
                  tabledata "Dtld. Price Calculation Setup" = Rid,
                  tabledata "Duplicate Price Line" = Rid,
                  tabledata "Duplicate Search String Setup" = R,
                  tabledata "Employee Ledger Entry" = rm,
                  tabledata "Filed Contract Line" = rm,
                  tabledata "Finance Charge Text" = R,
                  tabledata "G/L Entry - VAT Entry Link" = rm,
                  tabledata "G/L Entry" = rm,
                  tabledata "Interaction Log Entry" = Rm,
                  tabledata "Item Analysis View Budg. Entry" = r,
                  tabledata "Item Analysis View Entry" = rid,
                  tabledata "Item Budget Entry" = r,
                  tabledata "Item Cross Reference" = RIMD,
                  tabledata "Item Reference" = RIMD,
                  tabledata "Line Fee Note on Report Hist." = R,
                  tabledata Opportunity = Rm,
                  tabledata "Opportunity Entry" = Rm,
                  tabledata "Price Asset" = Rid,
                  tabledata "Price Calculation Buffer" = Rid,
                  tabledata "Price Calculation Setup" = Rid,
                  tabledata "Price Line Filters" = Rid,
                  tabledata "Price List Header" = Rid,
                  tabledata "Price List Line" = Rid,
                  tabledata "Price Source" = Rid,
                  tabledata "Profile Questionnaire Line" = R,
                  tabledata "Purch. Cr. Memo Hdr." = rm,
                  tabledata "Purch. Cr. Memo Line" = rm,
                  tabledata "Purch. Inv. Header" = rm,
                  tabledata "Purch. Rcpt. Header" = rm,
                  tabledata "Purchase Header Archive" = r,
                  tabledata "Registered Whse. Activity Line" = rm,
                  tabledata "Reminder Level" = R,
                  tabledata "Reminder Text" = R,
                  tabledata "Reminder/Fin. Charge Entry" = R,
                  tabledata "Res. Journal Line" = r,
                  tabledata "Return Receipt Header" = rm,
                  tabledata "Return Receipt Line" = rm,
                  tabledata "Return Shipment Header" = rm,
                  tabledata "Return Shipment Line" = rm,
                  tabledata "Rlshp. Mgt. Comment Line" = rD,
                  tabledata "Sales Cr.Memo Header" = rm,
                  tabledata "Sales Cr.Memo Line" = rm,
                  tabledata "Sales Discount Access" = Rd,
                  tabledata "Sales Header Archive" = rm,
                  tabledata "Sales Invoice Line" = rm,
                  tabledata "Sales Line Discount" = Rd,
                  tabledata "Sales Price" = Rid,
                  tabledata "Sales Price Access" = Rid,
                  tabledata "Sales Shipment Header" = rm,
                  tabledata "Sales Shipment Line" = Rm,
                  tabledata "Service Contract Header" = Rm,
                  tabledata "Service Contract Line" = Rm,
                  tabledata "Service Header" = Rm,
                  tabledata "Service Invoice Line" = Rm,
                  tabledata "Service Item" = Rm,
                  tabledata "Service Item Line" = Rm,
                  tabledata "Service Ledger Entry" = rm,
                  tabledata "Service Line" = r,
                  tabledata "Service Zone" = R,
                  tabledata "Ship-to Address" = RIMD,
                  tabledata "Shipping Agent Services" = R,
                  tabledata "Social Listening Search Topic" = RIMD,
                  tabledata "Standard Customer Sales Code" = RIMD,
                  tabledata "Standard Sales Code" = RIMD,
                  tabledata "Standard Sales Line" = RIMD,
                  tabledata "To-do" = Rm,
                  tabledata "VAT Entry" = Rm,
                  tabledata "VAT Reg. No. Srv Config" = RIMD,
                  tabledata "VAT Reg. No. Srv. Template" = RIMD,
                  tabledata "VAT Registration Log Details" = RIMD,
                  tabledata "VAT Registration No. Format" = RIMD,
                  tabledata "Vendor Ledger Entry" = rm,
                  tabledata "Warehouse Activity Header" = rm,
                  tabledata "Warehouse Activity Line" = rm,
                  tabledata "Warehouse Request" = rm,
                  tabledata "Warehouse Shipment Line" = rm,
                  tabledata "Warranty Ledger Entry" = rm,
                  tabledata "Whse. Worksheet Line" = r;
}
