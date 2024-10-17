codeunit 11761 "G/L Entry - Edit CZ"
{
    Permissions = TableData "G/L Entry" = imd;
    TableNo = "G/L Entry";

    trigger OnRun()
    begin
        GLEntry := Rec;
        GLEntry.LockTable();
        GLEntry.Find;
        GLEntry."Applies-to ID" := "Applies-to ID";
        GLEntry.Validate("Amount to Apply", "Amount to Apply");
        GLEntry.Modify();
        Rec := GLEntry;
    end;

    var
        GLEntry: Record "G/L Entry";
}

