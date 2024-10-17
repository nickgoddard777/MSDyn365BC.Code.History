page 1386 "Vendor Templ. Card"
{
    Caption = 'Vendor Template';
    PageType = Card;
    SourceTable = "Vendor Templ.";

    layout
    {
        area(content)
        {
            group(Template)
            {
                Caption = 'General';
                field(Code; Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code of the template.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the description of the template.';
                }
                field("Contact Type"; "Contact Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of contact that will be used to create a vendor with the template.';
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies which transactions with the vendor that cannot be processed, for example a vendor that is declared insolvent.';
                }
                field("No. Series"; "No. Series")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number series that will be used to assign numbers to vendors.';
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                    Visible = false;
                }
                field("Privacy Blocked"; "Privacy Blocked")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.';
                    Visible = false;
                }
                field("Fiscal Code"; "Fiscal Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the customer''s identification code assigned by the Finance and Economics Government Department.';
                }
                field("Special Category"; "Special Category")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the vendor is one of the special categories.';
                }
                field("Disable Search by Name"; "Disable Search by Name")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that you can change vendor name in the document.';
                    Visible = false;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                    Visible = false;
                }
            }
            group(AddressAndContact)
            {
                Caption = 'Address & Contact';
                field(Address; Address)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s address.';
                    Visible = false;
                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies additional address information.';
                    Visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region of the address.';

                    trigger OnValidate()
                    begin
                        IsCountyVisible := FormatAddress.UseCounty("Country/Region Code");
                    end;
                }
                field(City; City)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s city.';
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code.';
                }
                group(CountyGroup)
                {
                    ShowCaption = false;
                    Visible = IsCountyVisible;
                    field(County; County)
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the state, province or county as a part of the address.';
                    }
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s telephone number.';
                    Visible = false;
                }
                field(MobilePhoneNo; "Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = PhoneNo;
                    ToolTip = 'Specifies the vendor''s mobile telephone number.';
                    Visible = false;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    ExtendedDatatype = EMail;
                    Importance = Promoted;
                    ToolTip = 'Specifies the vendor''s email address.';
                    Visible = false;
                }
                field("Fax No."; "Fax No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the vendor''s fax number.';
                    Visible = false;
                }
                field("Home Page"; "Home Page")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the vendor''s web site.';
                    Visible = false;
                }
                field("Our Account No."; "Our Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies your account number with the vendor, if you have one.';
                    Visible = false;
                }
                field("Apply Company Payment days"; "Apply Company Payment days")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if company payment days are applied to purchase invoices for the vendor.';
                }
                group(Contact)
                {
                    Caption = 'Contact';
                    field("Language Code"; "Language Code")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.';
                    }
                    field("Document Sending Profile"; "Document Sending Profile")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the preferred method of sending documents to this vendor.';
                    }
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = VAT;
                    ToolTip = 'Specifies the vendor''s VAT registration number.';
                    Visible = false;
                }
                field("EORI Number"; "EORI Number")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Economic Operators Registration and Identification number that is used when you exchange information with the customs authorities due to trade into or out of the European Union.';
                    Visible = false;
                }
                field(GLN; GLN)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the vendor in connection with electronic document receiving.';
                    Visible = false;
                }
                field("Tax Liable"; "Tax Liable")
                {
                    ApplicationArea = SalesTax;
                    ToolTip = 'Specifies if the customer is liable for sales tax.';
                    Visible = false;
                }
                field("Tax Area Code"; "Tax Area Code")
                {
                    ApplicationArea = SalesTax;
                    ToolTip = 'Specifies a tax area code for the company.';
                    Visible = false;
                }
                field("Validate EU Vat Reg. No."; "Validate EU Vat Reg. No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the VAT registration number will be specified in the EU VAT Registration No. Check page so that it is validated against the VAT registration number validation service.';
                }
                field("Pay-to Vendor No."; "Pay-to Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of a different vendor whom you pay for products delivered by the vendor on the vendor card.';
                }
                field("Invoice Disc. Code"; "Invoice Disc. Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the vendor''s invoice discount code. When you set up a new vendor card, the number you have entered in the No. field is automatically inserted.';
                }
                field("Prices Including VAT"; "Prices Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.';
                }
                field("Price Calculation Method"; "Price Calculation Method")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the default price calculation method.';
                    Visible = false;
                }
                group(PostingDetails)
                {
                    Caption = 'Posting details';
                    field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
                    }
                    field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                    }
                    field("Vendor Posting Group"; "Vendor Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the vendor''s market type to link business transactions made for the vendor with the appropriate account in the general ledger.';
                    }
                }
                group(ForeignTrade)
                {
                    Caption = 'Foreign Trade';
                    field("Currency Code"; "Currency Code")
                    {
                        ApplicationArea = Suite;
                        ToolTip = 'Specifies the default currency on purchase documents or journal lines that you create for the vendor.';
                    }
                }
                field("Tax Representative Type"; "Tax Representative Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the tax representative is a vendor or a contact.';
                }
                field("Tax Representative No."; "Tax Representative No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the identification number of the vendor''s tax representative.';
                }
            }
            group("Free Lance Fee")
            {
                Caption = 'Free Lance Fee';
                field(Resident; Resident)
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies if the individual is a resident or non-resident of Italy.';
                }
                field("Residence Address"; "Residence Address")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the address of the vendor''s residence.';
                }
                field("Residence Post Code"; "Residence Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code of the vendor''s residence.';
                }
                field("Residence City"; "Residence City")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the city where the vendor resides.';
                }
                field("First Name"; "First Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the first name of the individual person.';
                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the surname of the individual person.';
                }
                field("Residence County"; "Residence County")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the county where the vendor resides.';
                }
                field("Date of Birth"; "Date of Birth")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date of the vendor''s birth.';
                }
                field("Birth Post Code"; "Birth Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code of the city where the vendor was born.';
                }
                field("Birth City"; "Birth City")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the city where the vendor was born.';
                }
                field("Birth County"; "Birth County")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the county where the vendor was born.';
                }
                field(Gender; Gender)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the vendor is male or female.';
                }
                field("Individual Person"; "Individual Person")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies if the vendor is an individual person.';
                }
                field("Withholding Tax Code"; "Withholding Tax Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the withholding tax code that is applied to a purchase. ';
                }
                field("Social Security Code"; "Social Security Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Social Security code that is applied to the payment.';
                }
                field("Soc. Sec. 3 Parties Base"; "Soc. Sec. 3 Parties Base")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the Social Security tax liability that is the responsibility of the independent contractor or vendor.';
                }
                field("Country of Fiscal Domicile"; "Country of Fiscal Domicile")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country of the vendor''s permanent residence.';
                }
                field("Contribution Fiscal Code"; "Contribution Fiscal Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code assigned to contribution taxes that have been applied to a purchase invoice from an independent contractor or consultant.';
                }
                field("INAIL Code"; "INAIL Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the INAIL withholding tax code that is applied to this purchase for workers compensation insurance.';
                }
                field("INAIL 3 Parties Base"; "INAIL 3 Parties Base")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the amount of the INAIL tax liability that is the responsibility of the independent contractor or vendor.';
                }
            }
            group(Individual)
            {
                Caption = 'Individual';
                field("First Name2"; "First Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the first name of the individual person.';
                }
                field("Last Name2"; "Last Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the surname of the individual person.';
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Prepayment %"; "Prepayment %")
                {
                    ApplicationArea = Prepayments;
                    Importance = Additional;
                    ToolTip = 'Specifies a prepayment percentage that applies to all orders for this vendor, regardless of the items or services on the order lines.';
                    Visible = false;
                }
                field("Application Method"; "Application Method")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how to apply payments to entries for this vendor.';
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.';
                }
                field("Prepmt. Payment Terms Code"; "Prepmt. Payment Terms Code")
                {
                    ApplicationArea = Prepayments;
                    ToolTip = 'Specifies the payment terms for prepayment.';
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how to make payments, such as with bank transfers or by cash or check.';
                }
                field(Priority; Priority)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the importance of the vendor when suggesting payments using the Suggest Vendor Payments function.';
                    Visible = false;
                }
                field("Fin. Charge Terms Code"; "Fin. Charge Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how the vendor calculates finance charges.';
                }
                field("Block Payment Tolerance"; "Block Payment Tolerance")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to allow a payment tolerance for the vendor.';
                }
                field("Int. on Arrears Code"; "Int. on Arrears Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how the vendor calculates interest on arrears.';
                }
                field("Partner Type"; "Partner Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the vendor is a person or a company.';
                }
                field("Intrastat Partner Type"; Rec."Intrastat Partner Type")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies for Intrastat reporting if the vendor is a person or a company.';
                }
                field("Cash Flow Payment Terms Code"; "Cash Flow Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a payment term that will be used for calculating cash flow.';
                }
                field("Creditor No."; "Creditor No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the vendor.';
                    Visible = false;
                }
            }
            group(Receiving)
            {
                Caption = 'Receiving';
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Location;
                    Importance = Promoted;
                    ToolTip = 'Specifies the warehouse location where items from the vendor must be received by default.';
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
                }
                field("Base Calendar Code"; "Base Calendar Code")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies a customizable calendar for delivery planning that holds the vendor''s working days and holidays.';
                    Visible = false;
                }
                field("Over-Receipt Code"; "Over-Receipt Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the policy that will be used for the vendor if more items than ordered are received.';
                    Visible = false;
                }
                field(Subcontractor; Subcontractor)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the vendor is a subcontractor.';
                }
                field("Subcontracting Location Code"; "Subcontracting Location Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the code for the location where the subcontracted items are stored for pickup and delivery.';
                }
                field("Subcontractor Procurement"; "Subcontractor Procurement")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the subcontractor is managing the product stock on the principal company''s behalf.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Dimensions)
            {
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = const(1383),
                              "No." = field(Code);
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
            }
            action(CopyTemplate)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy Template';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Copies all information to the current template from the selected one.';

                trigger OnAction()
                var
                    VendorTempl: Record "Vendor Templ.";
                    VendorTemplList: Page "Vendor Templ. List";
                begin
                    TestField(Code);
                    VendorTempl.SetFilter(Code, '<>%1', Code);
                    VendorTemplList.LookupMode(true);
                    VendorTemplList.SetTableView(VendorTempl);
                    if VendorTemplList.RunModal() = Action::LookupOK then begin
                        VendorTemplList.GetRecord(VendorTempl);
                        CopyFromTemplate(VendorTempl);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsCountyVisible := FormatAddress.UseCounty("Country/Region Code");
    end;

    var
        FormatAddress: Codeunit "Format Address";
        IsCountyVisible: Boolean;
}