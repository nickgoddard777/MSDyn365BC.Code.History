query 18039 GSTR1B2CInterCess
{
    QueryType = Normal;

    elements
    {
        dataitem(Detailed_GST_Ledger_Entry; "Detailed GST Ledger Entry")
        {
            DataItemTableFilter = "GST Component Code" = filter(= 'CESS');
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
            filter(GST_Customer_Type; "GST Customer Type")
            {
            }
            filter(Document_Line_No_; "Document Line No.")
            {
            }
            column(GST_Component_Code; "GST Component Code")
            {
            }
            column(GST_Jurisdiction_Type; "GST Jurisdiction Type")
            {
            }
            column(GST__; "GST %")
            {
            }
            column(GST_Amount; "GST Amount")
            {
                Method = Sum;
            }
            dataitem(Detailed_GST_Ledger_Entry_Info; "Detailed GST Ledger Entry Info")
            {
                SqlJoinType = InnerJoin;
                DataItemLink = "Entry No." = Detailed_GST_Ledger_Entry."Entry No.";
                column(Nature_of_Supply; "Nature of Supply")
                {
                    ColumnFilter = Nature_of_Supply = const(B2C);
                }
                column(Buyer_Seller_State_Code; "Buyer/Seller State Code")
                {
                }
                column(e_Comm__Operator_GST_Reg__No_; "e-Comm. Operator GST Reg. No.")
                {

                }
                dataitem(Cust__Ledger_Entry; "Cust. Ledger Entry")
                {
                    DataItemLink = "Document No." = Detailed_GST_Ledger_Entry."Document No.", "Document Type" = Detailed_GST_Ledger_Entry."Document Type";
                    DataItemTableFilter = "GST Jurisdiction Type" = const(Interstate);
                    SqlJoinType = InnerJoin;
                    filter(Amount__LCY_; "Amount (LCY)")
                    {
                        ColumnFilter = Amount__LCY_ = filter(<= 250000);
                    }
                }
            }
        }
    }
}