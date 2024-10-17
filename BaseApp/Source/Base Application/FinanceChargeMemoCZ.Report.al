report 31087 "Finance Charge Memo CZ"
{
    DefaultLayout = RDLC;
    RDLCLayout = './FinanceChargeMemoCZ.rdlc';
    Caption = 'Finance Charge Memo CZ';
    PreviewMode = PrintLayout;

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
            column(PhoneNo_CompanyInformationCaption; FieldCaption("Phone No."))
            {
            }
            column(PhoneNo_CompanyInformation; "Phone No.")
            {
            }
            column(Picture_CompanyInformation; Picture)
            {
            }
            dataitem("Sales & Receivables Setup"; "Sales & Receivables Setup")
            {
                DataItemTableView = SORTING("Primary Key");
                column(LogoPositiononDocuments_SalesReceivablesSetup; Format("Logo Position on Documents", 0, 2))
                {
                }
                dataitem("General Ledger Setup"; "General Ledger Setup")
                {
                    DataItemTableView = SORTING("Primary Key");
                    column(LCYCode_GeneralLedgerSetup; "LCY Code")
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddr.Company(CompanyAddr, "Company Information");
            end;
        }
        dataitem("Issued Fin. Charge Memo Header"; "Issued Fin. Charge Memo Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
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
            column(CreatorLbl; CreatorLbl)
            {
            }
            column(VATIdentLbl; VATIdentLbl)
            {
            }
            column(VATPercentLbl; VATPercentLbl)
            {
            }
            column(VATBaseLbl; VATBaseLbl)
            {
            }
            column(VATAmtLbl; VATAmtLbl)
            {
            }
            column(TotalLbl; TotalLbl)
            {
            }
            column(TotalInclVATText; TotalInclVATText)
            {
            }
            column(No_IssuedFinChargeMemoHeader; "No.")
            {
            }
            column(VATRegistrationNo_IssuedFinChargeMemoHeaderCaption; FieldCaption("VAT Registration No."))
            {
            }
            column(VATRegistrationNo_IssuedFinChargeMemoHeader; "VAT Registration No.")
            {
            }
            column(RegistrationNo_IssuedFinChargeMemoHeaderCaption; FieldCaption("Registration No."))
            {
            }
            column(RegistrationNo_IssuedFinChargeMemoHeader; "Registration No.")
            {
            }
            column(BankAccountNo_IssuedFinChargeMemoHeaderCaption; FieldCaption("Bank Account No."))
            {
            }
            column(BankAccountNo_IssuedFinChargeMemoHeader; "Bank Account No.")
            {
            }
            column(IBAN_IssuedFinChargeMemoHeaderCaption; FieldCaption(IBAN))
            {
            }
            column(IBAN_IssuedFinChargeMemoHeader; IBAN)
            {
            }
            column(SWIFTCode_IssuedFinChargeMemoHeaderCaption; FieldCaption("SWIFT Code"))
            {
            }
            column(SWIFTCode_IssuedFinChargeMemoHeader; "SWIFT Code")
            {
            }
            column(CustomerNo_IssuedFinChargeMemoHeaderCaption; FieldCaption("Customer No."))
            {
            }
            column(CustomerNo_IssuedFinChargeMemoHeader; "Customer No.")
            {
            }
            column(PostingDate_IssuedFinChargeMemoHeaderCaption; FieldCaption("Posting Date"))
            {
            }
            column(PostingDate_IssuedFinChargeMemoHeader; "Posting Date")
            {
            }
            column(DocumentDate_IssuedFinChargeMemoHeaderCaption; FieldCaption("Document Date"))
            {
            }
            column(DocumentDate_IssuedFinChargeMemoHeader; "Document Date")
            {
            }
            column(CurrencyCode_IssuedFinChargeMemoHeader; "Currency Code")
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
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(CopyNo; Number)
                {
                }
                dataitem("Issued Fin. Charge Memo Line"; "Issued Fin. Charge Memo Line")
                {
                    CalcFields = "Interest Amount";
                    DataItemLink = "Finance Charge Memo No." = FIELD("No.");
                    DataItemLinkReference = "Issued Fin. Charge Memo Header";
                    DataItemTableView = SORTING("Finance Charge Memo No.", "Line No.");
                    column(DocumentDate_IssuedFinChargeMemoLineCaption; FieldCaption("Document Date"))
                    {
                    }
                    column(DocumentDate_IssuedFinChargeMemoLine; "Document Date")
                    {
                    }
                    column(DocumentType_IssuedFinChargeMemoLineCaption; FieldCaption("Document Type"))
                    {
                    }
                    column(DocumentType_IssuedFinChargeMemoLine; "Document Type")
                    {
                    }
                    column(DocumentNo_IssuedFinChargeMemoLineCaption; FieldCaption("Document No."))
                    {
                    }
                    column(DocumentNo_IssuedFinChargeMemoLine; "Document No.")
                    {
                    }
                    column(DueDate_IssuedFinChargeMemoLineCaption; FieldCaption("Due Date"))
                    {
                    }
                    column(DueDate_IssuedFinChargeMemoLine; "Due Date")
                    {
                    }
                    column(Description_IssuedFinChargeMemoLineCaption; FieldCaption(Description))
                    {
                    }
                    column(Description_IssuedFinChargeMemoLine; Description)
                    {
                    }
                    column(OriginalAmount_IssuedFinChargeMemoLineCaption; FieldCaption("Original Amount"))
                    {
                    }
                    column(OriginalAmount_IssuedFinChargeMemoLine; "Original Amount")
                    {
                    }
                    column(RemainingAmount_IssuedFinChargeMemoLineCaption; FieldCaption("Remaining Amount"))
                    {
                    }
                    column(RemainingAmount_IssuedFinChargeMemoLine; "Remaining Amount")
                    {
                    }
                    column(InterestAmount_IssuedFinChargeMemoLineCaption; FieldCaption("Interest Amount"))
                    {
                    }
                    column(InterestAmount_IssuedFinChargeMemoLine; "Interest Amount")
                    {
                    }
                    column(VATAmount_IssuedFinChargeMemoLineCaption; FieldCaption("VAT Amount"))
                    {
                    }
                    column(VATAmount_IssuedFinChargeMemoLine; "VAT Amount")
                    {
                    }
                    column(Amount_IssuedFinChargeMemoLine; Amount)
                    {
                    }
                    column(LineNo_IssuedFinChargeMemoLine; "Line No.")
                    {
                    }
                    column(Type_IssuedFinChargeMemoLine; Format(Type, 0, 2))
                    {
                    }
                    dataitem("Detailed Iss.Fin.Ch. Memo Line"; "Detailed Iss.Fin.Ch. Memo Line")
                    {
                        DataItemLink = "Finance Charge Memo No." = FIELD("Finance Charge Memo No."), "Fin. Charge. Memo Line No." = FIELD("Line No.");
                        DataItemTableView = SORTING("Finance Charge Memo No.", "Fin. Charge. Memo Line No.", "Detailed Customer Entry No.", "Line No.");
                        column(InterestRate_DetailedIssFinChMemoLineCaption; FieldCaption("Interest Rate"))
                        {
                        }
                        column(InterestRate_DetailedIssFinChMemoLine; "Interest Rate")
                        {
                        }
                        column(InterestAmount_DetailedIssFinChMemoLineCaption; FieldCaption("Interest Amount"))
                        {
                        }
                        column(InterestAmount_DetailedIssFinChMemoLine; "Interest Amount")
                        {
                        }
                        column(PostingDate_DetailedIssFinChMemoLineCaption; FieldCaption("Posting Date"))
                        {
                        }
                        column(PostingDate_DetailedIssFinChMemoLine; "Posting Date")
                        {
                        }
                        column(DocumentNo_DetailedIssFinChMemoLineCaption; FieldCaption("Document No."))
                        {
                        }
                        column(DocumentNo_DetailedIssFinChMemoLine; "Document No.")
                        {
                        }
                        column(BaseAmount_DetailedIssFinChMemoLineCaption; FieldCaption("Base Amount"))
                        {
                        }
                        column(BaseAmount_DetailedIssFinChMemoLine; "Base Amount")
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not PrintInterestDetail then
                                CurrReport.Break();
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TempVATAmountLine.Init();
                        TempVATAmountLine."VAT Identifier" := "VAT Identifier";
                        TempVATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                        TempVATAmountLine."Tax Group Code" := "Tax Group Code";
                        TempVATAmountLine."VAT %" := "VAT %";
                        TempVATAmountLine."VAT Base" := Amount;
                        TempVATAmountLine."VAT Amount" := "VAT Amount";
                        TempVATAmountLine."Amount Including VAT" := Amount + "VAT Amount";
                        TempVATAmountLine."VAT Clause Code" := "VAT Clause Code";
                        TempVATAmountLine.InsertLine;
                    end;

                    trigger OnPreDataItem()
                    begin
                        TempVATAmountLine.Reset();
                        TempVATAmountLine.DeleteAll();
                    end;
                }
                dataitem(VATCounter; "Integer")
                {
                    DataItemTableView = SORTING(Number);
                    column(VATAmtLineVATIdentifier; TempVATAmountLine."VAT Identifier")
                    {
                    }
                    column(VATAmtLineVATPer; TempVATAmountLine."VAT %")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(VATAmtLineVATBase; TempVATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Line".GetCurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VATAmtLineVATAmt; TempVATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VATAmtLineVATBaseLCY; TempVATAmountLine."VAT Base (LCY)")
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Line".GetCurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(VATAmtLineVATAmtLCY; TempVATAmountLine."VAT Amount (LCY)")
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TempVATAmountLine.GetLine(Number);
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, TempVATAmountLine.Count);
                    end;
                }
                dataitem("User Setup"; "User Setup")
                {
                    DataItemLink = "User ID" = FIELD("User ID");
                    DataItemLinkReference = "Issued Fin. Charge Memo Header";
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
                }

                trigger OnPostDataItem()
                begin
                    if not IsReportInPreviewMode then
                        "Issued Fin. Charge Memo Header".IncrNoPrinted;
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

                FormatAddr.IssuedFinanceChargeMemo(CustAddr, "Issued Fin. Charge Memo Header");

                DocumentFooter.SetFilter("Language Code", '%1|%2', '', "Language Code");
                if DocumentFooter.FindLast then
                    DocFooterText := DocumentFooter."Footer Text"
                else
                    DocFooterText := '';

                if "Currency Code" = '' then
                    "Currency Code" := "General Ledger Setup"."LCY Code";

                TotalInclVATText := StrSubstNo(TotalInclVATLbl, "Currency Code");

                if LogInteraction and not IsReportInPreviewMode then
                    SegMgt.LogDocument(
                      19, "No.", 0, 0, DATABASE::Customer, "Customer No.", '', '', "Posting Description", '');
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
                        ToolTip = 'Specifies if you want the program to record the finance charge memos you print as interactions, and add them to the Interaction Log Entry table.';
                    }
                    field(PrintInterestDetail; PrintInterestDetail)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Interest Detail';
                        ToolTip = 'Specifies if the interest details has to be printed.';
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
        DocumentFooter: Record "Document Footer";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        Language: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        SegMgt: Codeunit SegManagement;
        CompanyAddr: array[8] of Text[100];
        CustAddr: array[8] of Text[100];
        DocFooterText: Text[250];
        TotalInclVATText: Text[50];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        LogInteraction: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DocumentLbl: Label 'Finance Charge Memo';
        PageLbl: Label 'Page';
        CopyLbl: Label 'Copy';
        VendLbl: Label 'Vendor';
        CustLbl: Label 'Customer';
        TotalLbl: Label 'Total';
        TotalInclVATLbl: Label 'Total %1 including VAT', Comment = '%1 = currency code';
        CreatorLbl: Label 'Created by';
        VATIdentLbl: Label 'VAT Recapitulation';
        VATPercentLbl: Label 'VAT %', Comment = 'VAT %';
        VATBaseLbl: Label 'VAT Base';
        VATAmtLbl: Label 'VAT Amount';
        PrintInterestDetail: Boolean;

    [Scope('OnPrem')]
    procedure InitializeRequest(NoOfCopiesFrom: Integer; LogInteractionFrom: Boolean; PrintInterestDetailFrom: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        LogInteraction := LogInteractionFrom;
        PrintInterestDetail := PrintInterestDetailFrom;
    end;

    local procedure InitLogInteraction()
    begin
        LogInteraction := SegMgt.FindInteractTmplCode(19) <> '';
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview or MailManagement.IsHandlingGetEmailBody);
    end;
}

