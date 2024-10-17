table 124 "Purch. Cr. Memo Hdr."
{
    Caption = 'Purch. Cr. Memo Hdr.';
    DataCaptionFields = "No.", "Buy-from Vendor Name";
    DrillDownPageID = "Posted Purchase Credit Memos";
    LookupPageID = "Posted Purchase Credit Memos";

    fields
    {
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(5; "Pay-to Name"; Text[100])
        {
            Caption = 'Pay-to Name';
        }
        field(6; "Pay-to Name 2"; Text[50])
        {
            Caption = 'Pay-to Name 2';
        }
        field(7; "Pay-to Address"; Text[100])
        {
            Caption = 'Pay-to Address';
        }
        field(8; "Pay-to Address 2"; Text[50])
        {
            Caption = 'Pay-to Address 2';
        }
        field(9; "Pay-to City"; Text[30])
        {
            Caption = 'Pay-to City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10; "Pay-to Contact"; Text[100])
        {
            Caption = 'Pay-to Contact';
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
        field(21; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
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
        field(31; "Vendor Posting Group"; Code[20])
        {
            Caption = 'Vendor Posting Group';
            Editable = false;
            TableRelation = "Vendor Posting Group";
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
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(43; "Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist ("Purch. Comment Line" WHERE("Document Type" = CONST("Posted Credit Memo"),
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
        field(52; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,,,,,,,,,,,,,,,Bill';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund,,,,,,,,,,,,,,,Bill;
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup()
            begin
                VendLedgEntry.SetCurrentKey("Document No.");
                VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
                VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                VendLedgEntry.SetRange("Bill No.", "Applies-to Bill No.");
                PAGE.Run(0, VendLedgEntry);
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
            CalcFormula = Sum ("Purch. Cr. Memo Line".Amount WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum ("Purch. Cr. Memo Line"."Amount Including VAT" WHERE("Document No." = FIELD("No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(69; "Vendor Cr. Memo No."; Code[35])
        {
            Caption = 'Vendor Cr. Memo No.';
        }
        field(70; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(72; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
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
        field(79; "Buy-from Vendor Name"; Text[100])
        {
            Caption = 'Buy-from Vendor Name';
        }
        field(80; "Buy-from Vendor Name 2"; Text[50])
        {
            Caption = 'Buy-from Vendor Name 2';
        }
        field(81; "Buy-from Address"; Text[100])
        {
            Caption = 'Buy-from Address';
        }
        field(82; "Buy-from Address 2"; Text[50])
        {
            Caption = 'Buy-from Address 2';
        }
        field(83; "Buy-from City"; Text[30])
        {
            Caption = 'Buy-from City';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(84; "Buy-from Contact"; Text[100])
        {
            Caption = 'Buy-from Contact';
        }
        field(85; "Pay-to Post Code"; Code[20])
        {
            Caption = 'Pay-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(86; "Pay-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "Pay-to Country/Region Code";
            Caption = 'Pay-to County';
        }
        field(87; "Pay-to Country/Region Code"; Code[10])
        {
            Caption = 'Pay-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(88; "Buy-from Post Code"; Code[20])
        {
            Caption = 'Buy-from Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(89; "Buy-from County"; Text[30])
        {
            CaptionClass = '5,1,' + "Buy-from Country/Region Code";
            Caption = 'Buy-from County';
        }
        field(90; "Buy-from Country/Region Code"; Code[10])
        {
            Caption = 'Buy-from Country/Region Code';
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
        field(94; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(95; "Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
        }
        field(97; "Entry Point"; Code[10])
        {
            Caption = 'Entry Point';
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
        field(138; "Prepmt. Cr. Memo No. Series"; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";
        }
        field(140; "Prepayment Credit Memo"; Boolean)
        {
            Caption = 'Prepayment Credit Memo';
        }
        field(141; "Prepayment Order No."; Code[20])
        {
            Caption = 'Prepayment Order No.';
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
        field(1302; Paid; Boolean)
        {
            CalcFormula = - Exist ("Vendor Ledger Entry" WHERE("Entry No." = FIELD("Vendor Ledger Entry No."),
                                                              Open = FILTER(true)));
            Caption = 'Paid';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1303; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum ("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor Ledger Entry No." = FIELD("Vendor Ledger Entry No.")));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1304; "Vendor Ledger Entry No."; Integer)
        {
            Caption = 'Vendor Ledger Entry No.';
            Editable = false;
            TableRelation = "Vendor Ledger Entry"."Entry No.";
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(1305; "Invoice Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum ("Purch. Cr. Memo Line"."Inv. Discount Amount" WHERE("Document No." = FIELD("No.")));
            Caption = 'Invoice Discount Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1310; Cancelled; Boolean)
        {
            CalcFormula = Exist ("Cancelled Document" WHERE("Source ID" = CONST(124),
                                                            "Cancelled Doc. No." = FIELD("No.")));
            Caption = 'Cancelled';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1311; Corrective; Boolean)
        {
            CalcFormula = Exist ("Cancelled Document" WHERE("Source ID" = CONST(122),
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
        field(5052; "Buy-from Contact No."; Code[20])
        {
            Caption = 'Buy-from Contact No.';
            TableRelation = Contact;
        }
        field(5053; "Pay-to Contact No."; Code[20])
        {
            Caption = 'Pay-to Contact No.';
            TableRelation = Contact;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(6601; "Return Order No."; Code[20])
        {
            AccessByPermission = TableData "Return Shipment Header" = R;
            Caption = 'Return Order No.';
        }
        field(6602; "Return Order No. Series"; Code[20])
        {
            Caption = 'Return Order No. Series';
            TableRelation = "No. Series";
        }
        field(10700; "Autocredit Memo No."; Code[20])
        {
            Caption = 'Autocredit Memo No.';
            Editable = false;
        }
        field(10705; "Corrected Invoice No."; Code[20])
        {
            Caption = 'Corrected Invoice No.';
            TableRelation = "Purch. Inv. Header";

            trigger OnLookup()
            var
                PurchaseInvoiceHeader: Record "Purch. Inv. Header";
                PostedPurchaseInvoices: Page "Posted Purchase Invoices";
            begin
                PurchaseInvoiceHeader.SetCurrentKey("No.");
                PurchaseInvoiceHeader.SetRange("Pay-to Vendor No.", "Pay-to Vendor No.");
                PurchaseInvoiceHeader.SetRange("No.", "Corrected Invoice No.");

                PostedPurchaseInvoices.SetTableView(PurchaseInvoiceHeader);
                PostedPurchaseInvoices.SetRecord(PurchaseInvoiceHeader);
                PostedPurchaseInvoices.LookupMode(true);
                if PostedPurchaseInvoices.RunModal = ACTION::LookupOK then
                    PostedPurchaseInvoices.GetRecord(PurchaseInvoiceHeader);
                Clear(PostedPurchaseInvoices);
            end;
        }
        field(10706; "SII Status"; Option)
        {
            CalcFormula = Lookup ("SII Doc. Upload State".Status WHERE("Document Source" = CONST("Vendor Ledger"),
                                                                       "Document Type" = CONST("Credit Memo"),
                                                                       "Document No." = FIELD("No.")));
            Caption = 'SII Status';
            FieldClass = FlowField;
            OptionCaption = 'Pending,Incorrect,Accepted,Accepted With Errors,Communication Error,Failed,Not Supported';
            OptionMembers = Pending,Incorrect,Accepted,"Accepted With Errors","Communication Error",Failed,"Not Supported";

            trigger OnLookup()
            var
                SIIDocUploadState: Record "SII Doc. Upload State";
                SIIHistory: Record "SII History";
            begin
                SIIDocUploadState.SetRange("Document Source", SIIDocUploadState."Document Source"::"Vendor Ledger");
                SIIDocUploadState.SetRange("Document Type", SIIDocUploadState."Document Type"::"Credit Memo");
                SIIDocUploadState.SetRange("Document No.", "No.");
                if SIIDocUploadState.FindFirst then begin
                    SIIHistory.SetRange("Document State Id", SIIDocUploadState.Id);
                    PAGE.Run(PAGE::"SII History", SIIHistory);
                end;
            end;
        }
        field(10707; "Invoice Type"; Option)
        {
            Caption = 'Invoice Type';
            OptionCaption = 'F1 Invoice,F2 Simplified Invoice,F3 Invoice issued to replace simplified invoices,F4 Invoice summary entry,F5 Imports (DUA),F6 Accounting support material';
            OptionMembers = "F1 Invoice","F2 Simplified Invoice","F3 Invoice issued to replace simplified invoices","F4 Invoice summary entry","F5 Imports (DUA)","F6 Accounting support material";
        }
        field(10708; "Cr. Memo Type"; Option)
        {
            Caption = 'Cr. Memo Type';
            OptionCaption = 'R1 Corrected Invoice,R2 Corrected Invoice (Art. 80.3),R3 Corrected Invoice (Art. 80.4),R4 Corrected Invoice (Other),R5 Corrected Invoice in Simplified Invoices,F1 Invoice,F2 Simplified Invoice';
            OptionMembers = "R1 Corrected Invoice","R2 Corrected Invoice (Art. 80.3)","R3 Corrected Invoice (Art. 80.4)","R4 Corrected Invoice (Other)","R5 Corrected Invoice in Simplified Invoices","F1 Invoice","F2 Simplified Invoice";
        }
        field(10709; "Special Scheme Code"; Option)
        {
            Caption = 'Special Scheme Code';
            OptionCaption = '01 General,02 Special System Activities,03 Special System,04 Gold,05 Travel Agencies,06 Groups of Entities,07 Special Cash,08  IPSI / IGIC,09 Intra-Community Acquisition,12 Business Premises Leasing Operations,13 Import (Without DUA),14 First Half 2017';
            OptionMembers = "01 General","02 Special System Activities","03 Special System","04 Gold","05 Travel Agencies","06 Groups of Entities","07 Special Cash","08  IPSI / IGIC","09 Intra-Community Acquisition","12 Business Premises Leasing Operations","13 Import (Without DUA)","14 First Half 2017";
        }
        field(10710; "Operation Description"; Text[250])
        {
            Caption = 'Operation Description';
        }
        field(10711; "Correction Type"; Option)
        {
            Caption = 'Correction Type';
            OptionCaption = ' ,Replacement,Difference,Removal';
            OptionMembers = " ",Replacement,Difference,Removal;
        }
        field(10712; "Operation Description 2"; Text[250])
        {
            Caption = 'Operation Description 2';
        }
        field(10720; "Succeeded Company Name"; Text[250])
        {
            Caption = 'Succeeded Company Name';
        }
        field(10721; "Succeeded VAT Registration No."; Text[20])
        {
            Caption = 'Succeeded VAT Registration No.';
        }
        field(10722; "ID Type"; Option)
        {
            Caption = 'ID Type';
            OptionCaption = ' ,02-VAT Registration No.,03-Passport,04-ID Document,05-Certificate Of Residence,06-Other Probative Document,07-Not On The Census';
            OptionMembers = " ","02-VAT Registration No.","03-Passport","04-ID Document","05-Certificate Of Residence","06-Other Probative Document","07-Not On The Census";
        }
        field(7000000; "Applies-to Bill No."; Code[20])
        {
            Caption = 'Applies-to Bill No.';
        }
        field(7000001; "Vendor Bank Acc. Code"; Code[20])
        {
            Caption = 'Vendor Bank Acc. Code';
            TableRelation = "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("Pay-to Vendor No."));
        }
        field(7000003; "Pay-at Code"; Code[10])
        {
            Caption = 'Pay-at Code';
            TableRelation = "Vendor Pmt. Address".Code WHERE("Vendor No." = FIELD("Pay-to Vendor No."));
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
        key(Key3; "Vendor Cr. Memo No.", "Posting Date")
        {
        }
        key(Key4; "Return Order No.")
        {
        }
        key(Key5; "Buy-from Vendor No.")
        {
        }
        key(Key6; "Prepayment Order No.")
        {
        }
        key(Key7; "Pay-to Vendor No.")
        {
        }
        key(Key8; "Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Buy-from Vendor No.", "Pay-to Vendor No.", "Posting Date", "Posting Description")
        {
        }
    }

    trigger OnDelete()
    var
        PostedDeferralHeader: Record "Posted Deferral Header";
        PostPurchDelete: Codeunit "PostPurch-Delete";
        DeferralUtilities: Codeunit "Deferral Utilities";
    begin
        PostPurchDelete.IsDocumentDeletionAllowed("Posting Date");
        LockTable;
        PostPurchDelete.DeletePurchCrMemoLines(Rec);

        PurchCommentLine.SetRange("Document Type", PurchCommentLine."Document Type"::"Posted Credit Memo");
        PurchCommentLine.SetRange("No.", "No.");
        PurchCommentLine.DeleteAll;

        ApprovalsMgmt.DeletePostedApprovalEntries(RecordId);
        PostedDeferralHeader.DeleteForDoc(DeferralUtilities.GetPurchDeferralDocType, '', '',
          PurchCommentLine."Document Type"::"Posted Credit Memo", "No.");
    end;

    var
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCommentLine: Record "Purch. Comment Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        UserSetupMgt: Codeunit "User Setup Management";

    [Scope('OnPrem')]
    procedure PrintRecordsAutoCrMemo(ShowRequestForm: Boolean)
    var
        ReportSelection: Record "Report Selections";
    begin
        with PurchCrMemoHeader do begin
            Copy(Rec);
            ReportSelection.SetRange(Usage, ReportSelection.Usage::"P.AutoCr.Memo");
            ReportSelection.SetFilter("Report ID", '<>0');
            ReportSelection.Find('-');
            repeat
                REPORT.RunModal(ReportSelection."Report ID", ShowRequestForm, false, PurchCrMemoHeader);
            until ReportSelection.Next = 0;
        end;
    end;

    procedure PrintRecords(ShowRequestPage: Boolean)
    var
        ReportSelection: Record "Report Selections";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforePrintRecords(Rec, ShowRequestPage, IsHandled);
        if not IsHandled then
            with PurchCrMemoHeader do begin
                Copy(Rec);
                ReportSelection.PrintWithGUIYesNoVendor(
                  ReportSelection.Usage::"P.Cr.Memo", PurchCrMemoHeader, ShowRequestPage, FieldNo("Buy-from Vendor No."));
            end;
    end;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.Run;
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
    end;

    procedure SetSecurityFilterOnRespCenter()
    begin
        if UserSetupMgt.GetPurchasesFilter <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Center", UserSetupMgt.GetPurchasesFilter);
            FilterGroup(0);
        end;
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
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        CalcFields(Cancelled);
        if not Cancelled then
            exit;

        if CancelledDocument.FindPurchCancelledCrMemo("No.") then begin
            PurchInvHeader.Get(CancelledDocument."Cancelled By Doc. No.");
            PAGE.Run(PAGE::"Posted Purchase Invoice", PurchInvHeader);
        end;
    end;

    procedure ShowCancelledInvoice()
    var
        CancelledDocument: Record "Cancelled Document";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        CalcFields(Corrective);
        if not Corrective then
            exit;

        if CancelledDocument.FindPurchCorrectiveCrMemo("No.") then begin
            PurchInvHeader.Get(CancelledDocument."Cancelled Doc. No.");
            PAGE.Run(PAGE::"Posted Purchase Invoice", PurchInvHeader);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePrintRecords(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; ShowRequestPage: Boolean; var IsHandled: Boolean)
    begin
    end;
}

