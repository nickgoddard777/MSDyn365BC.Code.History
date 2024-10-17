table 31042 "FA Extended Posting Group"
{
    Caption = 'FA Extended Posting Group';
#if not CLEAN18
    LookupPageID = "FA Extended Posting Groups";
    ObsoleteState = Pending;
#else
    ObsoleteState = Removed;
#endif
    ObsoleteReason = 'Moved to Fixed Asset Localization for Czech.';
    ObsoleteTag = '18.0';

    fields
    {
        field(1; "FA Posting Group Code"; Code[20])
        {
            Caption = 'FA Posting Group Code';
            TableRelation = "FA Posting Group";
        }
        field(2; "FA Posting Type"; Option)
        {
            Caption = 'FA Posting Type';
            OptionCaption = ' ,Disposal,Maintenance';
            OptionMembers = " ",Disposal,Maintenance;
        }
        field(3; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = IF ("FA Posting Type" = CONST(Disposal)) "Reason Code"
            ELSE
            IF ("FA Posting Type" = CONST(Maintenance)) Maintenance;
        }
        field(4; "Book Val. Acc. on Disp. (Gain)"; Code[20])
        {
            Caption = 'Book Val. Acc. on Disp. (Gain)';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Book Val. Acc. on Disp. (Gain)", false);
            end;
        }
        field(5; "Book Val. Acc. on Disp. (Loss)"; Code[20])
        {
            Caption = 'Book Val. Acc. on Disp. (Loss)';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Book Val. Acc. on Disp. (Loss)", false);
            end;
        }
        field(6; "Maintenance Expense Account"; Code[20])
        {
            Caption = 'Maintenance Expense Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Maintenance Expense Account", false);
            end;
        }
        field(7; "Maintenance Bal. Acc."; Code[20])
        {
            Caption = 'Maintenance Bal. Acc.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Maintenance Bal. Acc.", true);
            end;
        }
#if not CLEAN18
        field(8; "Allocated Book Value % (Gain)"; Decimal)
        {
            CalcFormula = Sum("FA Allocation"."Allocation %" WHERE(Code = FIELD("FA Posting Group Code"),
                                                                    "Allocation Type" = CONST("Book Value (Gain)"),
                                                                    "Reason/Maintenance Code" = FIELD(Code)));
            Caption = 'Allocated Book Value % (Gain)';
            DecimalPlaces = 1 : 1;
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Allocated Book Value % (Loss)"; Decimal)
        {
            CalcFormula = Sum("FA Allocation"."Allocation %" WHERE(Code = FIELD("FA Posting Group Code"),
                                                                    "Allocation Type" = CONST("Book Value (Loss)"),
                                                                    "Reason/Maintenance Code" = FIELD(Code)));
            Caption = 'Allocated Book Value % (Loss)';
            DecimalPlaces = 1 : 1;
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Allocated Maintenance %"; Decimal)
        {
            CalcFormula = Sum("FA Allocation"."Allocation %" WHERE(Code = FIELD("FA Posting Group Code"),
                                                                    "Allocation Type" = CONST(Maintenance),
                                                                    "Reason/Maintenance Code" = FIELD(Code)));
            Caption = 'Allocated Maintenance %';
            DecimalPlaces = 1 : 1;
            Editable = false;
            FieldClass = FlowField;
        }
#endif
        field(31040; "Sales Acc. On Disp. (Gain)"; Code[20])
        {
            Caption = 'Sales Acc. On Disp. (Gain)';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Sales Acc. On Disp. (Gain)", false);
            end;
        }
        field(31042; "Sales Acc. On Disp. (Loss)"; Code[20])
        {
            Caption = 'Sales Acc. On Disp. (Loss)';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("Sales Acc. On Disp. (Loss)", false);
            end;
        }
    }

    keys
    {
        key(Key1; "FA Posting Group Code", "FA Posting Type", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('OnPrem')]
    procedure CheckGLAcc(AccNo: Code[20]; DirectPosting: Boolean)
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
            GLAcc.Get(AccNo);
            GLAcc.CheckGLAcc;
            if DirectPosting then
                GLAcc.TestField("Direct Posting");
        end;
    end;
}

