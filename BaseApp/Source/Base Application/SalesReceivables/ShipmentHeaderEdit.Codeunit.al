codeunit 391 "Shipment Header - Edit"
{
    Permissions = TableData "Sales Shipment Header" = rm;
    TableNo = "Sales Shipment Header";

    trigger OnRun()
    begin
        SalesShptHeader := Rec;
        SalesShptHeader.LockTable();
        SalesShptHeader.Find();
        SalesShptHeader."Shipping Agent Code" := "Shipping Agent Code";
        SalesShptHeader."Shipping Agent Service Code" := "Shipping Agent Service Code";
        SalesShptHeader."Package Tracking No." := "Package Tracking No.";
        SalesShptHeader."Promised Delivery Date" := "Promised Delivery Date";
        SalesShptHeader."Outbound Whse. Handling Time" := "Outbound Whse. Handling Time";
        SalesShptHeader."Shipping Time" := "Shipping Time";
        OnBeforeSalesShptHeaderModify(SalesShptHeader, Rec);
        SalesShptHeader.TestField("No.", "No.");
        SalesShptHeader.Modify();
        Rec := SalesShptHeader;

        OnRunOnAfterSalesShptHeaderEdit(Rec);
    end;

    var
        SalesShptHeader: Record "Sales Shipment Header";

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesShptHeaderModify(var SalesShptHeader: Record "Sales Shipment Header"; FromSalesShptHeader: Record "Sales Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRunOnAfterSalesShptHeaderEdit(var SalesShptHeader: Record "Sales Shipment Header")
    begin
    end;
}
