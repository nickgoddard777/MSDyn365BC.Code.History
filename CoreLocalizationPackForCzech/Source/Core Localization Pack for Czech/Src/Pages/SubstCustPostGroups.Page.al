page 31027 "Subst. Cust. Post. Groups CZL"
{
    Caption = 'Subst. Customer Posting Groups';
    DataCaptionFields = "Parent Customer Posting Group";
    PageType = List;
    SourceTable = "Subst. Cust. Posting Group CZL";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer''s market type to link business transactions to.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }
}