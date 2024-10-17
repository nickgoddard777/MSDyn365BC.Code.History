codeunit 11732 "Cash Document-Release + Print"
{
    TableNo = "Cash Document Header";

    trigger OnRun()
    begin
        CashDocumentHeader.Copy(Rec);
        Code;
        Rec := CashDocumentHeader;
    end;

    var
        CashDocumentHeader: Record "Cash Document Header";
        ApprovalProcessErr: Label 'This document can only be released when the approval process is complete.';
        EETDocReleaseDeniedErr: Label 'Cash document containing EET line cannot be released only.';

    local procedure "Code"()
    begin
        CODEUNIT.Run(CODEUNIT::"Cash Document-Release", CashDocumentHeader);
        GetReport(CashDocumentHeader);
        Commit();
    end;

    [Scope('OnPrem')]
    procedure PerformManualRelease(var CashDocumentHeader: Record "Cash Document Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if ApprovalsMgmt.IsCashDocApprovalsWorkflowEnabled(CashDocumentHeader) and
           (CashDocumentHeader.Status = CashDocumentHeader.Status::Open)
        then
            Error(ApprovalProcessErr);

        if CashDocumentHeader.IsEETTransaction then
            Error(EETDocReleaseDeniedErr);

        CODEUNIT.Run(CODEUNIT::"Cash Document-Release + Print", CashDocumentHeader);
    end;

    [Scope('OnPrem')]
    procedure GetReport(var CashDocumentHeader: Record "Cash Document Header")
    begin
        CashDocumentHeader.SetRecFilter;
        CashDocumentHeader.PrintRecords(false);
    end;
}

