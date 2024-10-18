page 17208 "Tax Register Term Lines"
{
    AutoSplitKey = true;
    Caption = 'Tax Register Term Lines';
    PageType = List;
    SourceTable = "Tax Register Term Formula";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Operation; Rec.Operation)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = OperationEditable;
                    ToolTip = 'Specifies the operation associated with the tax register term line.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = AccountTypeEditable;
                    ToolTip = 'Specifies the purpose of the account.';

                    trigger OnValidate()
                    begin
                        AccountTypeOnAfterValidate();
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the account number associated with the tax register term line.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        case Rec."Account Type" of
                            Rec."Account Type"::"G/L Account", Rec."Account Type"::"Net Change":
                                begin
                                    GLAcc.Reset();
                                    if Rec."Bal. Account No." <> '' then
                                        if StrPos('|&<>', CopyStr(Rec."Account No.", StrLen(Rec."Account No."))) = 0 then begin
                                            GLAcc.SetFilter("No.", Rec."Account No.");
                                            if GLAcc.FindFirst() then;
                                            GLAcc.SetRange("No.");
                                        end;
                                    if ACTION::LookupOK = PAGE.RunModal(0, GLAcc) then begin
                                        Text := GLAcc."No.";
                                        exit(true);
                                    end;
                                end;
                            Rec."Account Type"::Term:
                                begin
                                    TaxRegTermName.Reset();
                                    if Rec."Account No." <> '' then begin
                                        TaxRegTermName.SetFilter("Term Code", Rec."Account No.");
                                        if TaxRegTermName.FindFirst() then;
                                        TaxRegTermName.SetRange("Term Code");
                                    end;
                                    if ACTION::LookupOK = PAGE.RunModal(0, TaxRegTermName) then begin
                                        Rec."Account No." := '';
                                        Text := TaxRegTermName."Term Code";
                                        exit(true);
                                    end;
                                end;
                            Rec."Account Type"::Norm:
                                begin
                                    Rec.CalcFields("Norm Jurisdiction Code");
                                    if Rec."Norm Jurisdiction Code" <> '' then begin
                                        TaxRegNormGroup.Reset();
                                        TaxRegNormGroup.FilterGroup(2);
                                        TaxRegNormGroup.SetRange("Norm Jurisdiction Code", Rec."Norm Jurisdiction Code");
                                        TaxRegNormGroup.FilterGroup(0);
                                        TaxRegNormGroup.SetRange("Has Details", true);
                                        if TaxRegNormGroup.Get(Rec."Norm Jurisdiction Code", CopyStr(Rec."Account No.", 1, MaxStrLen(TaxRegNormGroup.Code))) then;
                                        if ACTION::LookupOK = PAGE.RunModal(0, TaxRegNormGroup) then begin
                                            Rec."Account No." := '';
                                            Text := TaxRegNormGroup.Code;
                                            exit(true);
                                        end;
                                    end;
                                end;
                        end;
                        exit(false);
                    end;

                    trigger OnValidate()
                    begin
                        AccountNoOnAfterValidate();
                    end;
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = BalAccountNoEditable;
                    ToolTip = 'Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry will posted, such as a cash account for cash purchases.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if Rec."Account Type" = Rec."Account Type"::"Net Change" then begin
                            GLAcc.Reset();
                            if Rec."Bal. Account No." <> '' then
                                if StrPos('|&<>', CopyStr(Rec."Bal. Account No.", StrLen(Rec."Bal. Account No."))) = 0 then begin
                                    GLAcc.SetFilter("No.", Rec."Bal. Account No.");
                                    if GLAcc.FindFirst() then;
                                    GLAcc.SetRange("No.");
                                end;
                            if ACTION::LookupOK = PAGE.RunModal(0, GLAcc) then begin
                                Text := GLAcc."No.";
                                exit(true);
                            end;
                        end;
                        Rec.CalcFields("Expression Type");
                        if Rec."Expression Type" = Rec."Expression Type"::Compare then begin
                            TaxRegTermName.Reset();
                            if Rec."Bal. Account No." <> '' then begin
                                TaxRegTermName.SetFilter("Term Code", Rec."Bal. Account No.");
                                if TaxRegTermName.FindFirst() then;
                                TaxRegTermName.SetRange("Term Code");
                            end;
                            if ACTION::LookupOK = PAGE.RunModal(0, TaxRegTermName) then begin
                                Rec."Bal. Account No." := '';
                                Text := TaxRegTermName."Term Code";
                                exit(true);
                            end;
                        end;
                        exit(false);
                    end;
                }
                field("Amount Type"; Rec."Amount Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = AmountTypeEditable;
                    ToolTip = 'Specifies the amount type associated with the tax register term line.';
                }
                field("Process Sign"; Rec."Process Sign")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the process sign. Norm jurisdictions are based on Russian tax laws that define a variety of tax rates. They are used to calculate taxable profits and losses in tax accounting. Process signs include Skip Negative, Skip Positive, Always Positive, Always Negative.';
                }
                field("Process Division by Zero"; Rec."Process Division by Zero")
                {
                    ToolTip = 'Specifies the process division by zero associated with the tax register term line.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEnable();
    end;

    trigger OnAfterGetRecord()
    begin
        SetEnable();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.CalcFields("Expression Type");
        if Rec."Expression Type" = Rec."Expression Type"::Compare then begin
            if not Confirm(Text001, false) then
                exit(false);
            Rec.DeleteAll();
            CurrPage.Close();
        end;
        exit(true);
    end;

    trigger OnInit()
    begin
        AmountTypeEditable := true;
        AccountTypeEditable := true;
        OperationEditable := true;
        BalAccountNoEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.CalcFields("Expression Type");
        case Rec."Expression Type" of
            Rec."Expression Type"::"Plus/Minus":
                Rec.Operation := Rec.Operation::"+";
            Rec."Expression Type"::"Multiply/Divide":
                Rec.Operation := Rec.Operation::"*";
            else begin
                if not (Rec.Count() = 3) then
                    CurrPage.Close();
                Rec.Operation := Rec.Operation::Negative;
                Rec."Account Type" := Rec."Account Type"::Term;
            end;
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.CalcFields("Expression Type");
        if not (Rec."Expression Type" = Rec."Expression Type"::Compare) then
            exit(true);
        if not (Rec.Count() = 3) then
            exit(true);
        ExternReportFormula1.Copy(Rec);
        ExternReportFormula1.Find('-');
        if ExternReportFormula1."Account No." = '' then begin
            Rec := ExternReportFormula1;
            CurrPage.Update(false);
            ExternReportFormula1.TestField("Account No.");
        end;
        repeat
            if ExternReportFormula1."Bal. Account No." = '' then begin
                Rec := ExternReportFormula1;
                CurrPage.Update(false);
                ExternReportFormula1.TestField("Bal. Account No.");
            end;
        until ExternReportFormula1.Next() = 0;
    end;

    var
#pragma warning disable AA0074
        Text001: Label 'Delete all lines?';
#pragma warning restore AA0074
        GLAcc: Record "G/L Account";
        ExternReportFormula1: Record "Tax Register Term Formula";
        TaxRegTermName: Record "Tax Register Term";
        TaxRegNormGroup: Record "Tax Register Norm Group";
        BalAccountNoEditable: Boolean;
        OperationEditable: Boolean;
        AccountTypeEditable: Boolean;
        AmountTypeEditable: Boolean;

    local procedure SetEnable()
    begin
        Rec.CalcFields("Expression Type");
        if Rec."Expression Type" = Rec."Expression Type"::Compare then begin
            BalAccountNoEditable := true;
            OperationEditable := false;
            AccountTypeEditable := false;
        end else
            BalAccountNoEditable := Rec."Account Type" = Rec."Account Type"::"Net Change";

        AmountTypeEditable := Rec."Account Type" in [Rec."Account Type"::"G/L Account", Rec."Account Type"::"Net Change"];
    end;

    local procedure AccountTypeOnAfterValidate()
    begin
        SetEnable();
    end;

    local procedure AccountNoOnAfterValidate()
    begin
        SetEnable();
        CurrPage.Update(true);
    end;
}

