query 18030 GSTR1HSNQuery
{
    QueryType = Normal;

    elements
    {
        dataitem(Detailed_GST_Ledger_Entry; "Detailed GST Ledger Entry")
        {
            filter(Document_Type; "Document Type")
            {
            }
            filter(Entry_Type; "Entry Type")
            {
                ColumnFilter = Entry_Type = filter(= "Initial Entry");
            }
            filter(Location__Reg__No_; "Location  Reg. No.")
            {
            }
            filter(Transaction_Type; "Transaction Type")
            {
                ColumnFilter = Transaction_Type = const(Sales);
            }
            filter(Posting_Date; "Posting Date")
            {
            }
            column(HSN_SAC_Code; "HSN/SAC Code")
            {
            }
            column(GST_Base_Amount; "GST Base Amount")
            {
                Method = Sum;
            }
            dataitem(Detailed_GST_Ledger_Entry_Info; "Detailed GST Ledger Entry Info")
            {
                SqlJoinType = InnerJoin;
                DataItemLink = "Entry No." = Detailed_GST_Ledger_Entry."Entry No.";
                column(UOM; UOM)
                {
                }
                dataitem(HSN_SAC; "HSN/SAC")
                {
                    DataItemLink = Code = Detailed_GST_Ledger_Entry."HSN/SAC Code", "GST Group Code" = Detailed_GST_Ledger_Entry."GST Group Code";
                    SqlJoinType = InnerJoin;

                    column(Description; Description)
                    {
                    }
                }
            }
        }
    }
}