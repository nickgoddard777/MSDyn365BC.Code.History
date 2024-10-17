table 114 "Sales Cr.Memo Header"
{
    Caption = 'Sales Cr.Memo Header';
    DataCaptionFields = "No.", "Sell-to Customer Name";
    DrillDownPageID = "Posted Sales Credit Memos";
    LookupPageID = "Posted Sales Credit Memos";

    fields
    {
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(5; "Bill-to Name"; Text[100])
        {
            Caption = 'Bill-to Name';
        }
        field(6; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2';
        }
        field(7; "Bill-to Address"; Text[100])
        {
            Caption = 'Bill-to Address';
        }
        field(8; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
        }
        field(9; "Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10; "Bill-to Contact"; Text[100])
        {
            Caption = 'Bill-to Contact';
        }
        field(11; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
        }
        field(12; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(13; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(14; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(15; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(16; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(17; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(18; "Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(22; "Posting Description"; Text[100])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(26; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(31; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            Editable = false;
            TableRelation = "Customer Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
        }
        field(34; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(40; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(43; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist ("Sales Comment Line" WHERE("Document Type" = CONST("Posted Credit Memo"),
                                                            "No." = FIELD("No."),
                                                            "Document Line No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(51; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(52; "Applies-to Doc. Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-to Doc. Type';
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
            begin
                CustLedgEntry.SetCurrentKey("Document No.");
                CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                OnLookupAppliesToDocNoOnAfterSetFilters(CustLedgEntry, Rec);
                PAGE.Run(0, CustLedgEntry);
            end;
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum ("Sales Cr.Memo Line".Amount WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum ("Sales Cr.Memo Line"."Amount Including VAT" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(73; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(76; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(77; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            Caption = 'VAT Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(79; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(80; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
        }
        field(81; "Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address';
        }
        field(82; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
        }
        field(83; "Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(84; "Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact';
        }
        field(85; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(86; "Bill-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "Bill-to Country/Region Code";
            Caption = 'Bill-to County';
        }
        field(87; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(88; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(89; "Sell-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "Sell-to Country/Region Code";
            Caption = 'Sell-to County';
        }
        field(90; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(92; "Ship-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "Ship-to Country/Region Code";
            Caption = 'Ship-to County';
        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(94; "Bal. Account Type"; enum "Payment Balance Account Type")
        {
            Caption = 'Bal. Account Type';
        }
        field(97; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(101; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(104; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(107; "Pre-Assigned No. Series"; Code[20])
        {
            Caption = 'Pre-Assigned No. Series';
            TableRelation = "No. Series";
        }
        field(108; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(111; "Pre-Assigned No."; Code[20])
        {
            Caption = 'Pre-Assigned No.';
        }
        field(112; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(113; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(114; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(115; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(116; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(134; "Prepmt. Cr. Memo No. Series"; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";
        }
        field(136; "Prepayment Credit Memo"; Boolean)
        {
            Caption = 'Prepayment Credit Memo';
        }
        field(137; "Prepayment Order No."; Code[20])
        {
            Caption = 'Prepayment Order No.';
        }
        field(171; "Sell-to Phone No."; Text[30])
        {
            Caption = 'Sell-to Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(172; "Sell-to E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;
        }
        field(200; "Work Description"; BLOB)
        {
            Caption = 'Work Description';
            DataClassification = CustomerContent;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(710; "Document Exchange Identifier"; Text[50])
        {
            Caption = 'Document Exchange Identifier';
        }
        field(711; "Document Exchange Status"; Option)
        {
            Caption = 'Document Exchange Status';
            OptionCaption = 'Not Sent,Sent to Document Exchange Service,Delivered to Recipient,Delivery Failed,Pending Connection to Recipient';
            OptionMembers = "Not Sent","Sent to Document Exchange Service","Delivered to Recipient","Delivery Failed","Pending Connection to Recipient";
        }
        field(712; "Doc. Exch. Original Identifier"; Text[50])
        {
            Caption = 'Doc. Exch. Original Identifier';
        }
        field(1302; Paid; Boolean)
        {
            CalcFormula = - Exist ("Cust. Ledger Entry" WHERE("Entry No." = FIELD("Cust. Ledger Entry No."),
                                                             Open = FILTER(true)));
            Caption = 'Paid';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1303; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry".Amount WHERE("Cust. Ledger Entry No." = FIELD("Cust. Ledger Entry No.")));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1304; "Cust. Ledger Entry No."; Integer)
        {
            Caption = 'Cust. Ledger Entry No.';
            Editable = false;
            TableRelation = "Cust. Ledger Entry"."Entry No.";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(1305; "Invoice Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum ("Sales Cr.Memo Line"."Inv. Discount Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Invoice Discount Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1310; Cancelled; Boolean)
        {
            CalcFormula = Exist ("Cancelled Document" WHERE("Source ID" = CONST(114),
                                                            "Cancelled Doc. No." = FIELD("No.")));
            Caption = 'Cancelled';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1311; Corrective; Boolean)
        {
            CalcFormula = Exist ("Cancelled Document" WHERE("Source ID" = CONST(112),
                                                            "Cancelled By Doc. No." = FIELD("No.")));
            Caption = 'Corrective';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(5052; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;
        }
        field(5053; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;
        }
        field(5055; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            TableRelation = Opportunity;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(6601; "Return Order No."; Code[20])
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            Caption = 'Return Order No.';
        }
        field(6602; "Return Order No. Series"; Code[20])
        {
            Caption = 'Return Order No. Series';
            TableRelation = "No. Series";
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
        }
        field(7200; "Get Return Receipt Used"; Boolean)
        {
            Caption = 'Get Return Receipt Used';
        }
        field(8000; Id; Guid)
        {
            Caption = 'Id';
            ObsoleteState = Pending;
            ObsoleteReason = 'This functionality will be replaced by the systemID field';
            ObsoleteTag = '15.0';
        }
        field(8001; "Draft Cr. Memo SystemId"; Guid)
        {
            Caption = 'Draft Cr. Memo System Id';
            DataClassification = SystemMetadata;
        }
        field(11700; "Bank Account Code"; Code[20])
        {
            Caption = 'Bank Account Code';
            TableRelation = "Customer Bank Account".Code WHERE("Customer No." = FIELD("Bill-to Customer No."));
        }
        field(11701; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
        }
        field(11702; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
        }
        field(11703; "Specific Symbol"; Code[10])
        {
            Caption = 'Specific Symbol';
            CharAllowed = '09';
            Editable = false;
        }
        field(11704; "Variable Symbol"; Code[10])
        {
            Caption = 'Variable Symbol';
            CharAllowed = '09';
        }
        field(11705; "Constant Symbol"; Code[10])
        {
            Caption = 'Constant Symbol';
            CharAllowed = '09';
            TableRelation = "Constant Symbol";
        }
        field(11706; "Transit No."; Text[20])
        {
            Caption = 'Transit No.';
            Editable = false;
        }
        field(11707; IBAN; Code[50])
        {
            Caption = 'IBAN';

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
            begin
                // NAVCZ
                CompanyInfo.CheckIBAN(IBAN);
                // NAVCZ
            end;
        }
        field(11708; "SWIFT Code"; Code[20])
        {
            Caption = 'SWIFT Code';
        }
        field(11709; "Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
        }
        field(11730; "Cash Desk Code"; Code[20])
        {
            Caption = 'Cash Desk Code';
            TableRelation = "Bank Account" WHERE("Account Type" = CONST("Cash Desk"));

            trigger OnLookup()
            var
                BankAcc: Record "Bank Account";
            begin
                // NAVCZ
                if BankAcc.Get("Cash Desk Code") then;
                if PAGE.RunModal(PAGE::"Cash Desk List", BankAcc) = ACTION::LookupOK then;
                // NAVCZ
            end;
        }
        field(11731; "Cash Document Status"; Option)
        {
            Caption = 'Cash Document Status';
            OptionCaption = ' ,Create,Release,Post,Release and Print,Post and Print';
            OptionMembers = " ",Create,Release,Post,"Release and Print","Post and Print";
        }
        field(11760; "VAT Date"; Date)
        {
            Caption = 'VAT Date';

            trigger OnValidate()
            var
                VATEntry: Record "VAT Entry";
                GLEntry: Record "G/L Entry";
            begin
                if not Confirm(VATDateModifyQst, false) then begin
                    "VAT Date" := xRec."VAT Date";
                    exit;
                end;

                CheckVATDate;

                VATEntry.Reset();
                VATEntry.LockTable();
                VATEntry.SetCurrentKey("Document No.", "Posting Date");
                VATEntry.SetRange("Document Type", VATEntry."Document Type"::"Credit Memo");
                VATEntry.SetRange("Posting Date", "Posting Date");
                VATEntry.SetRange("Document No.", "No.");
                VATEntry.SetRange(Type, VATEntry.Type::Sale);
                if VATEntry.FindSet(true, false) then
                    repeat
                        if VATEntry.Closed then
                            Error(VATEntryClosedErr, VATEntry."VAT Date");
                        VATEntry."VAT Date" := "VAT Date";
                        VATEntry.Modify();
                    until VATEntry.Next = 0
                else begin
                    "VAT Date" := xRec."VAT Date";
                    Error(VATDateCannotBeChangedErr);
                end;

                GLEntry.SetCurrentKey("Document No.", "Posting Date");
                GLEntry.SetRange("Document Type", GLEntry."Document Type"::"Credit Memo");
                GLEntry.SetRange("Posting Date", "Posting Date");
                GLEntry.SetRange("Document No.", "No.");
                GLEntry.LockTable();
                if GLEntry.FindSet(true, false) then
                    repeat
                        GLEntry."VAT Date" := "VAT Date";
                        GLEntry.Modify();
                    until GLEntry.Next = 0;
            end;
        }
        field(11761; "VAT Currency Factor"; Decimal)
        {
            Caption = 'VAT Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(11763; "Postponed VAT"; Boolean)
        {
            Caption = 'Postponed VAT';
            Editable = false;
            ObsoleteState = Pending;
            ObsoleteReason = 'The functionality of Postponing VAT on Sales Cr.Memo will be removed and this field should not be used. (Obsolete::Removed in release 01.2021)';
            ObsoleteTag = '15.3';
        }
        field(11764; "Postponed VAT Realized"; Boolean)
        {
            Caption = 'Postponed VAT Realized';
            Editable = false;
            ObsoleteState = Pending;
            ObsoleteReason = 'The functionality of Postponing VAT on Sales Cr.Memo will be removed and this field should not be used. (Obsolete::Removed in release 01.2021)';
            ObsoleteTag = '15.3';
        }
        field(11766; "Credit Memo Type"; Option)
        {
            Caption = 'Credit Memo Type';
            OptionCaption = ',Corrective Tax Document,Internal Correction,Insolvency Tax Document';
            OptionMembers = ,"Corrective Tax Document","Internal Correction","Insolvency Tax Document";
        }
        field(11790; "Registration No."; Text[20])
        {
            Caption = 'Registration No.';
        }
        field(11791; "Tax Registration No."; Text[20])
        {
            Caption = 'Tax Registration No.';
        }
        field(11792; "Original User ID"; Code[50])
        {
            Caption = 'Original User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            ObsoleteState = Pending;
            ObsoleteReason = 'This field is not needed and it should not be used.';
            ObsoleteTag = '15.3';
        }
        field(11793; "Quote Validity"; Date)
        {
            Caption = 'Quote Validity';
            ObsoleteState = Pending;
            ObsoleteReason = 'The functionality of Quote Validity moved to W1 solution and this field should not be used. (Obsolete::Removed in release 01.2021)';
            ObsoleteTag = '15.3';
        }
        field(31000; "Prepayment Type"; Option)
        {
            Caption = 'Prepayment Type';
            OptionCaption = ' ,Prepayment,Advance';
            OptionMembers = " ",Prepayment,Advance;
        }
        field(31003; "Letter No."; Code[20])
        {
            Caption = 'Letter No.';
        }
        field(31060; "Perform. Country/Region Code"; Code[10])
        {
            Caption = 'Perform. Country/Region Code';
            TableRelation = "Registration Country/Region"."Country/Region Code" WHERE("Account Type" = CONST("Company Information"),
                                                                                       "Account No." = FILTER(''));
            ObsoleteState = Pending;
            ObsoleteReason = 'The functionality of VAT Registration in Other Countries will be removed and this field should not be used. (Obsolete::Removed in release 01.2021)';
            ObsoleteTag = '15.3';
        }
        field(31061; "Curr. Factor Perf. Country/Reg"; Decimal)
        {
            Caption = 'Curr. Factor Perf. Country/Reg';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
            ObsoleteState = Pending;
            ObsoleteReason = 'The functionality of VAT Registration in Other Countries will be removed and this field should not be used. (Obsolete::Removed in release 01.2021)';
            ObsoleteTag = '15.3';
        }
        field(31063; "Physical Transfer"; Boolean)
        {
            Caption = 'Physical Transfer';
        }
        field(31064; "Intrastat Exclude"; Boolean)
        {
            Caption = 'Intrastat Exclude';
        }
        field(31065; "Industry Code"; Code[20])
        {
            Caption = 'Industry Code';
            TableRelation = "Industry Code";
            ObsoleteState = Pending;
            ObsoleteReason = 'The functionality of Industry Classification will be removed and this field should not be used. (Obsolete::Removed in release 01.2021)';
            ObsoleteTag = '15.3';
        }
        field(31066; "EU 3-Party Intermediate Role"; Boolean)
        {
            Caption = 'EU 3-Party Intermediate Role';
        }
        field(31100; "Original Document VAT Date"; Date)
        {
            Caption = 'Original Document VAT Date';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Pre-Assigned No.")
        {
        }
        key(Key3; "Return Order No.")
        {
        }
        key(Key4; "Sell-to Customer No.")
        {
        }
        key(Key5; "Prepayment Order No.")
        {
        }
        key(Key6; "Bill-to Customer No.")
        {
        }
        key(Key7; "Letter No.")
        {
        }
        key(Key8; "Posting Date")
        {
        }
        key(Key9; "Document Exchange Status")
        {
        }
        key(Key10; "Salesperson Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Sell-to Customer No.", "Bill-to Customer No.", "Posting Date", "Posting Description")
        {
        }
        fieldgroup(Brick; "No.", "Sell-to Customer Name", Amount, "Due Date", "Amount Including VAT")
        {
        }
    }

    trigger OnDelete()
    var
        PostedDeferralHeader: Record "Posted Deferral Header";
        PostSalesDelete: Codeunit "PostSales-Delete";
        DeferralUtilities: Codeunit "Deferral Utilities";
    begin
        PostSalesDelete.IsDocumentDeletionAllowed("Posting Date");
        TestField("No. Printed");
        LockTable();
        PostSalesDelete.DeleteSalesCrMemoLines(Rec);

        SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::"Posted Credit Memo");
        SalesCommentLine.SetRange("No.", "No.");
        SalesCommentLine.DeleteAll();

        ApprovalsMgmt.DeletePostedApprovalEntries(RecordId);
        PostedDeferralHeader.DeleteForDoc(DeferralUtilities.GetSalesDeferralDocType, '', '',
          SalesCommentLine."Document Type"::"Posted Credit Memo", "No.");
    end;

    var
        SalesCommentLine: Record "Sales Comment Line";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        DimMgt: Codeunit DimensionManagement;
        UserSetupMgt: Codeunit "User Setup Management";
        VATDateModifyQst: Label 'Do you really want to modify VAT Date?';
        VATEntryClosedErr: Label 'VAT Entry is already closed and the date cannot be modified. VAT Date = %1.', Comment = '%1 = vat date';
        VATDateCannotBeChangedErr: Label 'Selected document is not Credit Memo. Field VAT Date cannot be changed.';
        VATDateRangeErr: Label 'VAT Date %1 is not within your range of allowed VAT dates.\Correct the date or change VAT posting period.', Comment = '%1 = vat date';
        DocTxt: Label 'Credit Memo';

    procedure SendRecords()
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        DummyReportSelections: Record "Report Selections";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSendRecords(DummyReportSelections, Rec, DocTxt, IsHandled);
        if IsHandled then
            exit;

        DocumentSendingProfile.SendCustomerRecords(
          DummyReportSelections.Usage::"S.Cr.Memo", Rec, DocTxt, "Bill-to Customer No.", "No.",
          FieldNo("Bill-to Customer No."), FieldNo("No."));
    end;

    procedure SendProfile(var DocumentSendingProfile: Record "Document Sending Profile")
    var
        DummyReportSelections: Record "Report Selections";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSendProfile(DummyReportSelections, Rec, DocTxt, IsHandled, DocumentSendingProfile);
        if IsHandled then
            exit;

        DocumentSendingProfile.Send(
          DummyReportSelections.Usage::"S.Cr.Memo", Rec, "No.", "Bill-to Customer No.",
          DocTxt, FieldNo("Bill-to Customer No."), FieldNo("No."));
    end;

    procedure PrintRecords(ShowRequestPage: Boolean)
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        DummyReportSelections: Record "Report Selections";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforePrintRecords(DummyReportSelections, Rec, ShowRequestPage, IsHandled);
        if IsHandled then
            exit;

        DocumentSendingProfile.TrySendToPrinter(
          DummyReportSelections.Usage::"S.Cr.Memo", Rec, FieldNo("Bill-to Customer No."), ShowRequestPage);
    end;

    procedure EmailRecords(ShowRequestPage: Boolean)
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        DummyReportSelections: Record "Report Selections";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeEmailRecords(DummyReportSelections, Rec, DocTxt, ShowRequestPage, IsHandled);
        if IsHandled then
            exit;

        DocumentSendingProfile.TrySendToEMail(
          DummyReportSelections.Usage::"S.Cr.Memo", Rec, FieldNo("No."), DocTxt, FieldNo("Bill-to Customer No."), ShowRequestPage);
    end;

    procedure PrintToDocumentAttachment(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        ShowNotificationAction: Boolean;
    begin
        ShowNotificationAction := SalesCrMemoHeader.Count() = 1;
        if SalesCrMemoHeader.FindSet() then
            repeat
                DoPrintToDocumentAttachment(SalesCrMemoHeader, ShowNotificationAction);
            until SalesCrMemoHeader.Next() = 0;
    end;

    local procedure DoPrintToDocumentAttachment(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; ShowNotificationAction: Boolean)
    var
        ReportSelections: Record "Report Selections";
    begin
        SalesCrMemoHeader.SetRecFilter();
        ReportSelections.SaveAsDocumentAttachment(ReportSelections.Usage::"S.Cr.Memo", SalesCrMemoHeader, SalesCrMemoHeader."No.", SalesCrMemoHeader."Bill-to Customer No.", ShowNotificationAction);
    end;

    procedure Navigate()
    var
        NavigatePage: Page Navigate;
    begin
        NavigatePage.SetDoc("Posting Date", "No.");
        NavigatePage.SetRec(Rec);
        NavigatePage.Run;
    end;

    procedure LookupAdjmtValueEntries()
    var
        ValueEntry: Record "Value Entry";
    begin
        ValueEntry.SetCurrentKey("Document No.");
        ValueEntry.SetRange("Document No.", "No.");
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Credit Memo");
        ValueEntry.SetRange(Adjustment, true);
        PAGE.RunModal(0, ValueEntry);
    end;

    procedure GetCustomerVATRegistrationNumber(): Text
    begin
        exit("VAT Registration No.");
    end;

    procedure GetCustomerVATRegistrationNumberLbl(): Text
    begin
        exit(FieldCaption("VAT Registration No."));
    end;

    procedure GetCustomerGlobalLocationNumber(): Text
    begin
        exit('');
    end;

    procedure GetCustomerGlobalLocationNumberLbl(): Text
    begin
        exit('');
    end;

    procedure GetLegalStatement(): Text
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        exit(SalesSetup.GetLegalStatement);
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
    end;

    procedure SetSecurityFilterOnRespCenter()
    begin
        if UserSetupMgt.GetSalesFilter <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Center", UserSetupMgt.GetSalesFilter);
            FilterGroup(0);
        end;
    end;

    [Scope('OnPrem')]
    [Obsolete('The functionality of Postponing VAT on Sales Cr.Memo will be removed and this function should not be used. (Obsolete::Removed in release 01.2021)','15.3')]
    procedure HandlePostponedVAT(VATDate: Date; Post: Boolean)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        // NAVCZ
        TestField("Postponed VAT", Post);
        TestField("Postponed VAT Realized", not Post);
        "VAT Date" := VATDate;
        CheckVATDate;

        if FindCustLedgEntry(CustLedgEntry) then begin
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
            GenJnlLine."Document No." := "No.";
            GenJnlLine."External Document No." := "External Document No.";
            GenJnlLine."Postponed VAT" := true;
            GenJnlLine."VAT Date" := VATDate;
            GenJnlLine.Description := CustLedgEntry.Description;
            GenJnlLine.Correction := Correction;
            GenJnlLine."Posting Date" := VATDate;
            GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := "Dimension Set ID";
            if Post then begin
                CustLedgEntry.CalcFields("Remaining Amt. (LCY)");
                GenJnlLine.Amount := CustLedgEntry."Remaining Amt. (LCY)";
                GenJnlPostLine.PostCustPostponedVAT(CustLedgEntry, GenJnlLine);
            end else  // Reverse
                GenJnlPostLine.ReverseCustPostponedVAT(GenJnlLine, CustLedgEntry."Transaction No.");

            "Postponed VAT" := not Post;
            "Postponed VAT Realized" := Post;
        end;
    end;

    [Scope('OnPrem')]
    procedure FindCustLedgEntry(var CustLedgEntry: Record "Cust. Ledger Entry"): Boolean
    begin
        // NAVCZ
        CustLedgEntry.Reset();
        CustLedgEntry.SetCurrentKey("Document No.");
        CustLedgEntry.SetRange("Document No.", "No.");
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::"Credit Memo");
        CustLedgEntry.SetRange("Posting Date", "Posting Date");
        exit(CustLedgEntry.FindFirst);
    end;

    [Scope('OnPrem')]
    procedure CheckVATDate()
    var
        GLSetup: Record "General Ledger Setup";
        GenJnLCheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin
        // NAVCZ
        GLSetup.Get();
        if GLSetup."Use VAT Date" then begin
            TestField("VAT Date");
            if GenJnLCheckLine.VATDateNotAllowed("VAT Date") then
                Error(VATDateRangeErr, "VAT Date");
            GenJnLCheckLine.VATPeriodCheck("VAT Date");
        end;
    end;

    procedure GetDocExchStatusStyle(): Text
    begin
        case "Document Exchange Status" of
            "Document Exchange Status"::"Not Sent":
                exit('Standard');
            "Document Exchange Status"::"Sent to Document Exchange Service":
                exit('Ambiguous');
            "Document Exchange Status"::"Delivered to Recipient":
                exit('Favorable');
            else
                exit('Unfavorable');
        end;
    end;

    procedure ShowActivityLog()
    var
        ActivityLog: Record "Activity Log";
    begin
        ActivityLog.ShowEntries(RecordId);
    end;

    procedure DocExchangeStatusIsSent(): Boolean
    begin
        exit("Document Exchange Status" <> "Document Exchange Status"::"Not Sent");
    end;

    procedure ShowCanceledOrCorrInvoice()
    begin
        CalcFields(Cancelled, Corrective);
        case true of
            Cancelled:
                ShowCorrectiveInvoice;
            Corrective:
                ShowCancelledInvoice;
        end;
    end;

    procedure ShowCorrectiveInvoice()
    var
        CancelledDocument: Record "Cancelled Document";
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        CalcFields(Cancelled);
        if not Cancelled then
            exit;

        if CancelledDocument.FindSalesCancelledCrMemo("No.") then begin
            SalesInvHeader.Get(CancelledDocument."Cancelled By Doc. No.");
            PAGE.Run(PAGE::"Posted Sales Invoice", SalesInvHeader);
        end;
    end;

    procedure ShowCancelledInvoice()
    var
        CancelledDocument: Record "Cancelled Document";
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        CalcFields(Corrective);
        if not Corrective then
            exit;

        if CancelledDocument.FindSalesCorrectiveCrMemo("No.") then begin
            SalesInvHeader.Get(CancelledDocument."Cancelled Doc. No.");
            PAGE.Run(PAGE::"Posted Sales Invoice", SalesInvHeader);
        end;
    end;

    procedure GetWorkDescription(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Work Description");
        "Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeEmailRecords(var ReportSelections: Record "Report Selections"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; DocTxt: Text; ShowDialog: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePrintRecords(var ReportSelections: Record "Report Selections"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; ShowRequestPage: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSendProfile(var ReportSelections: Record "Report Selections"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; DocTxt: Text; var IsHandled: Boolean; var DocumentSendingProfile: Record "Document Sending Profile")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSendRecords(var ReportSelections: Record "Report Selections"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; DocTxt: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLookupAppliesToDocNoOnAfterSetFilters(var CustLedgEntry: Record "Cust. Ledger Entry"; SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
    end;
}

