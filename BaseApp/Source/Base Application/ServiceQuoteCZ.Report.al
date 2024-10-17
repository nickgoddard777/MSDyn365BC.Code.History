#if not CLEAN17
report 31110 "Service Quote CZ"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ServiceQuoteCZ.rdlc';
    Caption = 'Service Quote CZ (Obsolete)';
    PreviewMode = PrintLayout;
    ObsoleteState = Pending;
    ObsoleteReason = 'Moved to Core Localization Pack for Czech.';
    ObsoleteTag = '17.0';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = SORTING("Primary Key");
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(CompanyAddr6; CompanyAddr[6])
            {
            }
            column(RegistrationNo_CompanyInformation; "Registration No.")
            {
            }
            column(VATRegistrationNo_CompanyInformation; "VAT Registration No.")
            {
            }
            column(HomePage_CompanyInformation; "Home Page")
            {
            }
            column(Picture_CompanyInformation; Picture)
            {
            }
            dataitem("Service Mgt. Setup"; "Service Mgt. Setup")
            {
                DataItemTableView = SORTING("Primary Key");
                column(LogoPositiononDocuments_ServiceMgtSetup; Format("Logo Position on Documents", 0, 2))
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.Company(CompanyAddr, "Company Information");
            end;
        }
        dataitem("Service Header"; "Service Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Quote));
            RequestFilterFields = "No.", "Customer No.";
            column(DocumentLbl; DocumentLbl)
            {
            }
            column(PageLbl; PageLbl)
            {
            }
            column(CopyLbl; CopyLbl)
            {
            }
            column(VendorLbl; VendLbl)
            {
            }
            column(CustomerLbl; CustLbl)
            {
            }
            column(ShipToLbl; ShipToLbl)
            {
            }
            column(PaymentTermsLbl; PaymentTermsLbl)
            {
            }
            column(PaymentMethodLbl; PaymentMethodLbl)
            {
            }
            column(ShipmentMethodLbl; ShipmentMethodLbl)
            {
            }
            column(SalespersonLbl; SalespersonLbl)
            {
            }
            column(PrintedByLbl; PrintedByLbl)
            {
            }
            column(No_ServiceHeader; "No.")
            {
            }
            column(VATRegistrationNo_ServiceHeaderCaption; FieldCaption("VAT Registration No."))
            {
            }
            column(VATRegistrationNo_ServiceHeader; "VAT Registration No.")
            {
            }
            column(RegistrationNo_ServiceHeaderCaption; FieldCaption("Registration No."))
            {
            }
            column(RegistrationNo_ServiceHeader; "Registration No.")
            {
            }
            column(BankAccountNo_ServiceHeaderCaption; FieldCaption("Bank Account No."))
            {
            }
            column(BankAccountNo_ServiceHeader; "Bank Account No.")
            {
            }
            column(IBAN_ServiceHeaderCaption; FieldCaption(IBAN))
            {
            }
            column(IBAN_ServiceHeader; IBAN)
            {
            }
            column(SWIFTCode_ServiceHeaderCaption; FieldCaption("SWIFT Code"))
            {
            }
            column(SWIFTCode_ServiceHeader; "SWIFT Code")
            {
            }
            column(OrderDate_ServiceHeaderCaption; FieldCaption("Order Date"))
            {
            }
            column(OrderDate_ServiceHeader; "Order Date")
            {
            }
            column(YourReference_ServiceHeaderCaption; FieldCaption("Your Reference"))
            {
            }
            column(YourReference_ServiceHeader; "Your Reference")
            {
            }
            column(PaymentTerms; PaymentTerms.Description)
            {
            }
            column(PaymentMethod; PaymentMethod.Description)
            {
            }
            column(ShipmentMethod; ShipmentMethod.Description)
            {
            }
            column(DocFooterText; DocFooterText)
            {
            }
            column(CustAddr1; CustAddr[1])
            {
            }
            column(CustAddr2; CustAddr[2])
            {
            }
            column(CustAddr3; CustAddr[3])
            {
            }
            column(CustAddr4; CustAddr[4])
            {
            }
            column(CustAddr5; CustAddr[5])
            {
            }
            column(CustAddr6; CustAddr[6])
            {
            }
            column(ShipToAddr1; ShipToAddr[1])
            {
            }
            column(ShipToAddr2; ShipToAddr[2])
            {
            }
            column(ShipToAddr3; ShipToAddr[3])
            {
            }
            column(ShipToAddr4; ShipToAddr[4])
            {
            }
            column(ShipToAddr5; ShipToAddr[5])
            {
            }
            column(ShipToAddr6; ShipToAddr[6])
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(CopyNo; Number)
                {
                }
                dataitem("Salesperson/Purchaser"; "Salesperson/Purchaser")
                {
                    DataItemLink = Code = FIELD("Salesperson Code");
                    DataItemLinkReference = "Service Header";
                    DataItemTableView = SORTING(Code);
                    column(Name_SalespersonPurchaser; Name)
                    {
                    }
                    column(PhoneNo_SalespersonPurchaser; "Phone No.")
                    {
                    }
                    column(EMail_SalespersonPurchaser; "E-Mail")
                    {
                    }
                }
                dataitem("Service Item Line"; "Service Item Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemLinkReference = "Service Header";
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                    column(ServiceItemLinesLbl; ServiceItemLinesLbl)
                    {
                    }
                    column(DocumentNo_ServiceItemLine; "Document No.")
                    {
                    }
                    column(LineNo_ServiceItemLine; "Line No.")
                    {
                    }
                    column(ServiceItemNo_ServiceItemLineCaption; FieldCaption("Service Item No."))
                    {
                    }
                    column(ServiceItemNo_ServiceItemLine; "Service Item No.")
                    {
                    }
                    column(ServiceItemGroupCode_ServiceItemLineCaption; FieldCaption("Service Item Group Code"))
                    {
                    }
                    column(ServiceItemGroupCode_ServiceItemLine; "Service Item Group Code")
                    {
                    }
                    column(SerialNo_ServiceItemLineCaption; FieldCaption("Serial No."))
                    {
                    }
                    column(SerialNo_ServiceItemLine; "Serial No.")
                    {
                    }
                    column(Description_ServiceItemLineCaption; FieldCaption(Description))
                    {
                    }
                    column(Description_ServiceItemLine; Description)
                    {
                    }
                    column(ItemNo_ServiceItemLineCaption; FieldCaption("Item No."))
                    {
                    }
                    column(ItemNo_ServiceItemLine; "Item No.")
                    {
                    }
                    column(LoanerNo_ServiceItemLineCaption; FieldCaption("Loaner No."))
                    {
                    }
                    column(LoanerNo_ServiceItemLine; "Loaner No.")
                    {
                    }
                    column(ServiceShelfNo_ServiceItemLineCaption; FieldCaption("Service Shelf No."))
                    {
                    }
                    column(ServiceShelfNo_ServiceItemLine; "Service Shelf No.")
                    {
                    }
                    column(Warranty_ServiceItemLineCaption; FieldCaption(Warranty))
                    {
                    }
                    column(Warranty_ServiceItemLine; Format(Warranty))
                    {
                    }
                    dataitem("Fault Comment"; "Service Comment Line")
                    {
                        DataItemLink = "Table Subtype" = FIELD("Document Type"), "No." = FIELD("Document No."), "Table Line No." = FIELD("Line No.");
                        DataItemTableView = SORTING("Table Name", "Table Subtype", "No.", Type, "Table Line No.", "Line No.") WHERE("Table Name" = CONST("Service Header"), Type = CONST(Fault));
                        column(FaultCommentsLbl; FaultCommentsLbl)
                        {
                        }
                        column(Number_FaultComment; Number1)
                        {
                        }
                        column(Comment_FaultComment; Comment)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Number2 := 0;
                            Number1 += 1;
                        end;
                    }
                    dataitem("Resolution Comment"; "Service Comment Line")
                    {
                        DataItemLink = "Table Subtype" = FIELD("Document Type"), "No." = FIELD("Document No."), "Table Line No." = FIELD("Line No.");
                        DataItemTableView = SORTING("Table Name", "Table Subtype", "No.", Type, "Table Line No.", "Line No.") WHERE("Table Name" = CONST("Service Header"), Type = CONST(Resolution));
                        column(ResolutionCommentsLbl; ResolutionCommentsLbl)
                        {
                        }
                        column(Number_ResolutionComment; Number2)
                        {
                        }
                        column(Comment_ResolutionComment; Comment)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Number1 := 0;
                            Number2 += 1;
                        end;
                    }
                }
                dataitem("Service Line"; "Service Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemLinkReference = "Service Header";
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                    column(ServiceLineLbl; ServiceLineLbl)
                    {
                    }
                    column(AmountLbl; AmountLbl)
                    {
                    }
                    column(GrossAmountLbl; GrossAmountLbl)
                    {
                    }
                    column(TotalLbl; TotalLbl)
                    {
                    }
                    column(DocumentNo_ServiceLine; "Document No.")
                    {
                    }
                    column(LineNo_ServiceLine; "Line No.")
                    {
                    }
                    column(LineAmount_ServiceLine; "Line Amount")
                    {
                    }
                    column(AmountIncludingVAT_ServiceLine; "Amount Including VAT")
                    {
                    }
                    column(ServiceItemSerialNo_ServiceLineCaption; FieldCaption("Service Item Serial No."))
                    {
                    }
                    column(ServiceItemSerialNo_ServiceLine; "Service Item Serial No.")
                    {
                    }
                    column(Type_ServiceLineCaption; FieldCaption(Type))
                    {
                    }
                    column(Type_ServiceLine; Type)
                    {
                    }
                    column(No_ServiceLineCaption; FieldCaption("No."))
                    {
                    }
                    column(No_ServiceLine; "No.")
                    {
                    }
                    column(Description_ServiceLineCaption; FieldCaption(Description))
                    {
                    }
                    column(Description_ServiceLine; Description)
                    {
                    }
                    column(UnitPrice_ServiceLineCaption; FieldCaption("Unit Price"))
                    {
                    }
                    column(UnitPrice_ServiceLine; "Unit Price")
                    {
                    }
                    column(LineDiscount_ServiceLineCaption; FieldCaption("Line Discount %"))
                    {
                    }
                    column(LineDiscount_ServiceLine; "Line Discount %")
                    {
                    }
                    column(VariantCode_ServiceLineCaption; FieldCaption("Variant Code"))
                    {
                    }
                    column(VariantCode_ServiceLine; "Variant Code")
                    {
                    }
                    column(Quantity_ServiceLineCaption; FieldCaption(Quantity))
                    {
                    }
                    column(Quantity_ServiceLine; Quantity)
                    {
                    }
                }
                dataitem("User Setup"; "User Setup")
                {
                    DataItemLinkReference = "Service Header";
                    DataItemTableView = SORTING("User ID");
                    dataitem(Employee; Employee)
                    {
                        DataItemLink = "No." = FIELD("Employee No.");
                        DataItemTableView = SORTING("No.");
                        column(FullName_Employee; FullName)
                        {
                        }
                        column(PhoneNo_Employee; "Phone No.")
                        {
                        }
                        column(CompanyEMail_Employee; "Company E-Mail")
                        {
                        }
                    }

                    trigger OnPreDataItem()
                    begin
                        "User Setup".SetRange("User ID", UserId());
                    end;
                }

                trigger OnPostDataItem()
                begin
                    if not IsReportInPreviewMode then
                        CODEUNIT.Run(CODEUNIT::"Service-Printed", "Service Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    if NoOfLoops <= 0 then
                        NoOfLoops := 1;

                    SetRange(Number, 1, NoOfLoops);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageIdOrDefault("Language Code");

                FormatAddr.ServiceOrderSellto(CustAddr, "Service Header");
                FormatAddr.ServiceHeaderShipTo(ShipToAddr, "Service Header");

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;

                if "Payment Method Code" = '' then
                    PaymentMethod.Init
                else
                    PaymentMethod.Get("Payment Method Code");

                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                DocFooter.SetFilter("Language Code", '%1|%2', '', "Language Code");
                if DocFooter.FindLast then
                    DocFooterText := DocFooter."Footer Text"
                else
                    DocFooterText := '';

                if LogInteraction and not IsReportInPreviewMode then
                    if "Contact No." <> '' then
                        SegMgt.LogDocument(
                          25, "No.", 0, 0, DATABASE::Contact, "Contact No.", "Salesperson Code", '', "Posting Description", '')
                    else
                        SegMgt.LogDocument(
                          25, "No.", 0, 0, DATABASE::Customer, "Customer No.", "Salesperson Code", '', "Posting Description", '');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies the number of copies to print.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want the program to record the service quote you print as Interactions and add them to the Interaction Log Entry table.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
            InitLogInteraction;
    end;

    var
        DocFooter: Record "Document Footer";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        ShipmentMethod: Record "Shipment Method";
        Language: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        SegMgt: Codeunit SegManagement;
        CompanyAddr: array[8] of Text[100];
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        DocFooterText: Text[250];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        Number1: Integer;
        Number2: Integer;
        LogInteraction: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DocumentLbl: Label 'Service Quote';
        PageLbl: Label 'Page';
        CopyLbl: Label 'Copy';
        VendLbl: Label 'Vendor';
        CustLbl: Label 'Customer';
        ShipToLbl: Label 'Ship-to';
        PaymentTermsLbl: Label 'Payment Terms';
        PaymentMethodLbl: Label 'Payment Method';
        ShipmentMethodLbl: Label 'Shipment Method';
        SalespersonLbl: Label 'Salesperson';
        PrintedByLbl: Label 'Printed by';
        ServiceItemLinesLbl: Label 'Service Item Lines';
        ServiceLineLbl: Label 'Service Line';
        FaultCommentsLbl: Label 'Fault Comments';
        ResolutionCommentsLbl: Label 'Resolution Comments';
        AmountLbl: Label 'Amount';
        GrossAmountLbl: Label 'Gross Amount';
        TotalLbl: Label 'Total';

    [Scope('OnPrem')]
    procedure InitializeRequest(NoOfCopiesFrom: Integer; LogInteractionFrom: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        LogInteraction := LogInteractionFrom;
    end;

    local procedure InitLogInteraction()
    begin
        LogInteraction := SegMgt.FindInteractTmplCode(25) <> '';
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody);
    end;
}
#endif
