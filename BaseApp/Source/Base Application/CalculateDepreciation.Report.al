report 5692 "Calculate Depreciation"
{
    AdditionalSearchTerms = 'write down fixed asset';
    ApplicationArea = FixedAssets;
    Caption = 'Calculate Depreciation';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            RequestFilterFields = "No.", "FA Class Code", "FA Subclass Code", "Budgeted Asset";

            trigger OnAfterGetRecord()
            begin
                if Inactive or Blocked then
                    CurrReport.Skip();

                OnBeforeCalculateDepreciation(
                    "No.", TempGenJnlLine, TempFAJnlLine, DeprAmount, NumberOfDays, DeprBookCode, DeprUntilDate, EntryAmounts, DaysInPeriod);

                CalculateDepr.Calculate(
                    DeprAmount, Custom1Amount, NumberOfDays, Custom1NumberOfDays, "No.", DeprBookCode, DeprUntilDate, EntryAmounts, 0D, DaysInPeriod,
                    UseCustom1, UseCustom2, Custom2Amount, ForcedPercent1, ForcedPercent2);

                if (DeprAmount <> 0) or (Custom1Amount <> 0) or (Custom2Amount <> 0) then
                    Window.Update(1, "No.")
                else
                    Window.Update(2, "No.");

                Custom1Amount := round(Custom1Amount, GeneralLedgerSetup."Amount Rounding Precision");
                DeprAmount := round(DeprAmount, GeneralLedgerSetup."Amount Rounding Precision");

                OnAfterCalculateDepreciation(
                    "No.", TempGenJnlLine, TempFAJnlLine, DeprAmount, NumberOfDays, DeprBookCode, DeprUntilDate, EntryAmounts, DaysInPeriod);

                if DeprAmount <> 0 then
                    if not DeprBook."G/L Integration - Depreciation" or "Budgeted Asset" then begin
                        TempFAJnlLine."FA No." := "No.";
                        TempFAJnlLine."Document No." := DocumentNo[1];
                        TempFAJnlLine."FA Posting Type" := TempFAJnlLine."FA Posting Type"::Depreciation;
                        TempFAJnlLine.Amount := DeprAmount;
                        TempFAJnlLine."No. of Depreciation Days" := NumberOfDays;
                        TempFAJnlLine."FA Error Entry No." := ErrorNo;
                        TempFAJnlLine."Line No." := TempFAJnlLine."Line No." + 1;
                        TempFAJnlLine.Insert();
                    end else begin
                        TempGenJnlLine."Account No." := "No.";
                        TempGenJnlLine."Document No." := DocumentNo[1];
                        TempGenJnlLine."FA Posting Type" := TempGenJnlLine."FA Posting Type"::Depreciation;
                        TempGenJnlLine.Amount := DeprAmount;
                        TempGenJnlLine."No. of Depreciation Days" := NumberOfDays;
                        TempGenJnlLine."FA Error Entry No." := ErrorNo;
                        TempGenJnlLine."Line No." := TempGenJnlLine."Line No." + 1;
                        TempGenJnlLine.Insert();
                    end;

                if Custom1Amount <> 0 then
                    if not DeprBook."G/L Integration - Custom 1" or "Budgeted Asset" then begin
                        TempFAJnlLine."FA No." := "No.";
                        TempFAJnlLine."Document No." := DocumentNo[2];
                        TempFAJnlLine."FA Posting Type" := TempFAJnlLine."FA Posting Type"::"Custom 1";
                        TempFAJnlLine.Amount := Custom1Amount;
                        TempFAJnlLine."No. of Depreciation Days" := NumberOfDays;
                        TempFAJnlLine."FA Error Entry No." := Custom1ErrorNo;
                        TempFAJnlLine."Line No." := TempFAJnlLine."Line No." + 1;
                        TempFAJnlLine.Insert();
                    end else begin
                        TempGenJnlLine."Account No." := "No.";
                        TempGenJnlLine."Document No." := DocumentNo[2];
                        TempGenJnlLine."FA Posting Type" := TempGenJnlLine."FA Posting Type"::"Custom 1";
                        TempGenJnlLine.Amount := Custom1Amount;
                        TempGenJnlLine."No. of Depreciation Days" := NumberOfDays;
                        TempGenJnlLine."FA Error Entry No." := Custom1ErrorNo;
                        TempGenJnlLine."Line No." := TempGenJnlLine."Line No." + 1;
                        TempGenJnlLine.Insert();
                    end;

                if Custom2Amount <> 0 then
                    if not DeprBook."G/L Integration - Custom 2" or "Budgeted Asset" then begin
                        TempFAJnlLine."FA No." := "No.";
                        TempFAJnlLine."Document No." := DocumentNo[3];
                        TempFAJnlLine."FA Posting Type" := TempFAJnlLine."FA Posting Type"::"Custom 2";
                        TempFAJnlLine.Amount := Custom2Amount;
                        TempFAJnlLine."No. of Depreciation Days" := NumberOfDays;
                        TempFAJnlLine."FA Error Entry No." := Custom1ErrorNo;
                        TempFAJnlLine."Line No." := TempFAJnlLine."Line No." + 1;
                        TempFAJnlLine.Insert();
                    end else begin
                        TempGenJnlLine."Account No." := "No.";
                        TempGenJnlLine."Document No." := DocumentNo[3];
                        TempGenJnlLine."FA Posting Type" := TempGenJnlLine."FA Posting Type"::"Custom 2";
                        TempGenJnlLine.Amount := Custom2Amount;
                        TempGenJnlLine."No. of Depreciation Days" := NumberOfDays;
                        TempGenJnlLine."FA Error Entry No." := Custom1ErrorNo;
                        TempGenJnlLine."Line No." := TempGenJnlLine."Line No." + 1;
                        TempGenJnlLine.Insert();
                    end;
            end;

            trigger OnPostDataItem()
            var
                NeedCommit: Boolean;
            begin
                with FAJnlLine do begin
                    if TempFAJnlLine.Find('-') then begin
                        NeedCommit := true;
                        LockTable();
                        FAJnlSetup.FAJnlName(DeprBook, FAJnlLine, FAJnlNextLineNo);
                        NoSeries := FAJnlSetup.GetFANoSeries(FAJnlLine);
                        if UseAutomaticDocumentNo then begin
                            if FindLast() then
                                DocumentNo2 := "Document No."
                            else
                                DocumentNo2 := FAJnlSetup.GetFAJnlDocumentNo(FAJnlLine, DeprUntilDate, true);
                            if DocumentNo2 = '' then
                                Error(Text000, FieldCaption("Document No."));
                        end;
                    end;
                    if TempFAJnlLine.Find('-') then
                        repeat
                            Init;
                            "Line No." := 0;
                            FAJnlSetup.SetFAJnlTrailCodes(FAJnlLine);
                            LineNo := LineNo + 1;
                            Window.Update(3, LineNo);
                            "Posting Date" := PostingDate;
                            "FA Posting Date" := DeprUntilDate;
                            if "Posting Date" = "FA Posting Date" then
                                "Posting Date" := 0D;
                            "FA Posting Type" := TempFAJnlLine."FA Posting Type";
                            Validate("FA No.", TempFAJnlLine."FA No.");
                            if UseAutomaticDocumentNo then
                                "Document No." := DocumentNo2
                            else
                                "Document No." := TempFAJnlLine."Document No.";
                            "Posting No. Series" := NoSeries;
                            Description := PostingDescription[1];
                            if "FA Posting Type" = "FA Posting Type"::"Custom 1" then
                                Description := PostingDescription[2];
                            if "FA Posting Type" = "FA Posting Type"::"Custom 2" then
                                Description := PostingDescription[3];
                            Validate("Depreciation Book Code", DeprBookCode);
                            Validate(Amount, TempFAJnlLine.Amount);
                            "No. of Depreciation Days" := TempFAJnlLine."No. of Depreciation Days";
                            "FA Error Entry No." := TempFAJnlLine."FA Error Entry No.";
                            FAJnlNextLineNo := FAJnlNextLineNo + 10000;
                            "Line No." := FAJnlNextLineNo;
                            OnBeforeFAJnlLineInsert(TempFAJnlLine, FAJnlLine);
                            Insert(true);
                            FAJnlLineCreatedCount += 1;
                        until TempFAJnlLine.Next() = 0;
                end;

                with GenJnlLine do begin
                    if TempGenJnlLine.Find('-') then begin
                        NeedCommit := true;
                        LockTable();
                        FAJnlSetup.GenJnlName(DeprBook, GenJnlLine, GenJnlNextLineNo);
                        NoSeries := FAJnlSetup.GetGenNoSeries(GenJnlLine);
                        if UseAutomaticDocumentNo then begin
                            if FindLast() then
                                DocumentNo2 := "Document No."
                            else
                                DocumentNo2 := FAJnlSetup.GetGenJnlDocumentNo(GenJnlLine, DeprUntilDate, true);
                            if DocumentNo2 = '' then
                                Error(Text000, FieldCaption("Document No."));
                        end;
                    end;
                    if TempGenJnlLine.Find('-') then
                        repeat
                            Init;
                            "Line No." := 0;
                            FAJnlSetup.SetGenJnlTrailCodes(GenJnlLine);
                            LineNo := LineNo + 1;
                            Window.Update(3, LineNo);
                            "Posting Date" := PostingDate;
                            "FA Posting Date" := DeprUntilDate;
                            if "Posting Date" = "FA Posting Date" then
                                "FA Posting Date" := 0D;
                            "FA Posting Type" := TempGenJnlLine."FA Posting Type";
                            "Account Type" := "Account Type"::"Fixed Asset";
                            Validate("Account No.", TempGenJnlLine."Account No.");
                            Description := PostingDescription[1];
                            if "FA Posting Type" = "FA Posting Type"::"Custom 1" then
                                Description := PostingDescription[2];
                            if "FA Posting Type" = "FA Posting Type"::"Custom 2" then
                                Description := PostingDescription[3];
                            if UseAutomaticDocumentNo then
                                "Document No." := DocumentNo2
                            else
                                "Document No." := TempGenJnlLine."Document No.";
                            "Posting No. Series" := NoSeries;
                            Validate("Depreciation Book Code", DeprBookCode);
                            Validate(Amount, TempGenJnlLine.Amount);
                            "No. of Depreciation Days" := TempGenJnlLine."No. of Depreciation Days";
                            "FA Error Entry No." := TempGenJnlLine."FA Error Entry No.";
                            GenJnlNextLineNo := GenJnlNextLineNo + 1000;
                            "Line No." := GenJnlNextLineNo;
                            OnBeforeGenJnlLineInsert(TempGenJnlLine, GenJnlLine);
                            Insert(true);
                            GenJnlLineCreatedCount += 1;
                            if BalAccount then
                                FAInsertGLAcc.GetBalAcc(GenJnlLine, GenJnlNextLineNo);
                            OnAfterFAInsertGLAccGetBalAcc(GenJnlLine, GenJnlNextLineNo, BalAccount, TempGenJnlLine);
                        until TempGenJnlLine.Next() = 0;
                end;
                OnAfterPostDataItem();
                if NeedCommit then
                    Commit();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DepreciationBook; DeprBookCode)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Depreciation Book';
                        TableRelation = "Depreciation Book";
                        ToolTip = 'Specifies the code for the depreciation book to be included in the report or batch job.';
                    }
                    field(FAPostingDate; DeprUntilDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'FA Posting Date';
                        Importance = Additional;
                        ToolTip = 'Specifies the fixed asset posting date to be used by the batch job. The batch job includes ledger entries up to this date. This date appears in the FA Posting Date field in the resulting journal lines. If the Use Same FA+G/L Posting Dates field has been activated in the depreciation book that is used in the batch job, then this date must be the same as the posting date entered in the Posting Date field.';

                        trigger OnValidate()
                        begin
                            DeprUntilDateModified := true;
                        end;
                    }
                    field(UseForceNoOfDays; UseForceNoOfDays)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Use Force No. of Days';
                        Importance = Additional;
                        ToolTip = 'Specifies if you want the program to use the number of days, as specified in the field below, in the depreciation calculation.';

                        trigger OnValidate()
                        begin
                            if not UseForceNoOfDays then
                                DaysInPeriod := 0;
                        end;
                    }
                    field(ForceNoOfDays; DaysInPeriod)
                    {
                        ApplicationArea = FixedAssets;
                        BlankZero = true;
                        Caption = 'Force No. of Days';
                        Importance = Additional;
                        MinValue = 0;
                        ToolTip = 'Specifies if you want the program to use the number of days, as specified in the field below, in the depreciation calculation.';

                        trigger OnValidate()
                        begin
                            if not UseForceNoOfDays and (DaysInPeriod <> 0) then
                                Error(Text006);
                        end;
                    }
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the posting date to be used by the batch job.';

                        trigger OnValidate()
                        begin
                            if not DeprUntilDateModified then
                                DeprUntilDate := PostingDate;
                        end;
                    }
                    field(InsertBalAccount; BalAccount)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Insert Bal. Account';
                        Importance = Additional;
                        ToolTip = 'Specifies if you want the batch job to automatically insert fixed asset entries with balancing accounts.';
                    }
                    field(UseAnticipatedDepr; UseCustom1)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Use Anticipated Depr.';
                        ToolTip = 'Specifies that you want to include anticipated depreciation.';
                    }
                    field(UseAccRedDepr; UseCustom2)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Use Acc./Red. Depr.';
                        ToolTip = 'Specifies that you want to include accelerated and reduced depreciation.';
                    }
                    group("Normal Depreciation")
                    {
                        Caption = 'Normal Depreciation';
                        field(DocumentNo; DocumentNo[1])
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Document No.';
                            ToolTip = 'Specifies, if you leave the field empty, the next available number on the resulting journal line. If a number series is not set up, enter the document number that you want assigned to the resulting journal line.';
                        }
                        field("PostingDescription[1]"; PostingDescription[1])
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Posting Description';
                            ToolTip = 'Specifies the posting date to be used by the batch job as a filter.';
                        }
                    }
                    group("Anticipated Depreciation")
                    {
                        Caption = 'Anticipated Depreciation';
                        field(DocumentNoAnticipated; DocumentNo[2])
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Document No.';
                            ToolTip = 'Specifies the related document.';
                        }
                        field("PostingDescription[2]"; PostingDescription[2])
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Posting Description';
                            ToolTip = 'Specifies the description from the posted document.';
                        }
                        field(ForcedPercent1; ForcedPercent1)
                        {
                            ApplicationArea = FixedAssets;
                            BlankZero = true;
                            Caption = 'Force Depr. % ';
                            DecimalPlaces = 2 : 8;
                            MinValue = 0;
                            ToolTip = 'Specifies the depreciation percent.';
                        }
                    }
                    group("Acc./Red. Depreciation")
                    {
                        Caption = 'Acc./Red. Depreciation';
                        field(DocumentNoAccRed; DocumentNo[3])
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Document No.';
                            ToolTip = 'Specifies the related document.';
                        }
                        field("PostingDescription[3]"; PostingDescription[3])
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Posting Description';
                            ToolTip = 'Specifies the description from the posted document.';
                        }
                        field(ForcedPercent2; ForcedPercent2)
                        {
                            ApplicationArea = FixedAssets;
                            BlankZero = true;
                            Caption = 'Force Depr. % ';
                            DecimalPlaces = 2 : 8;
                            ToolTip = 'Specifies the depreciation percent.';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            ClientTypeManagement: Codeunit "Client Type Management";
        begin
            BalAccount := true;
            if ClientTypeManagement.GetCurrentClientType() <> CLIENTTYPE::Background then begin
                PostingDate := WorkDate;
                DeprUntilDate := WorkDate;
            end;
            if DeprBookCode = '' then begin
                FASetup.Get();
                DeprBookCode := FASetup."Default Depr. Book";
            end;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        OnBeforeOnInitReport(DeprBookCode);
    end;

    trigger OnPostReport()
    var
        PageGenJnlLine: Record "Gen. Journal Line";
        PageFAJnlLine: Record "FA Journal Line";
        ConfirmMgt: Codeunit "Confirm Management";
        IsHandled: Boolean;
    begin
        if ErrorMessageHandler.HasErrors() then
            if ErrorMessageHandler.ShowErrors() then
                Error('');

        Window.Close;
        if (FAJnlLineCreatedCount = 0) and (GenJnlLineCreatedCount = 0) then begin
            Message(CompletionStatsMsg);
            exit;
        end;

        if FAJnlLineCreatedCount > 0 then begin
            IsHandled := false;
            OnPostReportOnBeforeConfirmShowFAJournalLines(DeprBook, FAJnlLine, FAJnlLineCreatedCount, IsHandled);
            if not IsHandled then
                if ConfirmMgt.GetResponse(StrSubstNo(CompletionStatsFAJnlQst, FAJnlLineCreatedCount), true) then begin
                    PageFAJnlLine.SetRange("Journal Template Name", FAJnlLine."Journal Template Name");
                    PageFAJnlLine.SetRange("Journal Batch Name", FAJnlLine."Journal Batch Name");
                    PageFAJnlLine.FindFirst();
                    PAGE.Run(PAGE::"Fixed Asset Journal", PageFAJnlLine);
                end;
        end;

        if GenJnlLineCreatedCount > 0 then begin
            IsHandled := false;
            OnPostReportOnBeforeConfirmShowGenJournalLines(DeprBook, GenJnlLine, GenJnlLineCreatedCount, IsHandled);
            if not IsHandled then
                if ConfirmMgt.GetResponse(StrSubstNo(CompletionStatsGenJnlQst, GenJnlLineCreatedCount), true) then begin
                    PageGenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                    PageGenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                    PageGenJnlLine.FindFirst();
                    PAGE.Run(PAGE::"Fixed Asset G/L Journal", PageGenJnlLine);
                end;
        end;

        OnAfterOnPostReport();
    end;

    trigger OnPreReport()
    begin
        ActivateErrorMessageHandling("Fixed Asset");

        DeprBook.Get(DeprBookCode);
        if UseCustom1 then
            DeprBook.TestField("Anticipated Depreciation Calc.");
        if UseCustom2 then
            DeprBook.TestField("Acc./Red. Depreciation Calc.");

        if DeprUntilDate = 0D then
            Error(Text000, FAJnlLine.FieldCaption("FA Posting Date"));
        if PostingDate = 0D then
            PostingDate := DeprUntilDate;
        if UseForceNoOfDays and (DaysInPeriod = 0) then
            Error(Text001);

        TestDocumentNo;

        if DeprBook."Use Same FA+G/L Posting Dates" and (DeprUntilDate <> PostingDate) then
            Error(
              Text002,
              FAJnlLine.FieldCaption("FA Posting Date"),
              FAJnlLine.FieldCaption("Posting Date"),
              DeprBook.FieldCaption("Use Same FA+G/L Posting Dates"),
              false,
              DeprBook.TableCaption,
              DeprBook.FieldCaption(Code),
              DeprBook.Code);

        Window.Open(
          Text003 +
          Text004 +
          Text005);
    end;

    var
        Text000: Label 'You must specify %1.';
        Text001: Label 'Force No. of Days must be activated.';
        Text002: Label '%1 and %2 must be identical. %3 must be %4 in %5 %6 = %7.';
        Text003: Label 'Depreciating fixed asset      #1##########\';
        Text004: Label 'Not depreciating fixed asset  #2##########\';
        Text005: Label 'Inserting journal lines       #3##########';
        Text006: Label 'Use Force No. of Days must be activated.';
        GenJnlLine: Record "Gen. Journal Line";
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        FASetup: Record "FA Setup";
        FAJnlLine: Record "FA Journal Line";
        TempFAJnlLine: Record "FA Journal Line" temporary;
        DeprBook: Record "Depreciation Book";
        FAJnlSetup: Record "FA Journal Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        CalculateDepr: Codeunit "Calculate Depreciation";
        FAInsertGLAcc: Codeunit "FA Insert G/L Account";
        ErrorMessageMgt: Codeunit "Error Message Management";
        ErrorContextElement: Codeunit "Error Context Element";
        ErrorMessageHandler: Codeunit "Error Message Handler";
        Window: Dialog;
        DeprAmount: Decimal;
        Custom1Amount: Decimal;
        NumberOfDays: Integer;
        Custom1NumberOfDays: Integer;
        DocumentNo2: Code[20];
        NoSeries: Code[20];
        ErrorNo: Integer;
        Custom1ErrorNo: Integer;
        FAJnlNextLineNo: Integer;
        GenJnlNextLineNo: Integer;
        EntryAmounts: array[4] of Decimal;
        LineNo: Integer;
        Custom2Amount: Decimal;
        UseCustom1: Boolean;
        UseCustom2: Boolean;
        ForcedPercent1: Decimal;
        ForcedPercent2: Decimal;
        Text1130000: Label 'You must specify %1 for %2 = %3.';
        UseAutomaticDocumentNo: Boolean;
        CompletionStatsMsg: Label 'The depreciation has been calculated.\\No journal lines were created.';
        FAJnlLineCreatedCount: Integer;
        GenJnlLineCreatedCount: Integer;
        CompletionStatsFAJnlQst: Label 'The depreciation has been calculated.\\%1 fixed asset journal lines were created.\\Do you want to open the Fixed Asset Journal window?', Comment = 'The depreciation has been calculated.\\5 fixed asset journal lines were created.\\Do you want to open the Fixed Asset Journal window?';
        CompletionStatsGenJnlQst: Label 'The depreciation has been calculated.\\%1 fixed asset G/L journal lines were created.\\Do you want to open the Fixed Asset G/L Journal window?', Comment = 'The depreciation has been calculated.\\2 fixed asset G/L  journal lines were created.\\Do you want to open the Fixed Asset G/L Journal window?';
        DeprUntilDateModified: Boolean;

    protected var
        DeprBookCode: Code[10];
        DeprUntilDate: Date;
        UseForceNoOfDays: Boolean;
        DaysInPeriod: Integer;
        PostingDate: Date;
        DocumentNo: array[3] of Code[20];
        PostingDescription: array[3] of Text[100];
        BalAccount: Boolean;

    procedure InitializeRequest(DeprBookCodeFrom: Code[10]; DeprUntilDateFrom: Date; UseForceNoOfDaysFrom: Boolean; DaysInPeriodFrom: Integer; PostingDateFrom: Date; DocumentNoFrom: Code[20]; PostingDescriptionFrom: Text[100]; BalAccountFrom: Boolean)
    begin
        DeprBookCode := DeprBookCodeFrom;
        DeprUntilDate := DeprUntilDateFrom;
        UseForceNoOfDays := UseForceNoOfDaysFrom;
        DaysInPeriod := DaysInPeriodFrom;
        PostingDate := PostingDateFrom;
        DocumentNo[1] := DocumentNoFrom;
        PostingDescription[1] := PostingDescriptionFrom;
        BalAccount := BalAccountFrom;
    end;

    local procedure ActivateErrorMessageHandling(var FixedAsset: Record "Fixed Asset")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeActivateErrorMessageHandling(FixedAsset, ErrorMessageMgt, ErrorMessageHandler, ErrorContextElement, IsHandled);
        if IsHandled then
            exit;

        if GuiAllowed then
            ErrorMessageMgt.Activate(ErrorMessageHandler);
    end;

    [Scope('OnPrem')]
    procedure TestDocumentNo()
    begin
        UseAutomaticDocumentNo :=
          (DocumentNo[1] = '') and (DocumentNo[2] = '') and (DocumentNo[3] = '');
        if UseAutomaticDocumentNo then
            exit;
        if DocumentNo[1] = '' then begin
            FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::Depreciation;
            Error(
              Text1130000, FAJnlLine.FieldCaption("Document No."),
              FAJnlLine.FieldCaption("FA Posting Type"), FAJnlLine."FA Posting Type");
        end;
        if UseCustom1 and (DocumentNo[2] = '') then begin
            FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::"Custom 1";
            Error(
              Text1130000, FAJnlLine.FieldCaption("Document No."),
              FAJnlLine.FieldCaption("FA Posting Type"), FAJnlLine."FA Posting Type");
        end;

        if UseCustom2 and (DocumentNo[3] = '') then begin
            FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::"Custom 2";
            Error(
              Text1130000, FAJnlLine.FieldCaption("Document No."),
              FAJnlLine.FieldCaption("FA Posting Type"), FAJnlLine."FA Posting Type");
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateDepreciation(FANo: Code[20]; var TempGenJournalLine: Record "Gen. Journal Line" temporary; var TempFAJournalLine: Record "FA Journal Line" temporary; var DeprAmount: Decimal; var NumberOfDays: Integer; DeprBookCode: Code[10]; DeprUntilDate: Date; EntryAmounts: array[4] of Decimal; DaysInPeriod: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFAInsertGLAccGetBalAcc(var GenJnlLine: Record "Gen. Journal Line"; var GenJnlNextLineNo: Integer; var BalAccount: Boolean; var TempGenJnlLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostDataItem()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnPostReport()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeActivateErrorMessageHandling(varFixedAsset: Record "Fixed Asset"; var ErrorMessageMgt: Codeunit "Error Message Management"; var ErrorMessageHandler: Codeunit "Error Message Handler"; var ErrorContextElement: Codeunit "Error Context Element"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateDepreciation(FANo: Code[20]; var TempGenJournalLine: Record "Gen. Journal Line" temporary; var TempFAJournalLine: Record "FA Journal Line" temporary; var DeprAmount: Decimal; var NumberOfDays: Integer; DeprBookCode: Code[10]; DeprUntilDate: Date; EntryAmounts: array[4] of Decimal; DaysInPeriod: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFAJnlLineInsert(var TempFAJournalLine: Record "FA Journal Line" temporary; var FAJournalLine: Record "FA Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGenJnlLineInsert(var TempGenJournalLine: Record "Gen. Journal Line" temporary; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInitReport(var DeprBookCode: Code[10])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostReportOnBeforeConfirmShowFAJournalLines(DeprBook: Record "Depreciation Book"; FAJnlLine: Record "FA Journal Line"; FAJnlLineCreatedCount: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostReportOnBeforeConfirmShowGenJournalLines(DeprBook: Record "Depreciation Book"; GenJnlLine: Record "Gen. Journal Line"; GenJnlLineCreatedCount: Integer; var IsHandled: Boolean)
    begin
    end;
}

