table 31002 "Sales Advance Letter Entry"
{
    Caption = 'Sales Advance Letter Entry';
    DrillDownPageID = "Sales Advance Letter Entries";
    LookupPageID = "Sales Advance Letter Entries";
    Permissions =;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Template Name"; Code[10])
        {
            Caption = 'Template Name';
            NotBlank = true;
            TableRelation = "Sales Adv. Payment Template";
        }
        field(11; "Letter No."; Code[20])
        {
            Caption = 'Letter No.';
            TableRelation = "Sales Advance Letter Header";
        }
        field(12; "Letter Line No."; Integer)
        {
            Caption = 'Letter Line No.';
            TableRelation = "Sales Advance Letter Line"."Line No." WHERE("Letter No." = FIELD("Letter No."));
        }
        field(13; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = ' ,VAT,VAT Deduction,VAT Rate,,,,,,,Deduction';
            OptionMembers = " ",VAT,"VAT Deduction","VAT Rate",,,,,,,Deduction;
        }
        field(14; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(15; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(16; "Sale Line No."; Integer)
        {
            Caption = 'Sale Line No.';
            TableRelation = "Sales Invoice Line"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(17; "Deduction Line No."; Integer)
        {
            Caption = 'Deduction Line No.';
            TableRelation = "Sales Invoice Line"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(18; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(19; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(20; "Customer Entry No."; Integer)
        {
            Caption = 'Customer Entry No.';
            TableRelation = "Cust. Ledger Entry"."Entry No." WHERE(Prepayment = CONST(true));
        }
        field(21; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(22; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(50; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(53; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(60; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(65; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(70; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
        }
        field(75; "VAT Identifier"; Code[20])
        {
            Caption = 'VAT Identifier';
        }
        field(77; "VAT Calculation Type"; Enum "Tax Calculation Type")
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
        }
        field(80; "VAT Base Amount (LCY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount (LCY)';
        }
        field(85; "VAT Amount (LCY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Amount (LCY)';
        }
        field(95; "VAT Entry No."; Integer)
        {
            Caption = 'VAT Entry No.';
            TableRelation = "VAT Entry";
        }
        field(100; "VAT Base Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
        }
        field(101; "VAT Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Amount';
        }
        field(105; "VAT Date"; Date)
        {
            Caption = 'VAT Date';
        }
        field(106; Cancelled; Boolean)
        {
            Caption = 'Cancelled';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Letter No.", "Letter Line No.", "Entry Type", "Posting Date", "Customer Entry No.")
        {
            SumIndexFields = Amount, "VAT Amount (LCY)", "VAT Base Amount (LCY)", "VAT Base Amount", "VAT Amount";
        }
        key(Key3; "Document No.", "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }

    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
    end;
}

