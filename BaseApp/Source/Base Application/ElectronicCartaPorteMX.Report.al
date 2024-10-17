report 10480 "Electronic Carta Porte MX"
{
    DefaultLayout = RDLC;
    RDLCLayout = './ElectronicCartaPorteMX.rdlc';
    Caption = 'Electronic Carta Porte Mexico';
    Permissions = TableData "Sales Invoice Line" = rimd;

    dataset
    {
        dataitem("Document Header"; "Document Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            UseTemporary = true;
            column(DocumentNo; "No.")
            {
            }
            column(CompanyInformation_RFCNo_Caption; CompanyInformation_RFCNoLbl)
            {
            }
            column(CompanyInformation_RFCNo; CompanyInformation."RFC No.")
            {
            }
            column(CompanyInformation_SATPostalCode; CompanyInformation."SAT Postal Code")
            {
            }
            column(FiscalRegimeCaption; FiscalRegimeLbl)
            {
            }
            column(CompanyInformation_SATTaxRegime; CompanyInformation."SAT Tax Regime Classification" + ' - ' + SATTaxRegimeClassification)
            {
            }
            column(CompanyInformation_SCTPermissionNumber; CompanyInformation."SCT Permission Number")
            {
            }
            column(TransferRFCNo; TransferRFCNoLbl)
            {
            }
            column(FolioText; TempSalesShipmentHeader."Fiscal Invoice Number PAC")
            {
            }
            column(CertificateSerialNo; TempSalesShipmentHeader."Certificate Serial No.")
            {
            }
            column(DateTimeStamped; TempSalesShipmentHeader."Date/Time Stamped")
            {
            }
            column(InsurerName; "Insurer Name")
            {
            }
            column(InsurerPolicyNumber; "Insurer Policy Number")
            {
            }
            column(StartDateTime; FormatDateTime("Transit-from Date/Time"))
            {
            }
            column(FinishDateTime; FormatDateTime("Transit-from Date/Time" + "Transit Hours" * 1000 * 60 * 60))
            {
            }
            column(TransitDistance; Format("Transit Distance") + 'km')
            {
            }
            column(LocationFromAddress; LocationFrom.Address)
            {
            }
            column(LocationToAddress; LocationTo.Address)
            {
            }
            column(VehicleLicencePlate; FixedAssetVehicle."Vehicle Licence Plate")
            {
            }
            column(SATFederalAutotransport; FixedAssetVehicle."SAT Federal Autotransport")
            {
            }
            column(VehicleYear; FixedAssetVehicle."Vehicle Year")
            {
            }
            column(Trailer1LicencePlate; FixedAssetTrailer1."Vehicle Licence Plate")
            {
            }
            column(Trailer1SATTrailerType; SATTrailerType1.Code + ' - ' + SATTrailerType1.Description)
            {
            }
            column(Trailer2LicencePlate; FixedAssetTrailer2."Vehicle Licence Plate")
            {
            }
            column(Trailer2SATTrailerType; SATTrailerType2.Code + ' - ' + SATTrailerType2.Description)
            {
            }
            column(FolioTextCaption; FolioTextCaptionLbl)
            {
            }
            column(SATTipoRelacion; SATTipoRelacion)
            {
            }
            column(SATFolioFiscal; SATFolioFiscal)
            {
            }
            column(TaxRegimeCaption; TaxRegimeLbl)
            {
            }
            column(DocumentFooter; DocumentFooterLbl)
            {
            }
            column(ClientCartaPorteCaption; ClientCartaPorteLbl)
            {
            }
            column(UsoCFDICaption; UsoCFDILbl)
            {
            }
            column(UsoCFDText; UsoCFDDescriptionLbl)
            {
            }
            column(TotalAmountText; TotalAmountLbl)
            {
            }
            column(OriginalStringBase64Text; OriginalStringBase64Text)
            {
            }
            column(DigitalSignatureBase64Text; DigitalSignatureBase64Text)
            {
            }
            column(DigitalSignaturePACBase64Text; DigitalSignaturePACBase64Text)
            {
            }
            column(Original_StringCaption; Original_StringCaptionLbl)
            {
            }
            column(Digital_StampCaptionSAT; Digital_StampCaptionSATLbl)
            {
            }
            column(Digital_StampCaption; Digital_StampCaptionLbl)
            {
            }
            dataitem("Document Line"; "Document Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                UseTemporary = true;
                column(Page_Caption; PageCaptionLbl)
                {
                }
                column(CurrReport_PAGENO; CurrReport.PageNo())
                {
                }
                column(DocumentLine_No; "No.")
                {
                }
                column(DocumentLine_LineNo; "Line No.")
                {
                }
                column(DocumentLine_Description; Description)
                {
                }
                column(ItemSATClassificationCode; SATClassification."SAT Classification")
                {
                }
                column(ItemSATClassificationDescription; SATClassification.Description)
                {
                }
                column(DocumentLine_UnitOfMeasure; "Unit of Measure")
                {
                }
                column(SATUOMDescription; SATUnitOfMeasure."SAT UofM Code" + ' - ' + SATUnitOfMeasure.Name)
                {
                }
                column(DocumentLine_Quantity; Quantity)
                {
                }
                column(GrossWeight; "Gross Weight")
                {
                }
                column(SATHazardousMaterial; Item."SAT Hazardous Material")
                {
                }
                column(SATPackagingType; SATPackagingType.Code + ' - ' + SATPackagingType.Description)
                {
                }
                column(MaterialPeligroso; MaterialPeligroso)
                {
                }
                column(Item_DescriptionCaption; ItemDescriptionCaptionLbl)
                {
                }
                column(UnitCaption; UnitCaptionLbl)
                {
                }
                column(QuantityCaption; QuantityCaptionLbl)
                {
                }
                column(Unit_PriceCaption; Unit_PriceCaptionLbl)
                {
                }
                column(Total_PriceCaption; Total_PriceCaptionLbl)
                {
                }
                column(Subtotal_Caption; Subtotal_CaptionLbl)
                {
                }
                column(Total_Caption; Total_CaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Item.Get("No.");
                    SATClassification.Get(Item."SAT Item Classification");
                    UnitOfMeasure.Get("Unit of Measure Code");
                    SATUnitOfMeasure.Get(UnitOfMeasure."SAT UofM Classification");
                    if Item."SAT Hazardous Material" <> '' then begin
                        MaterialPeligroso := 'S�';
                        SATPackagingType.Get(Item."SAT Packaging Type");
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    OriginalStringBase64Text := '';
                    DigitalSignatureBase64Text := '';
                    DigitalSignaturePACBase64Text := '';
                end;
            }
            dataitem(CFDITransportOperator; "CFDI Transport Operator")
            {
                DataItemLink = "Document Table ID" = FIELD("Document Table ID"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Table ID", "Document Type", "Document No.", "Operator Code") WHERE("Document Type" = CONST(Quote));
                column(OperatorCode; "Operator Code")
                {
                }
                column(OperatorRFC; Employee."RFC No.")
                {
                }
                column(OperatorLicense; Employee."License No.")
                {
                }
                column(OperatorName; Employee."Search Name")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Employee.Get("Operator Code");
                end;
            }
            dataitem(QRCode; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(QRCode; TempSalesShipmentHeader."QR Code")
                {
                }
                column(QRCode_Number; Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                SalesShipmentHeader: Record "Sales Shipment Header";
                TransferShipmentHeader: Record "Transfer Shipment Header";
                Convert: DotNet Convert;
                Encoding: DotNet Encoding;
                InStreamStamp: InStream;
            begin
                case "Document Table ID" of
                    DATABASE::"Sales Shipment Header":
                        begin
                            SalesShipmentHeader.Get("No.");
                            SalesShipmentHeader.CalcFields("Original String", "Digital Stamp PAC", "Digital Stamp SAT", "QR Code");
                            Clear(OriginalStringBigText);
                            TempBlob.FromRecord(SalesShipmentHeader, SalesShipmentHeader.FieldNo("Original String"));
                            Clear(InStreamStamp);
                            TempBlob.CreateInStream(InStreamStamp);
                            InStreamStamp.Read(OriginalStringBigText);
                            TempBlob.FromRecord(SalesShipmentHeader, SalesShipmentHeader.FieldNo("Digital Stamp SAT"));
                            Clear(DigitalSignatureBigText);
                            Clear(InStreamStamp);
                            TempBlob.CreateInStream(InStreamStamp);
                            InStreamStamp.Read(DigitalSignatureBigText);
                            TempBlob.FromRecord(SalesShipmentHeader, SalesShipmentHeader.FieldNo("Digital Stamp PAC"));
                            Clear(DigitalSignaturePACBigText);
                            Clear(InStreamStamp);
                            TempBlob.CreateInStream(InStreamStamp);
                            InStreamStamp.Read(DigitalSignaturePACBigText);

                            TempSalesShipmentHeader := SalesShipmentHeader;
                        end;
                    DATABASE::"Transfer Shipment Header":
                        begin
                            TransferShipmentHeader.Get("No.");
                            TransferShipmentHeader.CalcFields("Original String", "Digital Stamp PAC", "Digital Stamp SAT", "QR Code");
                            Clear(OriginalStringBigText);
                            TempBlob.FromRecord(TransferShipmentHeader, TransferShipmentHeader.FieldNo("Original String"));
                            Clear(InStreamStamp);
                            TempBlob.CreateInStream(InStreamStamp);
                            InStreamStamp.Read(OriginalStringBigText);
                            TempBlob.FromRecord(TransferShipmentHeader, TransferShipmentHeader.FieldNo("Digital Stamp SAT"));
                            Clear(DigitalSignatureBigText);
                            Clear(InStreamStamp);
                            TempBlob.CreateInStream(InStreamStamp);
                            InStreamStamp.Read(DigitalSignatureBigText);
                            TempBlob.FromRecord(TransferShipmentHeader, TransferShipmentHeader.FieldNo("Digital Stamp PAC"));
                            Clear(DigitalSignaturePACBigText);
                            Clear(InStreamStamp);
                            TempBlob.CreateInStream(InStreamStamp);
                            InStreamStamp.Read(DigitalSignaturePACBigText);

                            TempSalesShipmentHeader."QR Code" := TransferShipmentHeader."QR Code";
                            TempSalesShipmentHeader."Certificate Serial No." := TransferShipmentHeader."Certificate Serial No.";
                            TempSalesShipmentHeader."Fiscal Invoice Number PAC" := TransferShipmentHeader."Fiscal Invoice Number PAC";
                            TempSalesShipmentHeader."Date/Time Stamped" := TransferShipmentHeader."Date/Time Stamped";
                        end;
                end;

                OriginalStringBase64Text := Convert.ToBase64String(Encoding.UTF8.GetBytes(OriginalStringBigText));
                DigitalSignatureBase64Text := Convert.ToBase64String(Encoding.UTF8.GetBytes(DigitalSignatureBigText));
                DigitalSignaturePACBase64Text := Convert.ToBase64String(Encoding.UTF8.GetBytes(DigitalSignaturePACBigText));

                if "Foreign Trade" then begin
                    LocationFrom.Get("Transit-from Location");
                    LocationTo.Get("Transit-to Location");
                end;
                FixedAssetVehicle.Get("Vehicle Code");
                if FixedAssetTrailer1.Get("Trailer 1") then
                    SATTrailerType1.Get(FixedAssetTrailer1."SAT Trailer Type");
                if FixedAssetTrailer2.Get("Trailer 2") then
                    SATTrailerType2.Get(FixedAssetTrailer2."SAT Trailer Type");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        SATUtilities: Codeunit "SAT Utilities";
    begin
        CompanyInformation.Get();
        SATTaxRegimeClassification := SATUtilities.GetSATTaxSchemeDescription(CompanyInformation."SAT Tax Regime Classification");
    end;

    var
        CompanyInformation: Record "Company Information";
        TempSalesShipmentHeader: Record "Sales Shipment Header" temporary;
        Item: Record Item;
        SATClassification: Record "SAT Classification";
        UnitOfMeasure: Record "Unit of Measure";
        SATUnitOfMeasure: Record "SAT Unit of Measure";
        Employee: Record Employee;
        SATPackagingType: Record "SAT Packaging Type";
        SATTrailerType1: Record "SAT Trailer Type";
        SATTrailerType2: Record "SAT Trailer Type";
        LocationFrom: Record Location;
        LocationTo: Record Location;
        FixedAssetVehicle: Record "Fixed Asset";
        FixedAssetTrailer1: Record "Fixed Asset";
        FixedAssetTrailer2: Record "Fixed Asset";
        EInvoiceMgt: Codeunit "E-Invoice Mgt.";
        TempBlob: Codeunit "Temp Blob";
        OriginalStringBigText: BigText;
        DigitalSignatureBigText: BigText;
        DigitalSignaturePACBigText: BigText;
        PageCaptionLbl: Label 'Page:';
        CompanyInformation_RFCNoLbl: Label 'Company RFC';
        FolioTextCaptionLbl: Label 'Folio:';
        ItemDescriptionCaptionLbl: Label 'Item/Description';
        UnitCaptionLbl: Label 'Unit';
        QuantityCaptionLbl: Label 'Quantity';
        Unit_PriceCaptionLbl: Label 'Unit Price';
        Total_PriceCaptionLbl: Label 'Total Price';
        Subtotal_CaptionLbl: Label 'Subtotal:';
        Total_CaptionLbl: Label 'Total:';
        Original_StringCaptionLbl: Label 'Cadena original del complemento de certificación digital del SAT', Comment = 'Locked';
        Digital_StampCaptionSATLbl: Label 'Sello digital del SAT', Comment = 'Locked';
        Digital_StampCaptionLbl: Label 'Sello digital del emisor', Comment = 'Locked';
        DocumentFooterLbl: Label 'Este documento es una representación impresa de un CFDI.', Comment = 'Locked';
        SATTaxRegimeClassification: Text[100];
        TaxRegimeLbl: Label 'Regimen Fiscal:';
        SATTipoRelacion: Text[100];
        SATFolioFiscal: Text[100];
        TransferRFCNoLbl: Label 'XAXX010101000', Comment = 'Locked';
        FiscalRegimeLbl: Label 'R�gimen fiscal', Comment = 'Locked';
        ClientCartaPorteLbl: Label 'Cliente Extranjero carta porte', Comment = 'Locked';
        UsoCFDILbl: Label 'Uso de CFDI';
        UsoCFDDescriptionLbl: Label 'P01 - Por definir';
        TotalAmountLbl: Label 'CERO XXX 00/ 100 XXX', Comment = 'Locked';
        OriginalStringBase64Text: Text;
        DigitalSignatureBase64Text: Text;
        DigitalSignaturePACBase64Text: Text;
        MaterialPeligroso: Text;

    local procedure FormatDateTime(DateTime: DateTime): Text[50]
    begin
        exit(Format(DateTime, 0, '<Year4>-<Month,2>-<Day,2>T<Hours24,2>:<Minutes,2>:<Seconds,2>'));
    end;

    [Scope('OnPrem')]
    procedure SetRecord(RecVariant: Variant)
    begin
        EInvoiceMgt.CreateTempDocumentTransfer(RecVariant, "Document Header", "Document Line");
    end;
}

