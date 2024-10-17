codeunit 31256 "Sales Line Handler CZA"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterCopyFromItem', '', false, false)]
    local procedure SetGPPGfromSKUOnAfterCopyFromItem(var SalesLine: Record "Sales Line")
    begin
        SalesLine.SetGPPGfromSKUCZA();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateVariantCodeOnAfterChecks', '', false, false)]
    local procedure SetGPPGfromSKUOnValidateVariantCodeOnAfterChecks(var SalesLine: Record "Sales Line")
    begin
        SalesLine.SetGPPGfromSKUCZA();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure SetGPPGfromSKUOnAfterValidateEventLocationCode(var Rec: Record "Sales Line")
    begin
        Rec.SetGPPGfromSKUCZA();
    end;
}
