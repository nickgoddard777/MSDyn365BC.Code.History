codeunit 18160 "e-Invoice Json Handler for Ser"
{
    Permissions = tabledata "Service Invoice Header" = rm,
                  tabledata "Service Cr.Memo Header" = rm;

    trigger OnRun()
    begin
        Initialize();

        if IsInvoice then
            RunServiceInvoice()
        else
            RunServiceCrMemo();

        if DocumentNo <> '' then
            ExportAsJson(DocumentNo)
        else
            Error(DocumentNoBlankErr);
    end;

    var
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        JObject: JsonObject;
        JsonArrayData: JsonArray;
        JsonText: Text;
        DocumentNo: Text[20];
        IsInvoice: Boolean;
        eInvoiceNotApplicableCustErr: Label 'E-Invoicing is not applicable for Unregistered Customer.';
        DocumentNoBlankErr: Label 'E-Invoicing is not supported if document number is blank in the current document.';
        ServiceLinesMaxCountLimitErr: Label 'E-Invoice allowes only 100 lines per Invoice. Current transaction is having %1 lines.', Comment = '%1 = Service Lines count';
        IRNTxt: Label 'Irn', Locked = true;
        AcknowledgementNoTxt: Label 'AckNo', Locked = true;
        AcknowledgementDateTxt: Label 'AckDt', Locked = true;
        IRNHashErr: Label 'No matched IRN Hash %1 found to update.', Comment = '%1 = IRN Hash';
        SignedQRCodeTxt: Label 'SignedQRCode', Locked = true;
        CGSTLbl: Label 'CGST', Locked = true;
        SGSTLbl: label 'SGST', Locked = true;
        IGSTLbl: Label 'IGST', Locked = true;
        CESSLbl: Label 'CESS', Locked = true;

    procedure SetServiceInvHeader(ServiceInvoiceHeaderBuff: Record "Service Invoice Header")
    begin
        ServiceInvoiceHeader := ServiceInvoiceHeaderBuff;
        IsInvoice := true;
    end;

    procedure SetCrMemoHeader(ServiceCrMemoHeaderBuff: Record "Service Cr.Memo Header")
    begin
        ServiceCrMemoHeader := ServiceCrMemoHeaderBuff;
        IsInvoice := false;
    end;

    procedure GenerateCanceledInvoice()
    begin
        Initialize();

        if IsInvoice then begin
            DocumentNo := ServiceInvoiceHeader."No.";
            WriteCancellationJSON(
              ServiceInvoiceHeader."IRN Hash", ServiceInvoiceHeader."Cancel Reason", Format(ServiceInvoiceHeader."Cancel Reason"))
        end else begin
            DocumentNo := ServiceCrMemoHeader."No.";
            WriteCancellationJSON(
              ServiceCrMemoHeader."IRN Hash", ServiceCrMemoHeader."Cancel Reason", Format(ServiceCrMemoHeader."Cancel Reason"));
        end;
        if DocumentNo <> '' then
            ExportAsJson(DocumentNo);
    end;

    procedure GetEInvoiceResponse(var RecRef: RecordRef)
    var
        JSONManagement: Codeunit "JSON Management";
        QRGenerator: Codeunit "QR Generator";
        TempBlob: Codeunit "Temp Blob";
        FieldRef: FieldRef;
        JsonString: Text;
        TempIRNTxt: Text;
        TempDateTime: DateTime;
        AcknowledgementDateTimeText: Text;
        AcknowledgementDate: Date;
        AcknowledgementTime: Time;
    begin
        JsonString := GetResponseText();
        if (JsonString = '') or (JsonString = '[]') then
            exit;

        JSONManagement.InitializeObject(JsonString);
        FieldRef := RecRef.Field(ServiceInvoiceHeader.FieldNo("IRN Hash"));
        TempIRNTxt := FieldRef.Value;
        if TempIRNTxt = JSONManagement.GetValue(IRNTxt) then begin
            FieldRef := RecRef.Field(ServiceInvoiceHeader.FieldNo("Acknowledgement No."));
            FieldRef.Value := JSONManagement.GetValue(AcknowledgementNoTxt);

            AcknowledgementDateTimeText := JSONManagement.GetValue(AcknowledgementDateTxt);
            Evaluate(AcknowledgementDate, CopyStr(AcknowledgementDateTimeText, 1, 10));
            Evaluate(AcknowledgementTime, CopyStr(AcknowledgementDateTimeText, 11, 8));
            TempDateTime := CreateDateTime(AcknowledgementDate, AcknowledgementTime);
            FieldRef := RecRef.Field(ServiceInvoiceHeader.FieldNo("Acknowledgement Date"));

            FieldRef.Value := TempDateTime;
            FieldRef := RecRef.Field(ServiceInvoiceHeader.FieldNo(IsJSONImported));
            FieldRef.Value := true;
            QRGenerator.GenerateQRCodeImage(JSONManagement.GetValue(SignedQRCodeTxt), TempBlob);
            FieldRef := RecRef.Field(ServiceInvoiceHeader.FieldNo("QR Code"));
            TempBlob.ToRecordRef(RecRef, ServiceInvoiceHeader.FieldNo("QR Code"));
            RecRef.Modify();
        end else
            Error(IRNHashErr, TempIRNTxt);
    end;

    local procedure GetResponseText() ResponseText: Text
    var
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        FileText: Text;
    begin
        TempBlob.CreateInStream(InStream);
        UploadIntoStream('', '', '', FileText, InStream);

        if FileText = '' then
            exit;

        InStream.ReadText(ResponseText);
    end;


    local procedure WriteCancelJsonFileHeader()
    begin
        JObject.Add('Version', '1.01');
        JsonArrayData.Add(JObject);
    end;

    local procedure WriteCancellationJSON(
        IRNHash: Text[64];
        CancelReason: Enum "e-Invoice Cancel Reason";
        CancelRemark: Text[100])
    var
        CancelJsonObject: JsonObject;
    begin
        WriteCancelJsonFileHeader();
        CancelJsonObject.Add('Canceldtls', '');
        CancelJsonObject.Add('IRN', IRNHash);
        CancelJsonObject.Add('CnlRsn', Format(CancelReason));
        CancelJsonObject.Add('CnlRem', CancelRemark);

        JsonArrayData.Add(CancelJsonObject);
        JObject.Add('ExpDtls', JsonArrayData);
    end;

    local procedure RunServiceInvoice()
    begin
        if not IsInvoice then
            exit;

        if ServiceInvoiceHeader."GST Customer Type" in [
            ServiceInvoiceHeader."GST Customer Type"::Unregistered,
            ServiceInvoiceHeader."GST Customer Type"::" "]
        then
            Error(eInvoiceNotApplicableCustErr);

        DocumentNo := ServiceInvoiceHeader."No.";
        WriteJsonFileHeader();
        ReadTransactionDetails(ServiceInvoiceHeader."GST Customer Type", ServiceInvoiceHeader."Ship-to Code");
        ReadDocumentHeaderDetails();
        ReadDocumentSellerDetails();
        ReadDocumentBuyerDetails();
        ReadDocumentShippingDetails();
        ReadDocumentItemList();
        ReadDocumentTotalDetails();
        ReadExportDetails();
    end;

    local procedure RunServiceCrMemo()
    begin
        if IsInvoice then
            exit;

        if ServiceCrMemoHeader."GST Customer Type" in [
            ServiceCrMemoHeader."GST Customer Type"::Unregistered,
            ServiceCrMemoHeader."GST Customer Type"::" "]
        then
            Error(eInvoiceNotApplicableCustErr);

        DocumentNo := ServiceCrMemoHeader."No.";
        WriteJsonFileHeader();
        ReadTransactionDetails(ServiceCrMemoHeader."GST Customer Type", ServiceCrMemoHeader."Ship-to Code");
        ReadDocumentHeaderDetails();
        ReadDocumentSellerDetails();
        ReadDocumentBuyerDetails();
        ReadDocumentShippingDetails();
        ReadDocumentItemList();
        ReadDocumentTotalDetails();
        ReadExportDetails();
    end;

    local procedure Initialize()
    begin
        Clear(JObject);
        Clear(JsonArrayData);
        Clear(JsonText);
    end;

    local procedure WriteJsonFileHeader()
    begin
        JObject.Add('TaxSch', 'GST');
        JObject.Add('Version', '1.03');
        JObject.Add('Irn', '');
        JsonArrayData.Add(JObject);
    end;

    local procedure ReadTransactionDetails(GSTCustType: Enum "GST Customer Type"; ShipToCode: Code[12])
    begin
        Clear(JsonArrayData);
        if IsInvoice then
            ReadInvoiceTransactionDetails(GSTCustType, ShipToCode)
        else
            ReadCreditMemoTransactionDetails(GSTCustType, ShipToCode);
    end;

    local procedure ReadCreditMemoTransactionDetails(GSTCustType: Enum "GST Customer Type"; ShipToCode: Code[12])
    var
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
        NatureOfSupply: Text[3];
        SupplyType: Text[3];
        B2BLbl: Label 'B2B';
        EXPLbl: Label 'EXP';
    begin
        if IsInvoice then
            exit;

        if GSTCustType in [
            ServiceCrMemoHeader."GST Customer Type"::Registered,
            ServiceCrMemoHeader."GST Customer Type"::Exempted]
        then
            NatureOfSupply := B2BLbl
        else
            NatureOfSupply := EXPLbl;

        if ShipToCode <> '' then begin
            ServiceCrMemoLine.SetRange("Document No.", DocumentNo);
            if ServiceCrMemoLine.FindLast() then
                if ServiceCrMemoLine."GST Place of Supply" = ServiceCrMemoLine."GST Place of Supply"::"Ship-to Address" then
                    SupplyType := 'REG'
                else
                    SupplyType := 'SHP';
        end;
        WriteTransactionDetails(NatureOfSupply, 'RG', SupplyType, 'false', 'Y', '');
    end;

    local procedure ReadInvoiceTransactionDetails(GSTCustType: Enum "GST Customer Type"; ShipToCode: Code[12])
    var
        ServiceInvoiceLine: Record "Service Invoice Line";
        NatureOfSupplyCategory: Text[3];
        SupplyType: Text[3];
    begin
        if not IsInvoice then
            exit;

        if GSTCustType in [
            ServiceInvoiceHeader."GST Customer Type"::Registered,
            ServiceInvoiceHeader."GST Customer Type"::Exempted]
        then
            NatureOfSupplyCategory := 'B2B'
        else
            NatureOfSupplyCategory := 'EXP';

        if ShipToCode <> '' then begin
            ServiceInvoiceLine.SetRange("Document No.", DocumentNo);
            if ServiceInvoiceLine.FindLast() then
                if ServiceInvoiceLine."GST Place of Supply" <> ServiceInvoiceLine."GST Place of Supply"::"Ship-to Address" then
                    SupplyType := 'SHP'
                else
                    SupplyType := 'REG';
        end;
        WriteTransactionDetails(NatureOfSupplyCategory, 'RG', SupplyType, 'false', 'Y', '');
    end;

    local procedure WriteTransactionDetails(
        SupplyCategory: Text[3];
        RegRev: Text[2];
        SupplyType: Text[3];
        EcmTrnSel: Text[5];
        EcmTrn: Text[1];
        EcmGstin: Text[15])
    var
        JTranDetails: JsonObject;
    begin
        JTranDetails.Add('Catg', SupplyCategory);
        JTranDetails.Add('RegRev', RegRev);
        JTranDetails.Add('Typ', SupplyType);
        JTranDetails.Add('EcmTrnSel', EcmTrnSel);
        JTranDetails.Add('EcmTrn', EcmTrn);
        JTranDetails.Add('EcmGstin', EcmGstin);

        JsonArrayData.Add(JTranDetails);
        JObject.Add('TranDtls', JsonArrayData);
    end;

    local procedure ReadDocumentHeaderDetails()
    var
        InvoiceType: Text[3];
        PostingDate: Text[10];
        OriginalInvoiceNo: Text[16];
    begin
        Clear(JsonArrayData);
        if IsInvoice then begin
            if (ServiceInvoiceHeader."Invoice Type" = ServiceInvoiceHeader."Invoice Type"::"Debit Note") or
               (ServiceInvoiceHeader."Invoice Type" = ServiceInvoiceHeader."Invoice Type"::Supplementary)
            then
                InvoiceType := 'DBN'
            else
                InvoiceType := 'INV';
            PostingDate := Format(ServiceInvoiceHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>');
        end else begin
            InvoiceType := 'CRN';
            PostingDate := Format(ServiceCrMemoHeader."Posting Date", 0, '<Year4>-<Month,2>-<Day,2>');
        end;

        OriginalInvoiceNo := CopyStr(GetReferenceInvoiceNo(DocumentNo), 1, 16);
        WriteDocumentHeaderDetails(InvoiceType, CopyStr(DocumentNo, 1, 16), PostingDate, OriginalInvoiceNo);
    end;

    local procedure WriteDocumentHeaderDetails(InvoiceType: Text[3]; DocumentNo: Text[16]; PostingDate: Text[10]; OriginalInvoiceNo: Text[16])
    var
        JDocumentHeaderDetails: JsonObject;
    begin
        JDocumentHeaderDetails.Add('Typ', InvoiceType);
        JDocumentHeaderDetails.Add('No', DocumentNo);
        JDocumentHeaderDetails.Add('Dt', PostingDate);
        JDocumentHeaderDetails.Add('OrgInvNo', OriginalInvoiceNo);

        JsonArrayData.Add(JDocumentHeaderDetails);
        JObject.Add('DocDtls', JsonArrayData);
    end;

    local procedure ReadExportDetails()
    begin
        Clear(JsonArrayData);
        if IsInvoice then
            ReadInvoiceExportDetails()
        else
            ReadCrMemoExportDetails();
    end;

    local procedure ReadCrMemoExportDetails()
    var
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
        ExportCategory: Text[3];
        WithPayOfDuty: Text[1];
        ShipmentBillNo: Text[16];
        ShipmentBillDate: Text[10];
        ExitPort: Text[10];
        DocumentAmount: Decimal;
        CurrencyCode: Text[3];
        CountryCode: Text[2];
    begin
        if IsInvoice then
            exit;

        if not (ServiceCrMemoHeader."GST Customer Type" in [
            ServiceCrMemoHeader."GST Customer Type"::Export,
            ServiceCrMemoHeader."GST Customer Type"::"Deemed Export",
            ServiceCrMemoHeader."GST Customer Type"::"SEZ Unit",
            ServiceCrMemoHeader."GST Customer Type"::"SEZ Development"])
        then
            exit;

        case ServiceCrMemoHeader."GST Customer Type" of
            ServiceCrMemoHeader."GST Customer Type"::Export:
                ExportCategory := 'DIR';
            ServiceCrMemoHeader."GST Customer Type"::"Deemed Export":
                ExportCategory := 'DEM';
            ServiceCrMemoHeader."GST Customer Type"::"SEZ Unit":
                ExportCategory := 'SEZ';
            "GST Customer Type"::"SEZ Development":
                ExportCategory := 'SED';
        end;

        if ServiceCrMemoHeader."GST Without Payment of Duty" then
            WithPayOfDuty := 'N'
        else
            WithPayOfDuty := 'Y';

        ShipmentBillNo := CopyStr(ServiceCrMemoHeader."Bill Of Export No.", 1, 16);
        ShipmentBillDate := Format(ServiceCrMemoHeader."Bill Of Export Date", 0, '<Year4>-<Month,2>-<Day,2>');
        ExitPort := ServiceCrMemoHeader."Exit Point";

        ServiceCrMemoLine.SetRange("Document No.", ServiceCrMemoHeader."No.");
        if ServiceCrMemoLine.FindSet() then
            repeat
                DocumentAmount := DocumentAmount + ServiceCrMemoLine.Amount;
            until ServiceCrMemoLine.Next() = 0;

        CurrencyCode := CopyStr(ServiceCrMemoHeader."Currency Code", 1, 3);
        CountryCode := CopyStr(ServiceCrMemoHeader."Bill-to Country/Region Code", 1, 2);

        WriteExportDetails(ExportCategory, WithPayOfDuty, ShipmentBillNo, ShipmentBillDate, ExitPort, DocumentAmount, CurrencyCode, CountryCode);
    end;

    local procedure ReadInvoiceExportDetails()
    var
        ServiceInvoiceLine: Record "Service Invoice Line";
        ExportCategory: Text[3];
        WithPayOfDuty: Text[1];
        ShipmentBillNo: Text[16];
        ShipmentBillDate: Text[10];
        ExitPort: Text[10];
        CurrencyCode: Text[3];
        CountryCode: Text[2];
    begin
        if not IsInvoice then
            exit;

        if not (ServiceInvoiceHeader."GST Customer Type" in [
            ServiceInvoiceHeader."GST Customer Type"::Export,
            ServiceInvoiceHeader."GST Customer Type"::"Deemed Export",
            ServiceInvoiceHeader."GST Customer Type"::"SEZ Unit",
            ServiceInvoiceHeader."GST Customer Type"::"SEZ Development"])
        then
            exit;

        case ServiceInvoiceHeader."GST Customer Type" of
            ServiceInvoiceHeader."GST Customer Type"::Export:
                ExportCategory := 'DIR';
            ServiceInvoiceHeader."GST Customer Type"::"Deemed Export":
                ExportCategory := 'DEM';
            ServiceInvoiceHeader."GST Customer Type"::"SEZ Unit":
                ExportCategory := 'SEZ';
            ServiceInvoiceHeader."GST Customer Type"::"SEZ Development":
                ExportCategory := 'SED';
        end;

        if ServiceInvoiceHeader."GST Without Payment of Duty" then
            WithPayOfDuty := 'N'
        else
            WithPayOfDuty := 'Y';

        ShipmentBillNo := CopyStr(ServiceInvoiceHeader."Bill Of Export No.", 1, 16);
        ShipmentBillDate := Format(ServiceInvoiceHeader."Bill Of Export Date", 0, '<Year4>-<Month,2>-<Day,2>');
        ExitPort := ServiceInvoiceHeader."Exit Point";

        ServiceInvoiceLine.SetRange("Document No.", ServiceInvoiceHeader."No.");
        ServiceInvoiceLine.CalcSums(Amount);
        CurrencyCode := CopyStr(ServiceInvoiceHeader."Currency Code", 1, 3);
        CountryCode := CopyStr(ServiceInvoiceHeader."Bill-to Country/Region Code", 1, 2);

        WriteExportDetails(ExportCategory, WithPayOfDuty, ShipmentBillNo, ShipmentBillDate, ExitPort, ServiceInvoiceLine.Amount, CurrencyCode, CountryCode);
    end;

    local procedure WriteExportDetails(
        ExportCategory: Text[3];
        WithPayOfDuty: Text[1];
        ShipmentBillNo: Text[16];
        ShipmentBillDate: Text[10];
        ExitPort: Text[10];
        DocumentAmount: Decimal;
        CurrencyCode: Text[3];
        CountryCode: Text[2])
    var
        JExpDetails: JsonObject;
    begin
        JExpDetails.Add('ExpCat', ExportCategory);
        JExpDetails.Add('WithPay', WithPayOfDuty);
        JExpDetails.Add('ShipBNo', ShipmentBillNo);
        JExpDetails.Add('ShipBDt', ShipmentBillDate);
        JExpDetails.Add('Port', ExitPort);
        JExpDetails.Add('InvForCur', DocumentAmount);
        JExpDetails.Add('ForCur', CurrencyCode);
        JExpDetails.Add('CntCode', CountryCode);

        JsonArrayData.Add(JExpDetails);
        JObject.Add('ExpDtls', JsonArrayData);
    end;

    local procedure ReadDocumentSellerDetails()
    var
        CompanyInformationBuff: Record "Company Information";
        LocationBuff: Record "Location";
        StateBuff: Record "State";
        GSTRegistrationNo: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Flno: Text[60];
        Loc: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        Email: Text[50];
    begin
        Clear(JsonArrayData);
        if IsInvoice then begin
            GSTRegistrationNo := ServiceInvoiceHeader."Location GST Reg. No.";
            LocationBuff.Get(ServiceInvoiceHeader."Location Code");
        end else begin
            GSTRegistrationNo := ServiceCrMemoHeader."Location GST Reg. No.";
            LocationBuff.Get(ServiceCrMemoHeader."Location Code");
        end;

        CompanyInformationBuff.Get();
        CompanyName := CompanyInformationBuff.Name;
        Address := LocationBuff.Address;
        Address2 := LocationBuff."Address 2";
        Flno := '';
        Loc := '';
        City := LocationBuff.City;
        PostCode := CopyStr(LocationBuff."Post Code", 1, 6);
        StateBuff.Get(LocationBuff."State Code");
        StateCode := StateBuff."State Code (GST Reg. No.)";
        PhoneNumber := CopyStr(LocationBuff."Phone No.", 1, 10);
        Email := CopyStr(LocationBuff."E-Mail", 1, 50);

        WriteSellerDetails(GSTRegistrationNo, CompanyName, Address, Address2, Flno, Loc, City, PostCode, StateCode, PhoneNumber, Email);
    end;

    local procedure WriteSellerDetails(
        GSTRegistrationNo: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Flno: Text[60];
        Loc: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        Email: Text[50])
    var
        JSellerDetails: JsonObject;
    begin
        JSellerDetails.Add('Gstin', GSTRegistrationNo);
        JSellerDetails.Add('TrdNm', CompanyName);
        JSellerDetails.Add('Bno', Address);
        JSellerDetails.Add('Bnm', Address2);
        JSellerDetails.Add('Flno', Flno);
        JSellerDetails.Add('Loc', Loc);
        JSellerDetails.Add('Dst', City);
        JSellerDetails.Add('Pin', PostCode);
        JSellerDetails.Add('Stcd', StateCode);
        JSellerDetails.Add('Ph', PhoneNumber);
        JSellerDetails.Add('Em', Email);

        JsonArrayData.Add(JSellerDetails);
        JObject.Add('SellerDtls', JsonArrayData);
    end;

    local procedure ReadDocumentBuyerDetails()
    begin
        Clear(JsonArrayData);
        if IsInvoice then
            ReadInvoiceBuyerDetails()
        else
            ReadCrMemoBuyerDetails();
    end;

    local procedure ReadInvoiceBuyerDetails()
    var
        Contact: Record Contact;
        ServiceInvoiceLine: Record "Service Invoice Line";
        ShiptoAddress: Record "Ship-to Address";
        StateBuff: Record State;
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        Email: Text[50];
    begin
        GSTRegistrationNumber := ServiceInvoiceHeader."Customer GST Reg. No.";
        CompanyName := ServiceInvoiceHeader."Bill-to Name";
        Address := ServiceInvoiceHeader."Bill-to Address";
        Address2 := ServiceInvoiceHeader."Bill-to Address 2";
        Floor := '';
        AddressLocation := '';
        City := ServiceInvoiceHeader."Bill-to City";
        PostCode := CopyStr(ServiceInvoiceHeader."Bill-to Post Code", 1, 6);

        ServiceInvoiceLine.SetRange("Document No.", ServiceInvoiceHeader."No.");
        if ServiceInvoiceLine.FindFirst() then
            case ServiceInvoiceLine."GST Place of Supply" of
                ServiceInvoiceLine."GST Place of Supply"::"Bill-to Address":
                    begin
                        if not (ServiceInvoiceHeader."GST Customer Type" = ServiceInvoiceHeader."GST Customer Type"::Export) then begin
                            StateBuff.Get(ServiceInvoiceHeader."GST Bill-to State Code");
                            StateCode := StateBuff."State Code for eTDS/TCS";
                        end else
                            StateCode := '';

                        if Contact.Get(ServiceInvoiceHeader."Bill-to Contact No.") then begin
                            PhoneNumber := CopyStr(Contact."Phone No.", 1, 10);
                            Email := CopyStr(Contact."E-Mail", 1, 50);
                        end else begin
                            PhoneNumber := '';
                            Email := '';
                        end;
                    end;

                ServiceInvoiceLine."GST Place of Supply"::"Ship-to Address":
                    begin
                        if not (ServiceInvoiceHeader."GST Customer Type" = ServiceInvoiceHeader."GST Customer Type"::Export) then begin
                            StateBuff.Get(ServiceInvoiceHeader."GST Ship-to State Code");
                            StateCode := StateBuff."State Code for eTDS/TCS";
                        end else
                            StateCode := '';

                        if ShiptoAddress.Get(ServiceInvoiceHeader."Customer No.", ServiceInvoiceHeader."Ship-to Code") then begin
                            PhoneNumber := CopyStr(ShiptoAddress."Phone No.", 1, 10);
                            Email := CopyStr(ShiptoAddress."E-Mail", 1, 50);
                        end else begin
                            PhoneNumber := '';
                            Email := '';
                        end;
                    end;
                else begin
                        StateCode := '';
                        PhoneNumber := '';
                        Email := '';
                    end;
            end;
        WriteBuyerDetails(GSTRegistrationNumber, CompanyName, Address, Address2, Floor, AddressLocation, City, PostCode, StateCode, PhoneNumber, Email);
    end;

    local procedure ReadCrMemoBuyerDetails()
    var
        Contact: Record Contact;
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
        ShiptoAddress: Record "Ship-to Address";
        StateBuff: Record State;
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        Email: Text[50];
    begin
        GSTRegistrationNumber := ServiceCrMemoHeader."Customer GST Reg. No.";
        CompanyName := ServiceCrMemoHeader."Bill-to Name";
        Address := ServiceCrMemoHeader."Bill-to Address";
        Address2 := ServiceCrMemoHeader."Bill-to Address 2";
        Floor := '';
        AddressLocation := '';
        City := ServiceCrMemoHeader."Bill-to City";
        PostCode := CopyStr(ServiceCrMemoHeader."Bill-to Post Code", 1, 6);
        StateCode := '';
        PhoneNumber := '';
        Email := '';

        ServiceCrMemoLine.SetRange("Document No.", ServiceCrMemoHeader."No.");
        if ServiceCrMemoLine.FindFirst() then
            case ServiceCrMemoLine."GST Place of Supply" of

                ServiceCrMemoLine."GST Place of Supply"::"Bill-to Address":
                    begin
                        if not (ServiceCrMemoHeader."GST Customer Type" = ServiceCrMemoHeader."GST Customer Type"::Export) then begin
                            StateBuff.Get(ServiceCrMemoHeader."GST Bill-to State Code");
                            StateCode := StateBuff."State Code for eTDS/TCS";
                        end;

                        if Contact.Get(ServiceCrMemoHeader."Bill-to Contact No.") then begin
                            PhoneNumber := CopyStr(Contact."Phone No.", 1, 10);
                            Email := CopyStr(Contact."E-Mail", 1, 50);
                        end;
                    end;

                ServiceCrMemoLine."GST Place of Supply"::"Ship-to Address":
                    begin
                        if not (ServiceCrMemoHeader."GST Customer Type" = ServiceCrMemoHeader."GST Customer Type"::Export) then begin
                            StateBuff.Get(ServiceCrMemoHeader."GST Ship-to State Code");
                            StateCode := StateBuff."State Code for eTDS/TCS";
                        end;

                        if ShiptoAddress.Get(ServiceCrMemoHeader."Customer No.", ServiceCrMemoHeader."Ship-to Code") then begin
                            PhoneNumber := CopyStr(ShiptoAddress."Phone No.", 1, 10);
                            Email := CopyStr(ShiptoAddress."E-Mail", 1, 50);
                        end;
                    end;
            end;

        WriteBuyerDetails(GSTRegistrationNumber, CompanyName, Address, Address2, Floor, AddressLocation, City, PostCode, StateCode, PhoneNumber, Email);
    end;

    local procedure WriteBuyerDetails(
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        EmailID: Text[50])
    var
        JBuyerDetails: JsonObject;
    begin
        JBuyerDetails.Add('Gstin', GSTRegistrationNumber);
        JBuyerDetails.Add('TrdNm', CompanyName);
        JBuyerDetails.Add('Bno', Address);
        JBuyerDetails.Add('Bnm', Address2);
        JBuyerDetails.Add('Flno', Floor);
        JBuyerDetails.Add('Loc', AddressLocation);
        JBuyerDetails.Add('Dst', City);
        JBuyerDetails.Add('Pin', PostCode);
        JBuyerDetails.Add('Stcd', StateCode);
        JBuyerDetails.Add('Ph', PhoneNumber);
        JBuyerDetails.Add('Em', EmailID);

        JsonArrayData.Add(JBuyerDetails);
        JObject.Add('BuyerDtls', JsonArrayData);
    end;

    local procedure ReadDocumentShippingDetails()
    var
        ShiptoAddress: Record "Ship-to Address";
        StateBuff: Record State;
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        EmailID: Text[50];
    begin
        Clear(JsonArrayData);
        if IsInvoice and (ServiceInvoiceHeader."Ship-to Code" <> '') then begin
            ShiptoAddress.Get(ServiceInvoiceHeader."Customer No.", ServiceInvoiceHeader."Ship-to Code");
            StateBuff.Get(ServiceInvoiceHeader."GST Ship-to State Code");
            CompanyName := ServiceInvoiceHeader."Ship-to Name";
            Address := ServiceInvoiceHeader."Ship-to Address";
            Address2 := ServiceInvoiceHeader."Ship-to Address 2";
            City := ServiceInvoiceHeader."Ship-to City";
            PostCode := CopyStr(ServiceInvoiceHeader."Ship-to Post Code", 1, 6);
        end else
            if ServiceCrMemoHeader."Ship-to Code" <> '' then begin
                ShiptoAddress.Get(ServiceCrMemoHeader."Customer No.", ServiceCrMemoHeader."Ship-to Code");
                StateBuff.Get(ServiceCrMemoHeader."GST Ship-to State Code");
                CompanyName := ServiceCrMemoHeader."Ship-to Name";
                Address := ServiceCrMemoHeader."Ship-to Address";
                Address2 := ServiceCrMemoHeader."Ship-to Address 2";
                City := ServiceCrMemoHeader."Ship-to City";
                PostCode := CopyStr(ServiceCrMemoHeader."Ship-to Post Code", 1, 6);
            end;

        GSTRegistrationNumber := ShiptoAddress."GST Registration No.";
        Floor := '';
        AddressLocation := '';
        StateCode := StateBuff."State Code for eTDS/TCS";
        PhoneNumber := CopyStr(ShiptoAddress."Phone No.", 1, 10);
        EmailID := CopyStr(ShiptoAddress."E-Mail", 1, 50);
        WriteShippingDetails(GSTRegistrationNumber, CompanyName, Address, Address2, Floor, AddressLocation, City, PostCode, StateCode, PhoneNumber, EmailID);
    end;

    local procedure WriteShippingDetails(
        GSTRegistrationNumber: Text[20];
        CompanyName: Text[100];
        Address: Text[100];
        Address2: Text[100];
        Floor: Text[60];
        AddressLocation: Text[60];
        City: Text[60];
        PostCode: Text[6];
        StateCode: Text[10];
        PhoneNumber: Text[10];
        EmailID: Text[50])
    var
        JShippingDetails: JsonObject;
    begin
        JShippingDetails.Add('Gstin', GSTRegistrationNumber);
        JShippingDetails.Add('TrdNm', CompanyName);
        JShippingDetails.Add('Bno', Address);
        JShippingDetails.Add('Bnm', Address2);
        JShippingDetails.Add('Flno', Floor);
        JShippingDetails.Add('Loc', AddressLocation);
        JShippingDetails.Add('Dst', City);
        JShippingDetails.Add('Pin', PostCode);
        JShippingDetails.Add('Stcd', StateCode);
        JShippingDetails.Add('Ph', PhoneNumber);
        JShippingDetails.Add('Em', EmailID);

        JsonArrayData.Add(JShippingDetails);
        JObject.Add('ShipDtls', JsonArrayData);
    end;

    local procedure ReadDocumentTotalDetails()
    var
        AssessableAmount: Decimal;
        CGSTAmount: Decimal;
        SGSTAmount: Decimal;
        IGSTAmount: Decimal;
        CessAmount: Decimal;
        StateCessAmount: Decimal;
        CESSNonAvailmentAmount: Decimal;
        DiscountAmount: Decimal;
        OtherCharges: Decimal;
        TotalInvoiceValue: Decimal;
    begin
        Clear(JsonArrayData);
        GetGSTValue(AssessableAmount, CGSTAmount, SGSTAmount, IGSTAmount, CessAmount, StateCessAmount, CESSNonAvailmentAmount, DiscountAmount, OtherCharges, TotalInvoiceValue);
        WriteDocumentTotalDetails(AssessableAmount, CGSTAmount, SGSTAmount, IGSTAmount, CessAmount, StateCessAmount, CESSNonAvailmentAmount, DiscountAmount, OtherCharges, TotalInvoiceValue);
    end;

    local procedure WriteDocumentTotalDetails(
        AssessableAmount: Decimal;
        CGSTAmount: Decimal;
        SGSTAmount: Decimal;
        IGSTAmount: Decimal;
        CessAmount: Decimal;
        StateCessAmount: Decimal;
        CessNonAdvanceVal: Decimal;
        DiscountAmount: Decimal;
        OtherCharges: Decimal;
        TotalInvoiceAmount: Decimal)
    var
        JDocTotalDetails: JsonObject;
    begin
        JDocTotalDetails.Add('Assval', AssessableAmount);
        JDocTotalDetails.Add('CgstVal', CGSTAmount);
        JDocTotalDetails.Add('SgstVAl', SGSTAmount);
        JDocTotalDetails.Add('IgstVal', IGSTAmount);
        JDocTotalDetails.Add('CesVal', CessAmount);
        JDocTotalDetails.Add('StCesVal', StateCessAmount);
        JDocTotalDetails.Add('CesNonAdVal', CessNonAdvanceVal);
        JDocTotalDetails.Add('Disc', DiscountAmount);
        JDocTotalDetails.Add('OthChrg', OtherCharges);
        JDocTotalDetails.Add('TotInvVal', TotalInvoiceAmount);

        JsonArrayData.Add(JDocTotalDetails);
        JObject.Add('ValDtls', JsonArrayData);
    end;

    local procedure ReadDocumentItemList()
    var
        ServiceInvoiceLine: Record "Service Invoice Line";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
        AssessableAmount: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CessRate: Decimal;
        CesNonAdval: Decimal;
        StateCess: Decimal;
        FreeQuantity: Decimal;
        CGSTValue: Decimal;
        SGSTValue: Decimal;
        IGSTValue: Decimal;
    begin
        Clear(JsonArrayData);
        if IsInvoice then begin
            ServiceInvoiceLine.SetRange("Document No.", DocumentNo);
            if ServiceInvoiceLine.FindSet() then begin
                if ServiceInvoiceLine.Count > 100 then
                    Error(ServiceLinesMaxCountLimitErr, ServiceInvoiceLine.Count);
                repeat
                    if ServiceInvoiceLine."GST Assessable Value (LCY)" <> 0 then
                        AssessableAmount := ServiceInvoiceLine."GST Assessable Value (LCY)"
                    else
                        AssessableAmount := ServiceInvoiceLine.Amount;

                    FreeQuantity := 0;
                    GetGSTComponentRate(
                        ServiceInvoiceLine."Document No.",
                        ServiceInvoiceLine."Line No.",
                        CGSTRate,
                        SGSTRate,
                        IGSTRate,
                        CessRate,
                        CesNonAdval,
                        StateCess);

                    GetGSTValueForLine(ServiceInvoiceLine."Line No.", CGSTValue, SGSTValue, IGSTValue);
                    WriteItem(
                      ServiceInvoiceLine.Description + ServiceInvoiceLine."Description 2", '',
                      ServiceInvoiceLine."HSN/SAC Code", '',
                      ServiceInvoiceLine.Quantity, FreeQuantity,
                      CopyStr(ServiceInvoiceLine."Unit of Measure Code", 1, 3),
                      ServiceInvoiceLine."Unit Price",
                      ServiceInvoiceLine."Line Amount" + ServiceInvoiceLine."Line Discount Amount",
                      ServiceInvoiceLine."Line Discount Amount", 0,
                      AssessableAmount, CGSTRate, SGSTRate, IGSTRate, CessRate, CesNonAdval, StateCess,
                      AssessableAmount + CGSTValue + SGSTValue + IGSTValue);
                until ServiceInvoiceLine.Next() = 0;
            end;

            JObject.Add('ItemList', JsonArrayData);
        end else begin
            ServiceCrMemoLine.SetRange("Document No.", DocumentNo);
            if ServiceCrMemoLine.FindSet() then begin
                if ServiceCrMemoLine.Count > 100 then
                    Error(ServiceLinesMaxCountLimitErr, ServiceCrMemoLine.Count);

                repeat
                    if ServiceCrMemoLine."GST Assessable Value (LCY)" <> 0 then
                        AssessableAmount := ServiceCrMemoLine."GST Assessable Value (LCY)"
                    else
                        AssessableAmount := ServiceCrMemoLine.Amount;

                    FreeQuantity := 0;
                    GetGSTComponentRate(
                        ServiceCrMemoLine."Document No.",
                        ServiceCrMemoLine."Line No.",
                        CGSTRate,
                        SGSTRate,
                        IGSTRate,
                        CessRate,
                        CesNonAdval,
                        StateCess);

                    GetGSTValueForLine(ServiceCrMemoLine."Line No.", CGSTValue, SGSTValue, IGSTValue);
                    WriteItem(
                      ServiceCrMemoLine.Description + ServiceCrMemoLine."Description 2", '',
                      ServiceCrMemoLine."HSN/SAC Code", '',
                      ServiceCrMemoLine.Quantity, FreeQuantity,
                      CopyStr(ServiceCrMemoLine."Unit of Measure Code", 1, 3),
                      ServiceCrMemoLine."Unit Price",
                      ServiceCrMemoLine."Line Amount" + ServiceCrMemoLine."Line Discount Amount",
                      ServiceCrMemoLine."Line Discount Amount", 0,
                      AssessableAmount, CGSTRate, SGSTRate, IGSTRate, CessRate, CesNonAdval, StateCess,
                      AssessableAmount + CGSTValue + SGSTValue + IGSTValue);
                until ServiceCrMemoLine.Next() = 0;
            end;

            JObject.Add('ItemList', JsonArrayData);
        end;
    end;

    local procedure WriteItem(
        ProductName: Text;
        ProductDescription: Text;
        HSNCode: Text[10];
        BarCode: Text[30];
        Quantity: Decimal;
        FreeQuantity: Decimal;
        Unit: Text[3];
        UnitPrice: Decimal;
        TotAmount: Decimal;
        Discount: Decimal;
        OtherCharges: Decimal;
        AssessableAmount: Decimal;
        CGSTRate: Decimal;
        SGSTRate: Decimal;
        IGSTRate: Decimal;
        CESSRate: Decimal;
        CessNonAdvanceAmount: Decimal;
        StateCess: Decimal;
        TotalItemValue: Decimal)
    var
        JItem: JsonObject;
    begin
        JItem.Add('PrdNm', ProductName);
        JItem.Add('PrdDesc', ProductDescription);
        JItem.Add('HsnCd', HSNCode);
        JItem.Add('Barcde', BarCode);
        JItem.Add('Qty', Quantity);
        JItem.Add('FreeQty', FreeQuantity);
        JItem.Add('Unit', Unit);
        JItem.Add('UnitPrice', UnitPrice);
        JItem.Add('TotAmt', TotAmount);
        JItem.Add('Discount', Discount);
        JItem.Add('OthChrg', OtherCharges);
        JItem.Add('AssAmt', AssessableAmount);
        JItem.Add('CgstRt', CGSTRate);
        JItem.Add('SgstRt', SGSTRate);
        JItem.Add('IgstRt', IGSTRate);
        JItem.Add('CesRt', CESSRate);
        JItem.Add('CesNonAdval', CessNonAdvanceAmount);
        JItem.Add('StateCes', StateCess);
        JItem.Add('TotItemVal', TotalItemValue);

        JsonArrayData.Add(JItem);
    end;

    local procedure ExportAsJson(FileName: Text[20])
    var
        TempBlob: Codeunit "Temp Blob";
        ToFile: Variant;
        InStream: InStream;
        OutStream: OutStream;
    begin
        JObject.WriteTo(JsonText);
        TempBlob.CreateOutStream(OutStream);
        OutStream.WriteText(JsonText);
        ToFile := FileName + '.json';
        TempBlob.CreateInStream(InStream);
        DownloadFromStream(InStream, 'e-Invoice', '', '', ToFile);
    end;

    local procedure GetReferenceInvoiceNo(DocNo: Code[20]) RefInvNo: Code[20]
    var
        ReferenceInvoiceNo: Record "Reference Invoice No.";
    begin
        ReferenceInvoiceNo.SetRange("Document No.", DocNo);
        if ReferenceInvoiceNo.FindFirst() then
            RefInvNo := ReferenceInvoiceNo."Reference Invoice Nos."
        else
            RefInvNo := '';
    end;

    local procedure GetGSTComponentRate(
        DocumentNo: Code[20];
        LineNo: Integer;
        var CGSTRate: Decimal;
        var SGSTRate: Decimal;
        var IGSTRate: Decimal;
        var CessRate: Decimal;
        var CessNonAdvanceAmount: Decimal;
        var StateCess: Decimal)
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
        DetailedGSTLedgerEntry.SetRange("Document Line No.", LineNo);

        DetailedGSTLedgerEntry.SetRange("GST Component Code", CGSTLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            CGSTRate := DetailedGSTLedgerEntry."GST %"
        else
            CGSTRate := 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", SGSTLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            SGSTRate := DetailedGSTLedgerEntry."GST %"
        else
            SGSTRate := 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", IGSTLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            IGSTRate := DetailedGSTLedgerEntry."GST %"
        else
            IGSTRate := 0;

        CessRate := 0;
        CessNonAdvanceAmount := 0;
        DetailedGSTLedgerEntry.SetRange("GST Component Code", CESSLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            if DetailedGSTLedgerEntry."GST %" > 0 then
                CessRate := DetailedGSTLedgerEntry."GST %"
            else
                CessNonAdvanceAmount := Abs(DetailedGSTLedgerEntry."GST Amount");

        StateCess := 0;
        DetailedGSTLedgerEntry.SetRange("GST Component Code");
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                if not (DetailedGSTLedgerEntry."GST Component Code" in [CGSTLbl, SGSTLbl, IGSTLbl, CESSLbl])
                then
                    StateCess := DetailedGSTLedgerEntry."GST %";
            until DetailedGSTLedgerEntry.Next() = 0;
    end;

    local procedure GetGSTValue(
        var AssessableAmount: Decimal;
        var CGSTAmount: Decimal;
        var SGSTAmount: Decimal;
        var IGSTAmount: Decimal;
        var CessAmount: Decimal;
        var StateCessValue: Decimal;
        var CessNonAdvanceAmount: Decimal;
        var DiscountAmount: Decimal;
        var OtherCharges: Decimal;
        var TotalInvoiceValue: Decimal)
    var
        ServiceInvoiceLine: Record "Service Invoice Line";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
        GSTLedgerEntry: Record "GST Ledger Entry";
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TotGSTAmt: Decimal;
    begin
        GSTLedgerEntry.SetRange("Document No.", DocumentNo);

        GSTLedgerEntry.SetRange("GST Component Code", CGSTLbl);
        if GSTLedgerEntry.FindSet() then
            repeat
                CGSTAmount += Abs(GSTLedgerEntry."GST Amount");
            until GSTLedgerEntry.Next() = 0
        else
            CGSTAmount := 0;

        GSTLedgerEntry.SetRange("GST Component Code", SGSTLbl);
        if GSTLedgerEntry.FindSet() then
            repeat
                SGSTAmount += Abs(GSTLedgerEntry."GST Amount")
            until GSTLedgerEntry.Next() = 0
        else
            SGSTAmount := 0;

        GSTLedgerEntry.SetRange("GST Component Code", IGSTLbl);
        if GSTLedgerEntry.FindSet() then
            repeat
                IGSTAmount += Abs(GSTLedgerEntry."GST Amount")
            until GSTLedgerEntry.Next() = 0
        else
            IGSTAmount := 0;

        CessAmount := 0;
        CessNonAdvanceAmount := 0;

        DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
        DetailedGSTLedgerEntry.SetRange("GST Component Code", CESSLbl);
        if DetailedGSTLedgerEntry.FindFirst() then
            repeat
                if DetailedGSTLedgerEntry."GST %" > 0 then
                    CessAmount += Abs(DetailedGSTLedgerEntry."GST Amount")
                else
                    CessNonAdvanceAmount += Abs(DetailedGSTLedgerEntry."GST Amount");
            until GSTLedgerEntry.Next() = 0;

        GSTLedgerEntry.SetFilter("GST Component Code", '<>CGST|<>SGST|<>IGST|<>CESS');
        if GSTLedgerEntry.FindSet() then
            repeat
                StateCessValue += Abs(GSTLedgerEntry."GST Amount");
            until GSTLedgerEntry.Next() = 0;

        if IsInvoice then begin
            ServiceInvoiceLine.SetRange("Document No.", DocumentNo);
            if ServiceInvoiceLine.FindSet() then
                repeat
                    AssessableAmount += ServiceInvoiceLine.Amount;
                    DiscountAmount += ServiceInvoiceLine."Inv. Discount Amount";
                until ServiceInvoiceLine.Next() = 0;
            TotGSTAmt := CGSTAmount + SGSTAmount + IGSTAmount + CessAmount + CessNonAdvanceAmount + StateCessValue;

            AssessableAmount := Round(
                CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                  WorkDate(), ServiceInvoiceHeader."Currency Code", AssessableAmount, ServiceInvoiceHeader."Currency Factor"), 0.01, '=');
            TotGSTAmt := Round(
                CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                  WorkDate(), ServiceInvoiceHeader."Currency Code", TotGSTAmt, ServiceInvoiceHeader."Currency Factor"), 0.01, '=');
            DiscountAmount := Round(
                CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                  WorkDate(), ServiceInvoiceHeader."Currency Code", DiscountAmount, ServiceInvoiceHeader."Currency Factor"), 0.01, '=');
        end else begin
            ServiceCrMemoLine.SetRange("Document No.", DocumentNo);
            if ServiceCrMemoLine.FindSet() then begin
                repeat
                    AssessableAmount += ServiceCrMemoLine.Amount;
                    DiscountAmount += ServiceCrMemoLine."Inv. Discount Amount";
                until ServiceCrMemoLine.Next() = 0;
                TotGSTAmt := CGSTAmount + SGSTAmount + IGSTAmount + CessAmount + CessNonAdvanceAmount + StateCessValue;
            end;

            AssessableAmount := Round(
                CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                    WorkDate(),
                    ServiceCrMemoHeader."Currency Code",
                    AssessableAmount,
                    ServiceCrMemoHeader."Currency Factor"),
                    0.01,
                    '=');

            TotGSTAmt := Round(
                CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                    WorkDate(),
                    ServiceCrMemoHeader."Currency Code",
                    TotGSTAmt,
                    ServiceCrMemoHeader."Currency Factor"),
                    0.01,
                    '=');

            DiscountAmount := Round(
                CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                    WorkDate(),
                    ServiceCrMemoHeader."Currency Code",
                    DiscountAmount,
                    ServiceCrMemoHeader."Currency Factor"),
                    0.01,
                    '=');
        end;

        CustLedgerEntry.SetCurrentKey("Document No.");
        CustLedgerEntry.SetRange("Document No.", DocumentNo);
        if IsInvoice then begin
            CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
            CustLedgerEntry.SetRange("Customer No.", ServiceInvoiceHeader."Bill-to Customer No.");
        end else begin
            CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
            CustLedgerEntry.SetRange("Customer No.", ServiceCrMemoHeader."Bill-to Customer No.");
        end;

        if CustLedgerEntry.FindFirst() then begin
            CustLedgerEntry.CalcFields("Amount (LCY)");
            TotalInvoiceValue := Abs(CustLedgerEntry."Amount (LCY)");
        end;

        OtherCharges := 0;
    end;

    local procedure GetGSTValueForLine(
        DocumentLineNo: Integer;
        var CGSTLineAmount: Decimal;
        var SGSTLineAmount: Decimal;
        var IGSTLineAmount: Decimal)
    var
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
    begin
        CGSTLineAmount := 0;
        SGSTLineAmount := 0;
        IGSTLineAmount := 0;

        DetailedGSTLedgerEntry.SetRange("Document No.", DocumentNo);
        DetailedGSTLedgerEntry.SetRange("Document Line No.", DocumentLineNo);
        DetailedGSTLedgerEntry.SetRange("GST Component Code", CGSTLbl);
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                CGSTLineAmount += Abs(DetailedGSTLedgerEntry."GST Amount");
            until DetailedGSTLedgerEntry.Next() = 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", SGSTLbl);
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                SGSTLineAmount += Abs(DetailedGSTLedgerEntry."GST Amount")
            until DetailedGSTLedgerEntry.Next() = 0;

        DetailedGSTLedgerEntry.SetRange("GST Component Code", IGSTLbl);
        if DetailedGSTLedgerEntry.FindSet() then
            repeat
                IGSTLineAmount += Abs(DetailedGSTLedgerEntry."GST Amount")
            until DetailedGSTLedgerEntry.Next() = 0;
    end;

    procedure GenerateIRN(input: Text): Text
    var
        CryptographyManagement: Codeunit "Cryptography Management";
        HashAlgorithmType: Option MD5,SHA1,SHA256,SHA384,SHA512;
    begin
        exit(CryptographyManagement.GenerateHash(input, HashAlgorithmType::SHA256));
    end;
}