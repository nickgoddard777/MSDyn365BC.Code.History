page 982 "Payment Registration Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Payment Registration Setup';
    DataCaptionExpression = PageCaption;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Payment Registration Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                InstructionalText = 'Select which balancing account you want to register the payment to, as well as which journal template to use.';
                field("Journal Template Name"; "Journal Template Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the journal template that the Payment Registration window is based on.';
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the journal batch that the Payment Registration window is based on.';
                }
                field("Bal. Account Type"; "Bal. Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Balancing Account Type';
                    ToolTip = 'Specifies the type of account that is used as the balancing account for payments. The field is filled according to the selection in the Journal Batch Name field.';
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Balancing Account';
                    ToolTip = 'Specifies the account number that is used as the balancing account for payments.';
                }
                field("Use this Account as Def."; "Use this Account as Def.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Use this Account as Default';
                    ToolTip = 'Specifies if the Date Received and the Amount Received fields are automatically filled when you select the Payment Made check box.';
                }
                field("Auto Fill Date Received"; "Auto Fill Date Received")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Automatically Fill Date Received';
                    ToolTip = 'Specifies if the account in the Bal. Account No. field is used for all payments.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not Get(UserId) then begin
            if Get then;

            "User ID" := UserId;
            Insert;
        end;

        PageCaption := '';
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            exit(ValidateMandatoryFields(true));
    end;

    var
        PageCaption: Text[10];
}

