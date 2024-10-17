report 5695 "Delete Empty Insurance Reg."
{
    Caption = 'Delete Empty Insurance Reg.';
    Permissions = TableData "Insurance Register" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Insurance Register"; "Insurance Register")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "Creation Date";

            trigger OnAfterGetRecord()
            begin
                InsCoverageLedgEntry.SetRange("Entry No.", "From Entry No.", "To Entry No.");
                if InsCoverageLedgEntry.FindFirst then
                    CurrReport.Skip;
                Window.Update(1, "No.");
                Window.Update(2, "Creation Date");
                Delete;
                NoOfDeleted := NoOfDeleted + 1;
                Window.Update(3, NoOfDeleted);
                if NoOfDeleted >= NoOfDeleted2 + 10 then begin
                    NoOfDeleted2 := NoOfDeleted;
                    Commit;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if not Confirm(Text000, false) then
                    CurrReport.Break;

                Window.Open(
                  Text001 +
                  Text002 +
                  Text003 +
                  Text004);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: Label 'Do you want to delete the registers?';
        Text001: Label 'Deleting empty insurance registers...\\';
        Text002: Label 'No.                      #1######\';
        Text003: Label 'Posted on                #2######\\';
        Text004: Label 'No. of registers deleted #3######';
        InsCoverageLedgEntry: Record "Ins. Coverage Ledger Entry";
        Window: Dialog;
        NoOfDeleted: Integer;
        NoOfDeleted2: Integer;
}

