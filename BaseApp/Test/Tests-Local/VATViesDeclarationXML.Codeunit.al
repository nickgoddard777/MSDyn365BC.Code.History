codeunit 142077 "VAT - Vies Declaration XML"
{
    // 
    // Test cases for RFH 350070.
    // 
    // 1. Verify exported XML file via 'VAT - Vies Declaration XML' when there are sales, 3rd party sales ans service sales in exported period.
    // 2. Company Name retreived from VAT Report Setup if it is set there
    // 2. Company Name retreived from Company Information if it is not set in VAT Report Setup
    // 
    // Covers Test cases:
    // -----------------------------------------------------------------
    // Test Function Name                                       TFS ID
    // -----------------------------------------------------------------
    // ExportSalesEU3PartyEUServicesVATVIESDeclaration          350070
    // CompanyNameFromVATReportSetup                            118195
    // CompanyNameEmptyVATReportSetup                           118195

    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
    end;

    var
        FileMgt: Codeunit "File Management";
        LibraryUtility: Codeunit "Library - Utility";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        Assert: Codeunit Assert;
        XMLErr: Label 'XML file does not contains expected value: %1 %2.';
        LibraryRandom: Codeunit "Library - Random";
        XMLDOMManagement: Codeunit "XML DOM Management";
        XmlDoc: DotNet XmlDocument;
        XMLHasElementErr: Label 'XML file contains unexpected value: %1 %2.';
        InvalidCompanyNameTok: Label 'Name - LabÔÇÜ';
        ValidCompanyNameTok: Label 'Name - Labe';
        CustomerXmlNodeTok: Label 'KUNDENINFO', Comment = 'KUNDENINFO';
        NormalNoSeriesCodeTok: Label '000000001';

    [Test]
    [HandlerFunctions('VATVIESDeclarationXMLRequestPageHandler')]
    [Scope('OnPrem')]
    procedure ExportSalesEU3PartyEUServicesVATVIESDeclaration()
    var
        ExportedFileName: Text;
    begin
        // Purpose of the test is to validate OnPreReport of Report ID 11108 VAT - VIES Declaration XML.

        // Setup.
        Initialize;

        // Exercise.
        ExportSalesEU3PartyVATVIES(NormalNoSeriesCodeTok, ExportedFileName);

        // Verify.
        XMLDOMManagement.LoadXMLDocumentFromFile(ExportedFileName, XmlDoc);
        // TFS ID 340090: DREIECK node should not be exported blank
        Assert.IsTrue(VerifyElementDoesNotExistInXMLDoc('DREIECK', ''), StrSubstNo(XMLHasElementErr, 'DREIECK', ''));
        Assert.IsTrue(VerifyElementInXMLDoc('DREIECK', '1'), StrSubstNo(XMLErr, 'DREIECK', '1'));
        Assert.IsTrue(VerifyElementInXMLDoc('SOLEI', '1'), StrSubstNo(XMLErr, 'SOLEI', '1'));
    end;

    [Test]
    [HandlerFunctions('VATVIESDeclarationXMLRequestPageHandler')]
    [Scope('OnPrem')]
    procedure CompanyNameFromVATReportSetup()
    var
        ExportedFileName: Text;
        OldCompanyName: Text[100];
    begin
        // [SCENARIO] Company Name from VAT Report Setup is used in VAT VIES Declaration when it is non-empty
        Initialize;
        // [GIVEN] Invalid Company Name in Company Information
        OldCompanyName := UpdateCompanyInformation(InvalidCompanyNameTok);
        // [GIVEN] Valid Company Name in VAT Report Setup
        UpdateVATReportSetup(ValidCompanyNameTok);
        // [WHEN] XML File generated by VAT VIES Declaration XML report
        ExportSalesEU3PartyVATVIES(NormalNoSeriesCodeTok, ExportedFileName);
        // [THEN] Company name from VAT Report Setup must present in xml file.
        XMLDOMManagement.LoadXMLDocumentFromFile(ExportedFileName, XmlDoc);
        Assert.IsTrue(
          VerifyElementInXMLDoc(CustomerXmlNodeTok, ValidCompanyNameTok),
          StrSubstNo(XMLErr, CustomerXmlNodeTok, ValidCompanyNameTok));

        // Tear down
        UpdateCompanyInformation(OldCompanyName)
    end;

    [Test]
    [HandlerFunctions('VATVIESDeclarationXMLRequestPageHandler')]
    [Scope('OnPrem')]
    procedure CompanyNameEmptyVATReportSetup()
    var
        ExportedFileName: Text;
        OldCompanyName: Text[100];
    begin
        // [SCENARIO] Company Name from Company Information is used in VAT VIES Declaration when it is empty in VAT Report Setup
        Initialize;
        // [GIVEN] Valid Company Name in Company Information
        OldCompanyName := UpdateCompanyInformation(ValidCompanyNameTok);
        // [GIVEN] Empty Company Name in VAT Report Setup
        UpdateVATReportSetup('');
        // [WHEN] XML File generated by VAT VIES Declaration XML report
        ExportSalesEU3PartyVATVIES(NormalNoSeriesCodeTok, ExportedFileName);
        // [THEN] Company name from VAT Report Setup must present in xml file.
        XMLDOMManagement.LoadXMLDocumentFromFile(ExportedFileName, XmlDoc);
        Assert.IsTrue(
          VerifyElementInXMLDoc(CustomerXmlNodeTok, ValidCompanyNameTok),
          StrSubstNo(XMLErr, CustomerXmlNodeTok, ValidCompanyNameTok));

        // Tear down
        UpdateCompanyInformation(OldCompanyName)
    end;

    [Test]
    [HandlerFunctions('VATVIESDeclarationXMLRequestPageHandler')]
    [Scope('OnPrem')]
    procedure ExportSalesEU3PartyVATVIESShortNoSeries()
    var
        ExportedFileName: Text;
    begin
        // Purpose of the test is to validate OnPreReport of Report ID 11108 VAT - VIES Declaration XML.

        // Setup.
        Initialize;

        // Exercise.
        asserterror ExportSalesEU3PartyVATVIES('0000001', ExportedFileName);

        // Validate.
        Assert.ExpectedError('9');
    end;

    [Test]
    [HandlerFunctions('VATVIESDeclarationXMLRequestPageHandler')]
    [Scope('OnPrem')]
    procedure ExportSalesEU3PartyVATVIESInvalidNoSeries()
    var
        ExportedFileName: Text;
    begin
        // Purpose of the test is to validate OnPreReport of Report ID 11108 VAT - VIES Declaration XML.

        // Setup.
        Initialize;

        // Exercise.
        asserterror ExportSalesEU3PartyVATVIES('Z00000001', ExportedFileName);

        // Validate.
        Assert.IsTrue(StrPos(GetLastErrorText, '9') = 0, 'The error message is not the expected one');
    end;

    local procedure RunReportVATVIESDeclarationXML(ReportingType: Option; XMLFileName: Text; ReportingDate: Date; VATBusPostingGroup: Code[20]; NoSeriesCode: Code[20])
    var
        VATVIESDeclarationXML: Report "VAT - VIES Declaration XML";
    begin
        // Enqueue Required inside VATVIESDeclarationXMLRequestPageHandler.
        LibraryVariableStorage.Enqueue(ReportingType);
        LibraryVariableStorage.Enqueue(ReportingDate);
        LibraryVariableStorage.Enqueue(CreateNoSeries(NoSeriesCode));
        LibraryVariableStorage.Enqueue(VATBusPostingGroup);
        Commit;

        VATVIESDeclarationXML.SetFileName(XMLFileName);
        VATVIESDeclarationXML.Run;
    end;

    local procedure Initialize()
    begin
        LibraryVariableStorage.Clear;
    end;

    local procedure CreateCustomerVATEntries(var Customer: Record Customer; var ReportingDate: Date)
    begin
        FindCustomer(Customer);
        ReportingDate := LibraryRandom.RandDate(9);
        CreateVATEntry(Customer, ReportingDate, false, false);
        CreateVATEntry(Customer, ReportingDate, false, true);
        CreateVATEntry(Customer, ReportingDate, true, false);
    end;

    local procedure CreateVATEntry(Customer: Record Customer; PostingDate: Date; EU3Party: Boolean; EUService: Boolean)
    var
        VATEntry: Record "VAT Entry";
        EntryNo: Integer;
    begin
        with VATEntry do begin
            FindLast;
            EntryNo := "Entry No.";
            Init;
            "Entry No." := EntryNo + 1;
            "Posting Date" := PostingDate;
            "Document No." := Format("Entry No.");
            "Document Type" := "Document Type"::Invoice;
            Type := Type::Sale;
            Validate("Bill-to/Pay-to No.", Customer."No.");
            "VAT Bus. Posting Group" := Customer."VAT Bus. Posting Group";
            "EU 3-Party Trade" := EU3Party;
            "EU Service" := EUService;
            Amount := -LibraryRandom.RandDecInRange(10, 1000, 2);
            Base := -LibraryRandom.RandDecInRange(10, 1000, 2);
            Insert;
        end
    end;

    local procedure CreateNoSeries(StartingNo: Code[20]): Code[20]
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeries.Code :=
          LibraryUtility.GenerateRandomCode(NoSeries.FieldNo(Code), DATABASE::"No. Series");
        NoSeries.Insert;
        NoSeriesLine."Series Code" := NoSeries.Code;
        NoSeriesLine."Starting No." := StartingNo;
        NoSeriesLine.Insert;
        exit(NoSeriesLine."Series Code");
    end;

    local procedure ExportSalesEU3PartyVATVIES(NoSeriesCode: Code[20]; var ExportedFileName: Text)
    var
        Customer: Record Customer;
        ReportingType: Option "Normal transmission","Recall of an earlier report";
        ReportingDate: Date;
    begin
        CreateCustomerVATEntries(Customer, ReportingDate);
        ExportedFileName := FileMgt.ServerTempFileName('xml');
        RunReportVATVIESDeclarationXML(
          ReportingType::"Normal transmission", ExportedFileName,
          ReportingDate, Customer."VAT Bus. Posting Group",
          NoSeriesCode);
    end;

    local procedure FindCustomer(var Customer: Record Customer)
    begin
        with Customer do begin
            SetFilter("VAT Bus. Posting Group", '<>%1', '');
            SetFilter("VAT Registration No.", '<>%1', '');
            FindFirst;
        end
    end;

    local procedure UpdateCompanyInformation(CompanyName: Text[100]) OldCompanyName: Text[100]
    var
        CompanyInformation: Record "Company Information";
    begin
        with CompanyInformation do begin
            Get;
            OldCompanyName := Name;
            Validate(Name, CompanyName);
            Modify;
        end;
    end;

    local procedure UpdateVATReportSetup(CompanyName: Text[100])
    var
        VATReportSetup: Record "VAT Report Setup";
    begin
        with VATReportSetup do begin
            Get;
            Validate("Company Name", CompanyName);
            Modify;
        end;
    end;

    local procedure VerifyElementInXMLDoc(ElementName: Text; ExpectedValue: Text): Boolean
    begin
        exit(VerifyElementExistanceInXMLDoc(ElementName, ExpectedValue, true));
    end;

    local procedure VerifyElementDoesNotExistInXMLDoc(ElementName: Text; ExpectedValue: Text): Boolean
    begin
        exit(VerifyElementExistanceInXMLDoc(ElementName, ExpectedValue, false));
    end;

    local procedure VerifyElementExistanceInXMLDoc(ElementName: Text; ExpectedValue: Text; Exists: Boolean): Boolean
    var
        XmlNodeList: DotNet XmlNodeList;
        XmlNode: DotNet XmlNode;
        ElementText: Text;
        ListCount: Integer;
        Counter: Integer;
    begin
        XmlNodeList := XmlDoc.GetElementsByTagName(ElementName);
        ListCount := XmlNodeList.Count;
        for Counter := 0 to ListCount - 1 do begin
            XmlNode := XmlNodeList.Item(Counter);
            ElementText := XmlNode.InnerText;
            if ElementText = ExpectedValue then
                exit(Exists);
        end;
        exit(not Exists);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure VATVIESDeclarationXMLRequestPageHandler(var VATVIESDeclarationXML: TestRequestPage "VAT - VIES Declaration XML")
    var
        ReportingTypeVar: Variant;
        ReportingDateVar: Variant;
        NoSeriesVar: Variant;
        VATBusPostingGroupVar: Variant;
    begin
        LibraryVariableStorage.Dequeue(ReportingTypeVar);
        LibraryVariableStorage.Dequeue(ReportingDateVar);
        LibraryVariableStorage.Dequeue(NoSeriesVar);
        LibraryVariableStorage.Dequeue(VATBusPostingGroupVar);
        with VATVIESDeclarationXML do begin
            ReportingType.SetValue(ReportingTypeVar);
            RepPeriodFrom.SetValue(ReportingDateVar); // Starting Date
            RepPeriodTo.SetValue(ReportingDateVar); // Ending Date
            NoSeries.SetValue(NoSeriesVar);
            "VAT Entry".SetFilter("VAT Bus. Posting Group", VATBusPostingGroupVar);
            SaveAsXml(FileMgt.ServerTempFileName('xml'), FileMgt.ServerTempFileName('xml'));
        end;
    end;
}

