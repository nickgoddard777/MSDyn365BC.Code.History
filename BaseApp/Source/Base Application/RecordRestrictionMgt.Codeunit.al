codeunit 1550 "Record Restriction Mgt."
{
    Permissions = TableData "Restricted Record" = rimd;

    trigger OnRun()
    begin
    end;

    var
        RecordRestrictedTxt: Label 'You cannot use %1 for this action.', Comment = 'You cannot use Customer 10000 for this action.';
        RestrictLineUsageDetailsTxt: Label 'The restriction was imposed because the line requires approval.';
        RestrictBatchUsageDetailsTxt: Label 'The restriction was imposed because the journal batch requires approval.';

    procedure RestrictRecordUsage(RecVar: Variant; RestrictionDetails: Text)
    var
        RestrictedRecord: Record "Restricted Record";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(RecVar);
        if RecRef.IsTemporary then
            exit;

        RestrictedRecord.SetRange("Record ID", RecRef.RecordId);
        if RestrictedRecord.FindFirst then begin
            RestrictedRecord.Details := CopyStr(RestrictionDetails, 1, MaxStrLen(RestrictedRecord.Details));
            RestrictedRecord.Modify(true);
        end else begin
            RestrictedRecord.Init();
            RestrictedRecord."Record ID" := RecRef.RecordId;
            RestrictedRecord.Details := CopyStr(RestrictionDetails, 1, MaxStrLen(RestrictedRecord.Details));
            RestrictedRecord.Insert(true);
        end;
    end;

    procedure AllowGenJournalBatchUsage(GenJournalBatch: Record "Gen. Journal Batch")
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        AllowRecordUsage(GenJournalBatch);

        GenJournalLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        if GenJournalLine.FindSet then
            repeat
                AllowRecordUsage(GenJournalLine);
            until GenJournalLine.Next() = 0;
    end;

    procedure AllowItemJournalBatchUsage(ItemJournalBatch: Record "Item Journal Batch")
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        AllowRecordUsage(ItemJournalBatch);

        ItemJournalLine.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name", ItemJournalBatch.Name);
        if ItemJournalLine.FindSet then
            repeat
                AllowRecordUsage(ItemJournalLine);
            until ItemJournalLine.Next() = 0;
    end;

    procedure AllowFAJournalBatchUsage(FAJournalBatch: Record "FA Journal Batch")
    var
        FAJournalLine: Record "FA Journal Line";
    begin
        AllowRecordUsage(FAJournalBatch);

        FAJournalLine.SetRange("Journal Template Name", FAJournalBatch."Journal Template Name");
        FAJournalLine.SetRange("Journal Batch Name", FAJournalBatch.Name);
        if FAJournalLine.FindSet then
            repeat
                AllowRecordUsage(FAJournalLine);
            until FAJournalLine.Next() = 0;
    end;

    procedure AllowRecordUsage(RecVar: Variant)
    var
        RestrictedRecord: Record "Restricted Record";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(RecVar);
        if RecRef.IsTemporary then
            exit;
        if RestrictedRecord.IsEmpty() then
            exit;

        RestrictedRecord.SetRange("Record ID", RecRef.RecordId);
        RestrictedRecord.DeleteAll(true);
    end;

    local procedure UpdateRestriction(RecVar: Variant; xRecVar: Variant)
    var
        RestrictedRecord: Record "Restricted Record";
        RecRef: RecordRef;
        xRecRef: RecordRef;
    begin
        xRecRef.GetTable(xRecVar);
        RecRef.GetTable(RecVar);

        if RecRef.IsTemporary then
            exit;

        if RestrictedRecord.IsEmpty() then
            exit;

        RestrictedRecord.SetRange("Record ID", xRecRef.RecordId);
        RestrictedRecord.ModifyAll("Record ID", RecRef.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterInsertEvent', '', false, false)]
    procedure RestrictGenJournalLineAfterInsert(var Rec: Record "Gen. Journal Line"; RunTrigger: Boolean)
    begin
        RestrictGenJournalLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterModifyEvent', '', false, false)]
    procedure RestrictGenJournalLineAfterModify(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; RunTrigger: Boolean)
    begin
        if Format(Rec) = Format(xRec) then
            exit;
        RestrictGenJournalLine(Rec);
    end;

    local procedure RestrictGenJournalLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if GenJournalLine."System-Created Entry" or GenJournalLine.IsTemporary then
            exit;

        if ApprovalsMgmt.IsGeneralJournalLineApprovalsWorkflowEnabled(GenJournalLine) then
            RestrictRecordUsage(GenJournalLine, RestrictLineUsageDetailsTxt);

        if GenJournalBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") then
            if ApprovalsMgmt.IsGeneralJournalBatchApprovalsWorkflowEnabled(GenJournalBatch) then
                RestrictRecordUsage(GenJournalLine, RestrictBatchUsageDetailsTxt);
    end;

    local procedure CheckGenJournalBatchHasUsageRestrictions(GenJournalBatch: Record "Gen. Journal Batch")
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        CheckRecordHasUsageRestrictions(GenJournalBatch);

        GenJournalLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        if GenJournalLine.FindSet then
            repeat
                CheckRecordHasUsageRestrictions(GenJournalLine);
            until GenJournalLine.Next() = 0;
    end;

    [TryFunction]
    procedure CheckRecordHasUsageRestrictions(RecVar: Variant)
    var
        RestrictedRecord: Record "Restricted Record";
        RecRef: RecordRef;
        ErrorMessage: Text;
    begin
        RecRef.GetTable(RecVar);
        if RecRef.IsTemporary then
            exit;
        if RestrictedRecord.IsEmpty() then
            exit;

        RestrictedRecord.SetRange("Record ID", RecRef.RecordId);
        if not RestrictedRecord.FindFirst then
            exit;

        ErrorMessage :=
          StrSubstNo(
            RecordRestrictedTxt,
            Format(Format(RestrictedRecord."Record ID", 0, 1))) + '\\' + RestrictedRecord.Details;

        Error(ErrorMessage);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCheckSalesPostRestrictions', '', false, false)]
    procedure CustomerCheckSalesPostRestrictions(var Sender: Record "Sales Header")
    var
        Customer: Record Customer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCustomerCheckSalesPostRestrictions(Sender, IsHandled);
        if IsHandled then
            exit;

        Customer.Get(Sender."Sell-to Customer No.");
        CheckRecordHasUsageRestrictions(Customer);
        if Sender."Sell-to Customer No." = Sender."Bill-to Customer No." then
            exit;
        Customer.Get(Sender."Bill-to Customer No.");
        CheckRecordHasUsageRestrictions(Customer);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnCheckPurchasePostRestrictions', '', false, false)]
    procedure VendorCheckPurchasePostRestrictions(var Sender: Record "Purchase Header")
    var
        Vendor: Record Vendor;
    begin
        Vendor.Get(Sender."Buy-from Vendor No.");
        CheckRecordHasUsageRestrictions(Vendor);
        if Sender."Buy-from Vendor No." = Sender."Pay-to Vendor No." then
            exit;
        Vendor.Get(Sender."Pay-to Vendor No.");
        CheckRecordHasUsageRestrictions(Vendor);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnCheckGenJournalLinePostRestrictions', '', false, false)]
    procedure CustomerCheckGenJournalLinePostRestrictions(var Sender: Record "Gen. Journal Line")
    var
        Customer: Record Customer;
    begin
        if (Sender."Account Type" = Sender."Account Type"::Customer) and (Sender."Account No." <> '') then begin
            Customer.Get(Sender."Account No.");
            CheckRecordHasUsageRestrictions(Customer);
        end;

        if (Sender."Bal. Account Type" = Sender."Bal. Account Type"::Customer) and (Sender."Bal. Account No." <> '') then begin
            Customer.Get(Sender."Bal. Account No.");
            CheckRecordHasUsageRestrictions(Customer);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnCheckGenJournalLinePostRestrictions', '', false, false)]
    procedure VendorCheckGenJournalLinePostRestrictions(var Sender: Record "Gen. Journal Line")
    var
        Vendor: Record Vendor;
    begin
        if (Sender."Account Type" = Sender."Account Type"::Vendor) and (Sender."Account No." <> '') then begin
            Vendor.Get(Sender."Account No.");
            CheckRecordHasUsageRestrictions(Vendor);
        end;

        if (Sender."Bal. Account Type" = Sender."Bal. Account Type"::Vendor) and (Sender."Bal. Account No." <> '') then begin
            Vendor.Get(Sender."Bal. Account No.");
            CheckRecordHasUsageRestrictions(Vendor);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnCheckItemJournalLinePostRestrictions', '', false, false)]
    local procedure ItemJournalLineCheckItemPostRestrictions(var Sender: Record "Item Journal Line")
    var
        Item: Record Item;
    begin
        CheckRecordHasUsageRestrictions(Sender);
        Item.Get(Sender."Item No.");
        CheckRecordHasUsageRestrictions(Item);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnCheckGenJournalLinePostRestrictions', '', false, false)]
    procedure GenJournalLineCheckGenJournalLinePostRestrictions(var Sender: Record "Gen. Journal Line")
    begin
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnCheckGenJournalLinePrintCheckRestrictions', '', false, false)]
    procedure GenJournalLineCheckGenJournalLinePrintCheckRestrictions(var Sender: Record "Gen. Journal Line")
    begin
        if Sender."Bank Payment Type" = Sender."Bank Payment Type"::"Computer Check" then
            CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Check Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]
    procedure CheckPrintRestrictionsBeforeInsertCheckLedgerEntry(var Rec: Record "Check Ledger Entry"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
    begin
        if not RecRef.Get(Rec."Record ID to Print") then
            exit;

        CheckRecordHasUsageRestrictions(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Check Ledger Entry", 'OnBeforeModifyEvent', '', false, false)]
    procedure CheckPrintRestrictionsBeforeModifyCheckLedgerEntry(var Rec: Record "Check Ledger Entry"; var xRec: Record "Check Ledger Entry"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
    begin
        if not RecRef.Get(Rec."Record ID to Print") then
            exit;

        CheckRecordHasUsageRestrictions(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnCheckGenJournalLinePostRestrictions', '', false, false)]
    procedure GenJournalBatchCheckGenJournalLinePostRestrictions(var Sender: Record "Gen. Journal Line")
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        if not GenJournalBatch.Get(Sender."Journal Template Name", Sender."Journal Batch Name") then
            exit;

        CheckRecordHasUsageRestrictions(GenJournalBatch);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Batch", 'OnCheckGenJournalLineExportRestrictions', '', false, false)]
    procedure GenJournalBatchCheckGenJournalLineExportRestrictions(var Sender: Record "Gen. Journal Batch")
    begin
        if not Sender."Allow Payment Export" then
            exit;

        CheckGenJournalBatchHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCheckSalesPostRestrictions', '', false, false)]
    procedure SalesHeaderCheckSalesPostRestrictions(var Sender: Record "Sales Header")
    begin
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCheckSalesReleaseRestrictions', '', false, false)]
    procedure SalesHeaderCheckSalesReleaseRestrictions(var Sender: Record "Sales Header")
    begin
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnCheckPurchasePostRestrictions', '', false, false)]
    procedure PurchaseHeaderCheckPurchasePostRestrictions(var Sender: Record "Purchase Header")
    begin
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnCheckPurchaseReleaseRestrictions', '', false, false)]
    procedure PurchaseHeaderCheckPurchaseReleaseRestrictions(var Sender: Record "Purchase Header")
    begin
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Order Header", 'OnCheckPaymentOrderIssueRestrictions', '', false, false)]
    [Scope('OnPrem')]
    procedure PaymentOrderHeaderCheckPaymentOrderIssueRestrictions(var Sender: Record "Payment Order Header")
    begin
        // NAVCZ
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [Obsolete('Moved to Cash Desk Localization for Czech.', '17.4')]
    [EventSubscriber(ObjectType::Table, Database::"Cash Document Header", 'OnCheckCashDocPostRestrictions', '', false, false)]
    [Scope('OnPrem')]
    procedure CashDocHeaderCheckCashDocPostRestrictions(var Sender: Record "Cash Document Header")
    begin
        // NAVCZ
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [Obsolete('Moved to Cash Desk Localization for Czech.', '17.4')]
    [EventSubscriber(ObjectType::Table, Database::"Cash Document Header", 'OnCheckCashDocReleaseRestrictions', '', false, false)]
    [Scope('OnPrem')]
    procedure CashDocHeaderCheckCashDocReleaseRestrictions(var Sender: Record "Cash Document Header")
    begin
        // NAVCZ
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [Obsolete('Moved to Compensation Localization Pack for Czech.', '18.0')]
    [EventSubscriber(ObjectType::Table, Database::"Credit Header", 'OnCheckCreditPostRestrictions', '', false, false)]
    [Scope('OnPrem')]
    procedure CreditHeaderCheckCreditPostRestrictions(var Sender: Record "Credit Header")
    begin
        // NAVCZ
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [Obsolete('Moved to Compensation Localization Pack for Czech.', '18.0')]
    [EventSubscriber(ObjectType::Table, Database::"Credit Header", 'OnCheckCreditReleaseRestrictions', '', false, false)]
    [Scope('OnPrem')]
    procedure CreditHeaderCheckCreditReleaseRestrictions(var Sender: Record "Credit Header")
    begin
        // NAVCZ
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Credit Header", 'OnCheckCreditPrintRestrictions', '', false, false)]
    [Scope('OnPrem')]
    [Obsolete('Moved to Compensation Localization Pack for Czech.', '18.0')]
    procedure CreditHeaderCheckCreditPrintRestrictions(var Sender: Record "Credit Header")
    begin
        // NAVCZ
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Advance Letter Header", 'OnCheckSalesAdvanceLetterPostRestrictions', '', false, false)]
    [Scope('OnPrem')]
    procedure SalesAdvanceLetterHeaderCheckSalesAdvanceLetterPostRestrictions(var Sender: Record "Sales Advance Letter Header")
    begin
        // NAVCZ
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Advance Letter Header", 'OnCheckSalesAdvanceLetterReleaseRestrictions', '', false, false)]
    [Scope('OnPrem')]
    procedure SalesAdvanceLetterHeaderCheckSalesAdvanceLetterReleaseRestrictions(var Sender: Record "Sales Advance Letter Header")
    begin
        // NAVCZ
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Advance Letter Header", 'OnCheckPurchaseAdvanceLetterPostRestrictions', '', false, false)]
    [Scope('OnPrem')]
    procedure PurchAdvanceLetterHeaderCheckPurchaseAdvanceLetterPostRestrictions(var Sender: Record "Purch. Advance Letter Header")
    begin
        // NAVCZ
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Advance Letter Header", 'OnCheckPurchaseAdvanceLetterReleaseRestrictions', '', false, false)]
    [Scope('OnPrem')]
    procedure PurchAdvanceLetterHeaderCheckPurchaseAdvanceLetterReleaseRestrictions(var Sender: Record "Purch. Advance Letter Header")
    begin
        // NAVCZ
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Customer", 'OnBeforeDeleteEvent', '', false, false)]
    procedure RemoveCustomerRestrictionsBeforeDelete(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor", 'OnBeforeDeleteEvent', '', false, false)]
    procedure RemoveVendorRestrictionsBeforeDelete(var Rec: Record Vendor; RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item", 'OnBeforeDeleteEvent', '', false, false)]
    procedure RemoveItemRestrictionsBeforeDelete(var Rec: Record Item; RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeDeleteEvent', '', false, false)]
    procedure RemoveGenJournalLineRestrictionsBeforeDelete(var Rec: Record "Gen. Journal Line"; RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Batch", 'OnBeforeDeleteEvent', '', false, false)]
    procedure RemoveGenJournalBatchRestrictionsBeforeDelete(var Rec: Record "Gen. Journal Batch"; RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]
    procedure RemoveSalesHeaderRestrictionsBeforeDelete(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeDeleteEvent', '', false, false)]
    procedure RemovePurchaseHeaderRestrictionsBeforeDelete(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Order Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure RemovePaymentOrderHeaderRestrictionsBeforeDelete(var Rec: Record "Payment Order Header"; RunTrigger: Boolean)
    begin
        // NAVCZ
        AllowRecordUsage(Rec);
    end;

    [Obsolete('Moved to Cash Desk Localization for Czech.', '17.4')]
    [EventSubscriber(ObjectType::Table, Database::"Cash Document Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure RemoveCashDocHeaderRestrictionsBeforeDelete(var Rec: Record "Cash Document Header"; RunTrigger: Boolean)
    begin
        // NAVCZ
        AllowRecordUsage(Rec);
    end;

    [Obsolete('Moved to Compensation Localization Pack for Czech.', '18.0')]
    [EventSubscriber(ObjectType::Table, Database::"Credit Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure RemoveCreditHeaderRestrictionsBeforeDelete(var Rec: Record "Credit Header"; RunTrigger: Boolean)
    begin
        // NAVCZ
        AllowRecordUsage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Advance Letter Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure RemoveSalesAdvanceLetterHeaderRestrictionsBeforeDelete(var Rec: Record "Sales Advance Letter Header"; RunTrigger: Boolean)
    begin
        // NAVCZ
        AllowRecordUsage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Advance Letter Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure RemovePurchAdvanceLetterHeaderRestrictionsBeforeDelete(var Rec: Record "Purch. Advance Letter Header"; RunTrigger: Boolean)
    begin
        // NAVCZ
        AllowRecordUsage(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterRenameEvent', '', false, false)]
    procedure UpdateGenJournalLineRestrictionsAfterRename(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; RunTrigger: Boolean)
    begin
        UpdateRestriction(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Incoming Document", 'OnCheckIncomingDocSetForOCRRestrictions', '', false, false)]
    procedure IncomingDocCheckSetForOCRRestrictions(var Sender: Record "Incoming Document")
    begin
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Incoming Document", 'OnCheckIncomingDocReleaseRestrictions', '', false, false)]
    procedure IncomingDocCheckReleaseRestrictions(var Sender: Record "Incoming Document")
    begin
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Batch", 'OnAfterRenameEvent', '', false, false)]
    procedure UpdateGenJournalBatchRestrictionsAfterRename(var Rec: Record "Gen. Journal Batch"; var xRec: Record "Gen. Journal Batch"; RunTrigger: Boolean)
    begin
        UpdateRestriction(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterRenameEvent', '', false, false)]
    procedure UpdateSalesHeaderRestrictionsAfterRename(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean)
    begin
        UpdateRestriction(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterRenameEvent', '', false, false)]
    procedure UpdatePurchaseHeaderRestrictionsAfterRename(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; RunTrigger: Boolean)
    begin
        UpdateRestriction(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Incoming Document", 'OnCheckIncomingDocCreateDocRestrictions', '', false, false)]
    procedure IncomingDocCheckCreateDocRestrictions(var Sender: Record "Incoming Document")
    begin
        CheckRecordHasUsageRestrictions(Sender);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCustomerCheckSalesPostRestrictions(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Order Header", 'OnAfterRenameEvent', '', false, false)]
    local procedure UpdatePaymentOrderHeaderRestrictionsAfterRename(var Rec: Record "Payment Order Header"; var xRec: Record "Payment Order Header"; RunTrigger: Boolean)
    begin
        // NAVCZ
        UpdateRestriction(Rec, xRec);
    end;

    [Obsolete('Moved to Cash Desk Localization for Czech.', '17.4')]
    [EventSubscriber(ObjectType::Table, Database::"Cash Document Header", 'OnAfterRenameEvent', '', false, false)]
    local procedure UpdateCashDocHeaderRestrictionsAfterRename(var Rec: Record "Cash Document Header"; var xRec: Record "Cash Document Header"; RunTrigger: Boolean)
    begin
        // NAVCZ
        UpdateRestriction(Rec, xRec);
    end;

    [Obsolete('Moved to Compensation Localization Pack for Czech.', '18.0')]
    [EventSubscriber(ObjectType::Table, Database::"Credit Header", 'OnAfterRenameEvent', '', false, false)]
    local procedure UpdateCreditHeaderRestrictionsAfterRename(var Rec: Record "Credit Header"; var xRec: Record "Credit Header"; RunTrigger: Boolean)
    begin
        // NAVCZ
        UpdateRestriction(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Advance Letter Header", 'OnAfterRenameEvent', '', false, false)]
    local procedure UpdateSalesAdvanceLetterHeaderRestrictionsAfterRename(var Rec: Record "Sales Advance Letter Header"; var xRec: Record "Sales Advance Letter Header"; RunTrigger: Boolean)
    begin
        // NAVCZ
        UpdateRestriction(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Advance Letter Header", 'OnAfterRenameEvent', '', false, false)]
    local procedure UpdatePurchAdvanceLetterHeaderRestrictionsAfterRename(var Rec: Record "Purch. Advance Letter Header"; var xRec: Record "Purch. Advance Letter Header"; RunTrigger: Boolean)
    begin
        // NAVCZ
        UpdateRestriction(Rec, xRec);
    end;
}

