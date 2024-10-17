tableextension 31253 "Purchase Line CZA" extends "Purchase Line"
{
    procedure SetGPPGfromSKUCZA()
    var
        InventorySetup: Record "Inventory Setup";
        GeneralPostingSetup: Record "General Posting Setup";
        Item: Record Item;
        StockkeepingUnit: Record "Stockkeeping Unit";
        WorkCenter: Record "Work Center";
    begin
        if Type <> Type::Item then
            exit;

        InventorySetup.Get();
        if not InventorySetup."Use GPPG from SKU CZA" then
            exit;

        TestField("No.");
        Item.Get("No.");
        if "Work Center No." <> '' then begin
            WorkCenter.Get("Work Center No.");
            Validate("Gen. Prod. Posting Group", WorkCenter."Gen. Prod. Posting Group");
        end else begin
            if "Gen. Prod. Posting Group" <> Item."Gen. Prod. Posting Group" then
                Validate("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");
            if StockkeepingUnit.Get("Location Code", "No.", "Variant Code") then
                if (StockkeepingUnit."Gen. Prod. Posting Group CZL" <> "Gen. Prod. Posting Group") and (StockkeepingUnit."Gen. Prod. Posting Group CZL" <> '') then
                    Validate("Gen. Prod. Posting Group", StockkeepingUnit."Gen. Prod. Posting Group CZL");
        end;
        if "Gen. Bus. Posting Group" <> '' then
            GeneralPostingSetup.Get("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
    end;
}
