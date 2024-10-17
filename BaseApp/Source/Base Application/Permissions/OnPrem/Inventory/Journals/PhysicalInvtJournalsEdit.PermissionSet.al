permissionset 4736 "Physical Invt Journals - Edit"
{
    Access = Public;
    Assignable = false;
    Caption = 'Taking a physical inventory';

    Permissions = tabledata "Accounting Period" = R,
                  tabledata Bin = R,
                  tabledata "Comment Line" = R,
                  tabledata "Country/Region" = R,
                  tabledata "Default Dimension" = R,
                  tabledata "Default Dimension Priority" = R,
                  tabledata "Exp. Phys. Invt. Tracking" = RIMD,
                  tabledata "Gen. Business Posting Group" = R,
                  tabledata "Gen. Product Posting Group" = R,
                  tabledata "General Ledger Setup" = R,
                  tabledata "General Posting Setup" = R,
                  tabledata "Inventory Posting Group" = R,
                  tabledata "Inventory Posting Setup" = R,
                  tabledata Item = Rm,
                  tabledata "Item Application Entry" = Ri,
                  tabledata "Item Journal Batch" = RI,
                  tabledata "Item Journal Line" = RIM,
                  tabledata "Item Journal Template" = RI,
                  tabledata "Item Ledger Entry" = Rim,
                  tabledata "Item Register" = Rim,
                  tabledata "Item Variant" = R,
                  tabledata Location = R,
                  tabledata "Phys. Inventory Ledger Entry" = im,
                  tabledata "Phys. Invt. Comment Line" = RIMD,
                  tabledata "Phys. Invt. Count Buffer" = RIMD,
                  tabledata "Phys. Invt. Order Header" = RIMD,
                  tabledata "Phys. Invt. Order Line" = RIMD,
                  tabledata "Phys. Invt. Record Header" = RIMD,
                  tabledata "Phys. Invt. Record Line" = RIMD,
                  tabledata "Phys. Invt. Tracking" = RIMD,
                  tabledata "Pstd. Exp. Phys. Invt. Track" = RIMD,
                  tabledata "Pstd. Phys. Invt. Order Hdr" = RIMD,
                  tabledata "Pstd. Phys. Invt. Order Line" = RIMD,
                  tabledata "Pstd. Phys. Invt. Record Hdr" = RIMD,
                  tabledata "Pstd. Phys. Invt. Record Line" = RIMD,
                  tabledata "Pstd. Phys. Invt. Tracking" = RIMD,
                  tabledata "Reason Code" = R,
                  tabledata "Salesperson/Purchaser" = R,
                  tabledata "Source Code Setup" = R,
                  tabledata "Stockkeeping Unit" = R,
                  tabledata "Stockkeeping Unit Comment Line" = R,
                  tabledata "Transaction Type" = R,
                  tabledata "Transport Method" = R,
                  tabledata "User Setup" = R,
                  tabledata "Value Entry" = Rim,
                  tabledata "VAT Assisted Setup Bus. Grp." = R,
                  tabledata "VAT Assisted Setup Templates" = R,
                  tabledata "VAT Business Posting Group" = R,
                  tabledata "VAT Period" = R,
                  tabledata "VAT Posting Setup" = R,
                  tabledata "VAT Product Posting Group" = R,
                  tabledata "VAT Rate Change Conversion" = R,
                  tabledata "VAT Rate Change Log Entry" = Ri,
                  tabledata "VAT Rate Change Setup" = R,
                  tabledata "VAT Setup Posting Groups" = R;
}
