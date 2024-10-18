﻿codeunit 5817 "Undo Posting Management"
{
    Permissions = TableData "Reservation Entry" = rimd,
                  TableData "Item Entry Relation" = rimd;

    trigger OnRun()
    begin
    end;

    var
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        Text001: Label 'You cannot undo line %1 because there is not sufficient content in the receiving bins.';
        Text002: Label 'You cannot undo line %1 because warehouse put-away lines have already been created.';
        Text003: Label 'You cannot undo line %1 because warehouse activity lines have already been posted.';
        Text004: Label 'You must delete the related %1 before you undo line %2.';
        Text005: Label 'You cannot undo line %1 because warehouse receipt lines have already been created.';
        Text006: Label 'You cannot undo line %1 because warehouse shipment lines have already been created.';
        Text007: Label 'The items have been picked. If you undo line %1, the items will remain in the shipping area until you put them away.\Do you still want to undo the shipment?';
        Text008: Label 'You cannot undo line %1 because warehouse receipt lines have already been posted.';
        Text009: Label 'You cannot undo line %1 because warehouse put-away lines have already been posted.';
        Text010: Label 'You cannot undo line %1 because inventory pick lines have already been posted.';
        Text011: Label 'You cannot undo line %1 because there is an item charge assigned to it on %2 Doc No. %3 Line %4.';
        Text012: Label 'You cannot undo line %1 because an item charge has already been invoiced.';
        Text013: Label 'Item ledger entries are missing for line %1.';
        Text014: Label 'You cannot undo line %1, because a revaluation has already been posted.';
        Text015: Label 'You cannot undo posting of item %1 with variant ''%2'' and unit of measure %3 because it is not available at location %4, bin code %5. The required quantity is %6. The available quantity is %7.';
        SerialNoOnInventoryErr: Label 'Serial No. %1 is already on inventory.';

    procedure TestSalesShptLine(SalesShptLine: Record "Sales Shipment Line")
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesShptLine do
            TestAllTransactions(
                DATABASE::"Sales Shipment Line", "Document No.", "Line No.",
                DATABASE::"Sales Line", SalesLine."Document Type"::Order.AsInteger(), "Order No.", "Order Line No.");
    end;

    procedure TestServShptLine(ServShptLine: Record "Service Shipment Line")
    var
        ServLine: Record "Service Line";
    begin
        with ServShptLine do
            TestAllTransactions(
                DATABASE::"Service Shipment Line", "Document No.", "Line No.",
                DATABASE::"Service Line", ServLine."Document Type"::Order.AsInteger(), "Order No.", "Order Line No.");
    end;

    procedure TestPurchRcptLine(PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        PurchLine: Record "Purchase Line";
    begin
        with PurchRcptLine do
            TestAllTransactions(
                DATABASE::"Purch. Rcpt. Line", "Document No.", "Line No.",
                DATABASE::"Purchase Line", PurchLine."Document Type"::Order.AsInteger(), "Order No.", "Order Line No.");
    end;

    procedure TestReturnShptLine(ReturnShptLine: Record "Return Shipment Line")
    var
        PurchLine: Record "Purchase Line";
    begin
        with ReturnShptLine do
            TestAllTransactions(
                DATABASE::"Return Shipment Line", "Document No.", "Line No.",
                DATABASE::"Purchase Line", PurchLine."Document Type"::"Return Order".AsInteger(), "Return Order No.", "Return Order Line No.");
    end;

    procedure TestReturnRcptLine(ReturnRcptLine: Record "Return Receipt Line")
    var
        SalesLine: Record "Sales Line";
    begin
        with ReturnRcptLine do
            TestAllTransactions(
                DATABASE::"Return Receipt Line", "Document No.", "Line No.",
                DATABASE::"Sales Line", SalesLine."Document Type"::"Return Order".AsInteger(), "Return Order No.", "Return Order Line No.");
    end;

    procedure TestAsmHeader(PostedAsmHeader: Record "Posted Assembly Header")
    var
        AsmHeader: Record "Assembly Header";
    begin
        with PostedAsmHeader do
            TestAllTransactions(
                DATABASE::"Posted Assembly Header", "No.", 0,
                DATABASE::"Assembly Header", AsmHeader."Document Type"::Order.AsInteger(), "Order No.", 0);
    end;

    procedure TestAsmLine(PostedAsmLine: Record "Posted Assembly Line")
    var
        AsmLine: Record "Assembly Line";
    begin
        with PostedAsmLine do
            TestAllTransactions(
                DATABASE::"Posted Assembly Line", "Document No.", "Line No.",
                DATABASE::"Assembly Line", AsmLine."Document Type"::Order.AsInteger(), "Order No.", "Order Line No.");
    end;

#if not CLEAN20
    [Obsolete('Moved to Advance Localization Pack for Czech.', '20.0')]
    [Scope('OnPrem')]
    procedure TestTransferShptLine(TransShptLine: Record "Transfer Shipment Line")
    begin
        // NAVCZ
        with TransShptLine do
            TestAllTransactions(DATABASE::"Transfer Shipment Line",
              "Document No.", "Line No.",
              DATABASE::"Transfer Line",
              0,
              "Transfer Order No.",
              "Line No.");
        // NAVCZ
    end;

#endif
    procedure RunTestAllTransactions(UndoType: Integer; UndoID: Code[20]; UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    begin
        TestAllTransactions(UndoType, UndoID, UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);
    end;

    local procedure TestAllTransactions(UndoType: Integer; UndoID: Code[20]; UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    begin
        OnBeforeTestAllTransactions(UndoType, UndoID, UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);
        if not TestPostedWhseReceiptLine(
             UndoType, UndoID, UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo)
        then begin
            TestWarehouseActivityLine(UndoType, UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);
            TestRgstrdWhseActivityLine(UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);
            TestWhseWorksheetLine(UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);
        end;

        if not (UndoType in [DATABASE::"Purch. Rcpt. Line", DATABASE::"Return Receipt Line"]) then
            TestWarehouseReceiptLine(UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);
        if not (UndoType in [DATABASE::"Sales Shipment Line", DATABASE::"Return Shipment Line", DATABASE::"Service Shipment Line"]) then
            TestWarehouseShipmentLine(UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);
        TestPostedWhseShipmentLine(UndoType, UndoID, UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);
        TestPostedInvtPutAwayLine(UndoType, UndoID, UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);
        TestPostedInvtPickLine(UndoType, UndoID, UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);

        TestItemChargeAssignmentPurch(UndoType, UndoLineNo, SourceID, SourceRefNo);
        TestItemChargeAssignmentSales(UndoType, UndoLineNo, SourceID, SourceRefNo);

        OnAfterTestAllTransactions(UndoType, UndoID, UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);
    end;

    local procedure TestPostedWhseReceiptLine(UndoType: Integer; UndoID: Code[20]; UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer): Boolean
    var
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";
        PostedAsmHeader: Record "Posted Assembly Header";
        WhseUndoQty: Codeunit "Whse. Undo Quantity";
    begin
        case UndoType of
            DATABASE::"Posted Assembly Line":
                begin
                    TestWarehouseActivityLine(UndoType, UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo);
                    exit(true);
                end;
            DATABASE::"Posted Assembly Header":
                begin
                    PostedAsmHeader.Get(UndoID);
                    if not PostedAsmHeader.IsAsmToOrder then
                        TestWarehouseBinContent(SourceType, SourceSubtype, SourceID, SourceRefNo, PostedAsmHeader."Quantity (Base)");
                    exit(true);
                end;
        end;

        if not WhseUndoQty.FindPostedWhseRcptLine(
             PostedWhseReceiptLine, UndoType, UndoID, SourceType, SourceSubtype, SourceID, SourceRefNo)
        then
            exit(false);

        TestWarehouseEntry(UndoLineNo, PostedWhseReceiptLine);
        TestWarehouseActivityLine2(UndoLineNo, PostedWhseReceiptLine);
        TestRgstrdWhseActivityLine2(UndoLineNo, PostedWhseReceiptLine);
        TestWhseWorksheetLine2(UndoLineNo, PostedWhseReceiptLine);
        exit(true);
    end;

    local procedure TestWarehouseEntry(UndoLineNo: Integer; var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    var
        WarehouseEntry: Record "Warehouse Entry";
        Location: Record Location;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestWarehouseEntry(UndoLineNo, PostedWhseReceiptLine, IsHandled);
        if IsHandled then
            exit;

        with WarehouseEntry do begin
            if PostedWhseReceiptLine."Location Code" = '' then
                exit;
            Location.Get(PostedWhseReceiptLine."Location Code");
            if Location."Bin Mandatory" then begin
                SetCurrentKey("Item No.", "Location Code", "Variant Code", "Bin Type Code");
                SetRange("Item No.", PostedWhseReceiptLine."Item No.");
                SetRange("Location Code", PostedWhseReceiptLine."Location Code");
                SetRange("Variant Code", PostedWhseReceiptLine."Variant Code");
                if Location."Directed Put-away and Pick" then
                    SetFilter("Bin Type Code", GetBinTypeFilter(0)); // Receiving area
                OnTestWarehouseEntryOnAfterSetFilters(WarehouseEntry, PostedWhseReceiptLine);
                CalcSums("Qty. (Base)");
                if "Qty. (Base)" < PostedWhseReceiptLine."Qty. (Base)" then
                    Error(Text001, UndoLineNo);
            end;
        end;
    end;

    local procedure TestWarehouseBinContent(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; UndoQtyBase: Decimal)
    var
        WhseEntry: Record "Warehouse Entry";
        BinContent: Record "Bin Content";
        QtyAvailToTake: Decimal;
    begin
        with WhseEntry do begin
            SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, true);
            if not FindFirst() then
                exit;

            BinContent.Get("Location Code", "Bin Code", "Item No.", "Variant Code", "Unit of Measure Code");
            QtyAvailToTake := BinContent.CalcQtyAvailToTake(0);
            if QtyAvailToTake < UndoQtyBase then
                Error(Text015,
                  "Item No.",
                  "Variant Code",
                  "Unit of Measure Code",
                  "Location Code",
                  "Bin Code",
                  UndoQtyBase,
                  QtyAvailToTake);
        end;
    end;

    local procedure TestWarehouseActivityLine2(UndoLineNo: Integer; var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    var
        WarehouseActivityLine: Record "Warehouse Activity Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestWarehouseActivityLine2(WarehouseActivityLine, IsHandled);
        if IsHandled then
            exit;

        with WarehouseActivityLine do begin
            SetCurrentKey("Whse. Document No.", "Whse. Document Type", "Activity Type", "Whse. Document Line No.");
            SetRange("Whse. Document No.", PostedWhseReceiptLine."No.");
            SetRange("Whse. Document Type", "Whse. Document Type"::Receipt);
            SetRange("Activity Type", "Activity Type"::"Put-away");
            SetRange("Whse. Document Line No.", PostedWhseReceiptLine."Line No.");
            if not IsEmpty() then
                Error(Text002, UndoLineNo);
        end;
    end;

    local procedure TestRgstrdWhseActivityLine2(UndoLineNo: Integer; var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    var
        RegisteredWhseActivityLine: Record "Registered Whse. Activity Line";
    begin
        with RegisteredWhseActivityLine do begin
            SetCurrentKey("Whse. Document Type", "Whse. Document No.", "Whse. Document Line No.");
            SetRange("Whse. Document Type", "Whse. Document Type"::Receipt);
            SetRange("Whse. Document No.", PostedWhseReceiptLine."No.");
            SetRange("Whse. Document Line No.", PostedWhseReceiptLine."Line No.");
            if not IsEmpty() then
                Error(Text003, UndoLineNo);
        end;
    end;

    local procedure TestWhseWorksheetLine2(UndoLineNo: Integer; var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    var
        WhseWorksheetLine: Record "Whse. Worksheet Line";
    begin
        with WhseWorksheetLine do begin
            SetCurrentKey("Whse. Document Type", "Whse. Document No.", "Whse. Document Line No.");
            SetRange("Whse. Document Type", "Whse. Document Type"::Receipt);
            SetRange("Whse. Document No.", PostedWhseReceiptLine."No.");
            SetRange("Whse. Document Line No.", PostedWhseReceiptLine."Line No.");
            if not IsEmpty() then
                Error(Text004, TableCaption, UndoLineNo);
        end;
    end;

    local procedure TestWarehouseActivityLine(UndoType: Integer; UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        WarehouseActivityLine: Record "Warehouse Activity Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestWarehouseActivityLine(UndoType, UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo, IsHandled);
        if IsHandled then
            exit;

        with WarehouseActivityLine do begin
            SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, -1, true);
            if not IsEmpty() then begin
                if UndoType = DATABASE::"Assembly Line" then
                    Error(Text002, UndoLineNo);
                Error(Text003, UndoLineNo);
            end;
        end;
    end;

    local procedure TestRgstrdWhseActivityLine(UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        RegisteredWhseActivityLine: Record "Registered Whse. Activity Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestRgstrdWhseActivityLine(UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo, IsHandled);
        if IsHandled then
            exit;

        with RegisteredWhseActivityLine do begin
            SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, -1, true);
            SetRange("Activity Type", "Activity Type"::"Put-away");
            if not IsEmpty() then
                Error(Text002, UndoLineNo);
        end;
    end;

    local procedure TestWarehouseReceiptLine(UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        WhseManagement: Codeunit "Whse. Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestWarehouseReceiptLine(UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo, IsHandled);
        if IsHandled then
            exit;

        with WarehouseReceiptLine do begin
            WhseManagement.SetSourceFilterForWhseRcptLine(WarehouseReceiptLine, SourceType, SourceSubtype, SourceID, SourceRefNo, true);
            if not IsEmpty() then
                Error(Text005, UndoLineNo);
        end;
    end;

    local procedure TestWarehouseShipmentLine(UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestWarehouseShipmentLine(UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo, IsHandled);
        if IsHandled then
            exit;

        with WarehouseShipmentLine do begin
            SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, true);
            if not IsEmpty() then
                Error(Text006, UndoLineNo);
        end;
    end;

    local procedure TestPostedWhseShipmentLine(UndoType: Integer; UndoID: Code[20]; UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        WhseManagement: Codeunit "Whse. Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestPostedWhseShipmentLine(UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo, IsHandled, UndoType, UndoID);
        if IsHandled then
            exit;

        with PostedWhseShipmentLine do begin
            WhseManagement.SetSourceFilterForPostedWhseShptLine(PostedWhseShipmentLine, SourceType, SourceSubtype, SourceID, SourceRefNo, true);
            if not IsEmpty() then
                if not Confirm(Text007, true, UndoLineNo) then
                    Error('');
        end;
    end;

    local procedure TestWhseWorksheetLine(UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        WhseWorksheetLine: Record "Whse. Worksheet Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestWhseWorksheetLine(UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo, IsHandled);
        if IsHandled then
            exit;

        with WhseWorksheetLine do begin
            SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, true);
            if not IsEmpty() then
                Error(Text008, UndoLineNo);
        end;
    end;

    local procedure TestPostedInvtPutAwayLine(UndoType: Integer; UndoID: Code[20]; UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        PostedInvtPutAwayLine: Record "Posted Invt. Put-away Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestPostedInvtPutAwayLine(UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo, IsHandled, UndoType, UndoID);
        if IsHandled then
            exit;

        with PostedInvtPutAwayLine do begin
            SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, true);
            if not IsEmpty() then
                Error(Text009, UndoLineNo);
        end;
    end;

    local procedure TestPostedInvtPickLine(UndoType: Integer; UndoID: Code[20]; UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        PostedInvtPickLine: Record "Posted Invt. Pick Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestPostedInvtPickLine(UndoLineNo, SourceType, SourceSubtype, SourceID, SourceRefNo, IsHandled, UndoType, UndoID);
        if IsHandled then
            exit;

        with PostedInvtPickLine do begin
            SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, true);
            if not IsEmpty() then
                Error(Text010, UndoLineNo);
        end;
    end;

    local procedure TestItemChargeAssignmentPurch(UndoType: Integer; UndoLineNo: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)";
    begin
        with ItemChargeAssignmentPurch do begin
            SetCurrentKey("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
            case UndoType of
                DATABASE::"Purch. Rcpt. Line":
                    SetRange("Applies-to Doc. Type", "Applies-to Doc. Type"::Receipt);
                DATABASE::"Return Shipment Line":
                    SetRange("Applies-to Doc. Type", "Applies-to Doc. Type"::"Return Shipment");
                else
                    exit;
            end;
            SetRange("Applies-to Doc. No.", SourceID);
            SetRange("Applies-to Doc. Line No.", SourceRefNo);
            if not IsEmpty() then
                if FindFirst() then
                    Error(Text011, UndoLineNo, "Document Type", "Document No.", "Line No.");
        end;
    end;

    local procedure TestItemChargeAssignmentSales(UndoType: Integer; UndoLineNo: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        ItemChargeAssignmentSales: Record "Item Charge Assignment (Sales)";
    begin
        with ItemChargeAssignmentSales do begin
            SetCurrentKey("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
            case UndoType of
                DATABASE::"Sales Shipment Line":
                    SetRange("Applies-to Doc. Type", "Applies-to Doc. Type"::Shipment);
                DATABASE::"Return Receipt Line":
                    SetRange("Applies-to Doc. Type", "Applies-to Doc. Type"::"Return Receipt");
                else
                    exit;
            end;
            SetRange("Applies-to Doc. No.", SourceID);
            SetRange("Applies-to Doc. Line No.", SourceRefNo);
            if not IsEmpty() then
                if FindFirst() then
                    Error(Text011, UndoLineNo, "Document Type", "Document No.", "Line No.");
        end;
    end;

    local procedure GetBinTypeFilter(Type: Option Receive,Ship,"Put Away",Pick): Text[1024]
    var
        BinType: Record "Bin Type";
        "Filter": Text[1024];
    begin
        with BinType do begin
            case Type of
                Type::Receive:
                    SetRange(Receive, true);
                Type::Ship:
                    SetRange(Ship, true);
                Type::"Put Away":
                    SetRange("Put Away", true);
                Type::Pick:
                    SetRange(Pick, true);
            end;
            if Find('-') then
                repeat
                    Filter := StrSubstNo('%1|%2', Filter, Code);
                until Next() = 0;
            if Filter <> '' then
                Filter := CopyStr(Filter, 2);
        end;
        exit(Filter);
    end;

    procedure CheckItemLedgEntries(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; LineRef: Integer)
    begin
        CheckItemLedgEntries(TempItemLedgEntry, LineRef, false);
    end;

    procedure CheckItemLedgEntries(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; LineRef: Integer; InvoicedEntry: Boolean)
    var
        ItemRec: Record Item;
        PostedATOLink: Record "Posted Assemble-to-Order Link";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckItemLedgEntries(TempItemLedgEntry, LineRef, InvoicedEntry, IsHandled);
        if IsHandled then
            exit;

        with TempItemLedgEntry do begin
            Find('-'); // Assertion: will fail if not found.
            ItemRec.Get("Item No.");
            if ItemRec.IsNonInventoriableType then
                exit;

            repeat
                OnCheckItemLedgEntriesOnBeforeCheckTempItemLedgEntry(TempItemLedgEntry);
                if Positive then begin
                    if ("Job No." = '') and
                       not (("Order Type" = "Order Type"::Assembly) and
                            PostedATOLink.Get(PostedATOLink."Assembly Document Type"::Assembly, "Document No."))
                    then
                        if InvoicedEntry then
                            TestField("Remaining Quantity", Quantity - "Invoiced Quantity")
                        else
                            TestField("Remaining Quantity", Quantity);
                end else
                    if "Entry Type" <> "Entry Type"::Transfer then // NAVCZ
                        if InvoicedEntry then
                            TestField("Shipped Qty. Not Returned", Quantity - "Invoiced Quantity")
                        else
                            TestField("Shipped Qty. Not Returned", Quantity);

                CalcFields("Reserved Quantity");
                TestField("Reserved Quantity", 0);

                CheckValueEntries(TempItemLedgEntry, LineRef, InvoicedEntry);

                if ItemRec."Costing Method" = ItemRec."Costing Method"::Specific then
                    TestField("Serial No.");
            until Next() = 0;
        end; // WITH
    end;

    local procedure CheckValueEntries(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; LineRef: Integer; InvoicedEntry: Boolean)
    var
        ValueEntry: Record "Value Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckValueEntries(TempItemLedgEntry, LineRef, InvoicedEntry, IsHandled);
        if IsHandled then
            exit;

        ValueEntry.SetCurrentKey("Item Ledger Entry No.");
        ValueEntry.SetRange("Item Ledger Entry No.", TempItemLedgEntry."Entry No.");
        if ValueEntry.FindSet() then
            repeat
                if ValueEntry."Item Charge No." <> '' then
                    Error(Text012, LineRef);
                if ValueEntry."Entry Type" = ValueEntry."Entry Type"::Revaluation then
                    Error(Text014, LineRef);
            until ValueEntry.Next() = 0;
    end;

    procedure PostItemJnlLineAppliedToList(ItemJnlLine: Record "Item Journal Line"; var TempApplyToItemLedgEntry: Record "Item Ledger Entry" temporary; UndoQty: Decimal; UndoQtyBase: Decimal; var TempItemLedgEntry: Record "Item Ledger Entry" temporary; var TempItemEntryRelation: Record "Item Entry Relation" temporary)
    begin
        PostItemJnlLineAppliedToList(ItemJnlLine, TempApplyToItemLedgEntry, UndoQty, UndoQtyBase, TempItemLedgEntry, TempItemEntryRelation, false);
    end;

    procedure PostItemJnlLineAppliedToList(ItemJnlLine: Record "Item Journal Line"; var TempApplyToItemLedgEntry: Record "Item Ledger Entry" temporary; UndoQty: Decimal; UndoQtyBase: Decimal; var TempItemLedgEntry: Record "Item Ledger Entry" temporary; var TempItemEntryRelation: Record "Item Entry Relation" temporary; InvoicedEntry: Boolean)
    var
        ItemApplicationEntry: Record "Item Application Entry";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        NonDistrQuantity: Decimal;
        NonDistrQuantityBase: Decimal;
    begin
        if InvoicedEntry then begin
            TempApplyToItemLedgEntry.SetRange("Completely Invoiced", false);
            if AreAllItemEntriesCompletelyInvoiced(TempApplyToItemLedgEntry) then begin
                TempApplyToItemLedgEntry.SetRange("Completely Invoiced");
                exit;
            end;
        end;
        TempApplyToItemLedgEntry.Find('-'); // Assertion: will fail if not found.
        if ItemJnlLine."Job No." = '' then
            ItemJnlLine.TestField(Correction, true);
        NonDistrQuantity := -UndoQty;
        NonDistrQuantityBase := -UndoQtyBase;
        repeat
            if ItemJnlLine."Job No." = '' then
                ItemJnlLine."Applies-to Entry" := TempApplyToItemLedgEntry."Entry No."
            else
                ItemJnlLine."Applies-to Entry" := 0;

            ItemJnlLine."Item Shpt. Entry No." := 0;
            ItemJnlLine."Quantity (Base)" := -TempApplyToItemLedgEntry.Quantity;
            ItemJnlLine."Invoiced Quantity" := -TempApplyToItemLedgEntry."Invoiced Quantity";
            ItemJnlLine.CopyTrackingFromItemLedgEntry(TempApplyToItemLedgEntry);
            if ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Transfer then begin
                ItemJnlLine."New Serial No." := TempApplyToItemLedgEntry."Serial No.";
                ItemJnlLine."New Lot No." := TempApplyToItemLedgEntry."Lot No.";
            end;

            // NAVCZ
            if (TempApplyToItemLedgEntry.Quantity < 0) and
               ((TempApplyToItemLedgEntry."Document Type" = TempApplyToItemLedgEntry."Document Type"::"Sales Shipment") or
                (TempApplyToItemLedgEntry."Document Type" = TempApplyToItemLedgEntry."Document Type"::"Purchase Return Shipment") or
                (TempApplyToItemLedgEntry."Document Type" = TempApplyToItemLedgEntry."Document Type"::"Service Shipment") or
                (TempApplyToItemLedgEntry."Document Type" = TempApplyToItemLedgEntry."Document Type"::"Purchase Receipt") or
                (TempApplyToItemLedgEntry."Document Type" = TempApplyToItemLedgEntry."Document Type"::"Sales Return Receipt"))
            then
                if (ItemJnlLine."Serial No." <> '') and IsSNRequired(ItemJnlLine) then
                    if ItemTrackingMgt.FindInInventory(ItemJnlLine."Item No.", ItemJnlLine."Variant Code", ItemJnlLine."Serial No.") then
                        Error(SerialNoOnInventoryErr, ItemJnlLine."Serial No.");
            // NAVCZ

            // Quantity is filled in according to UOM:
            AdjustQuantityRounding(ItemJnlLine, NonDistrQuantity, NonDistrQuantityBase);

            NonDistrQuantity := NonDistrQuantity - ItemJnlLine.Quantity;
            NonDistrQuantityBase := NonDistrQuantityBase - ItemJnlLine."Quantity (Base)";

            OnBeforePostItemJnlLine(ItemJnlLine, TempApplyToItemLedgEntry);
            PostItemJnlLine(ItemJnlLine);
            OnPostItemJnlLineAppliedToListOnAfterPostItemJnlLine(ItemJnlLine, TempApplyToItemLedgEntry);

            UndoValuePostingFromJob(ItemJnlLine, ItemApplicationEntry, TempApplyToItemLedgEntry);

            TempItemEntryRelation."Item Entry No." := ItemJnlLine."Item Shpt. Entry No.";
            TempItemEntryRelation.CopyTrackingFromItemJnlLine(ItemJnlLine);
            OnPostItemJnlLineAppliedToListOnBeforeTempItemEntryRelationInsert(TempItemEntryRelation, ItemJnlLine);
            TempItemEntryRelation.Insert();
            TempItemLedgEntry := TempApplyToItemLedgEntry;
            TempItemLedgEntry.Insert();
        until TempApplyToItemLedgEntry.Next() = 0;
    end;

    procedure AreAllItemEntriesCompletelyInvoiced(var TempApplyToItemLedgEntry: Record "Item Ledger Entry" temporary): Boolean
    var
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
    begin
        TempItemLedgerEntry.Copy(TempApplyToItemLedgEntry, true);
        TempItemLedgerEntry.SetRange("Completely Invoiced", false);
        exit(TempItemLedgerEntry.IsEmpty());
    end;

    local procedure AdjustQuantityRounding(var ItemJnlLine: Record "Item Journal Line"; var NonDistrQuantity: Decimal; NonDistrQuantityBase: Decimal)
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeAdjustQuantityRounding(ItemJnlLine, NonDistrQuantity, NonDistrQuantityBase, IsHandled);
        if IsHandled then
            exit;

        ItemTrackingMgt.AdjustQuantityRounding(
          NonDistrQuantity, ItemJnlLine.Quantity,
          NonDistrQuantityBase, ItemJnlLine."Quantity (Base)");
    end;

#if not CLEAN20
    [Obsolete('Moved to Advance Localization Pack for Czech.', '20.0')]
    [Scope('OnPrem')]
    procedure PostItemJnlLineAppliedToListTr(ItemJnlLine: Record "Item Journal Line"; var TempApplyToItemLedgEntry: Record "Item Ledger Entry" temporary; UndoQty: Decimal; UndoQtyBase: Decimal; var TempItemLedgEntry: Record "Item Ledger Entry" temporary; var TempItemEntryRelation: Record "Item Entry Relation" temporary)
    var
#if CLEAN19
        ItemTrackingSetup: Record "Item Tracking Setup";
#endif
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        NonDistrQuantity: Decimal;
        NonDistrQuantityBase: Decimal;
        ExpDate: Date;
        DummyEntriesExist: Boolean;
    begin
        // NAVCZ
        TempApplyToItemLedgEntry.FindSet(false, false); // Assertion: will fail if not found.
        ItemJnlLine.TestField("Entry Type", ItemJnlLine."Entry Type"::Transfer);
        NonDistrQuantity := UndoQty;
        NonDistrQuantityBase := UndoQtyBase;
        repeat
            ItemJnlLine."Applies-to Entry" := 0;
            // ItemJnlLine."Applies-to Entry" := TempApplyToEntryList."Entry No.";
            ItemJnlLine."Item Shpt. Entry No." := 0;
            ItemJnlLine."Quantity (Base)" := -TempApplyToItemLedgEntry.Quantity;
            ItemJnlLine."Serial No." := TempApplyToItemLedgEntry."Serial No.";
            ItemJnlLine."Lot No." := TempApplyToItemLedgEntry."Lot No.";
            ItemJnlLine."New Serial No." := TempApplyToItemLedgEntry."Serial No.";
            ItemJnlLine."New Lot No." := TempApplyToItemLedgEntry."Lot No.";

            if (ItemJnlLine."Serial No." <> '') or
               (ItemJnlLine."Lot No." <> '')
            then begin
#if CLEAN19
                ItemTrackingSetup."Serial No." := ItemJnlLine."Serial No.";
                ItemTrackingSetup."Lot No." := ItemJnlLine."Lot No.";
#endif
                ExpDate := ItemTrackingMgt.ExistingExpirationDate(
                    ItemJnlLine."Item No.",
                    ItemJnlLine."Variant Code",
#if CLEAN19                    
                    ItemTrackingSetup,
#else
                    ItemJnlLine."Lot No.",
                    ItemJnlLine."Serial No.",
#endif
                    false, DummyEntriesExist);
                ItemJnlLine."New Item Expiration Date" := ExpDate;
                ItemJnlLine."Item Expiration Date" := ExpDate;
            end;
            // Quantity is filled in according to UOM:
            ItemTrackingMgt.AdjustQuantityRounding(
              NonDistrQuantity, ItemJnlLine.Quantity,
              NonDistrQuantityBase, ItemJnlLine."Quantity (Base)");

            NonDistrQuantity -= ItemJnlLine.Quantity;
            NonDistrQuantityBase -= ItemJnlLine."Quantity (Base)";

            ItemJnlLine."Invoiced Quantity" := ItemJnlLine.Quantity;
            ItemJnlLine."Invoiced Qty. (Base)" := ItemJnlLine."Quantity (Base)";

            ItemJnlPostLine.xSetExtLotSN(true);
            ItemJnlPostLine.RunWithCheck(ItemJnlLine);
            ItemJnlPostLine.CollectItemEntryRelation(TempItemEntryRelation);

            TempItemLedgEntry := TempApplyToItemLedgEntry;
            TempItemLedgEntry.Insert();
        until TempApplyToItemLedgEntry.Next() = 0;
        // NAVCZ
    end;

#endif
    procedure CollectItemLedgEntries(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; SourceType: Integer; DocumentNo: Code[20]; LineNo: Integer; BaseQty: Decimal; EntryRef: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        TempItemLedgEntry.Reset();
        if not TempItemLedgEntry.IsEmpty() then
            TempItemLedgEntry.DeleteAll();
        if EntryRef <> 0 then begin
            ItemLedgEntry.Get(EntryRef); // Assertion: will fail if no entry exists.
            TempItemLedgEntry := ItemLedgEntry;
            TempItemLedgEntry.Insert();
        end else begin
            if SourceType in [DATABASE::"Sales Shipment Line",
                              DATABASE::"Return Shipment Line",
                              DATABASE::"Service Shipment Line",
                              DATABASE::"Posted Assembly Line",
                              DATABASE::"Transfer Shipment Line"] // NAVCZ
            then
                BaseQty := BaseQty * -1;
            CheckMissingItemLedgers(TempItemLedgEntry, SourceType, DocumentNo, LineNo, BaseQty);
        end;
    end;

    local procedure CheckMissingItemLedgers(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; SourceType: Integer; DocumentNo: Code[20]; LineNo: Integer; BaseQty: Decimal)
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckMissingItemLedgers(TempItemLedgEntry, SourceType, DocumentNo, LineNo, BaseQty, IsHandled);
        if IsHandled then
            exit;

        if not ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry, SourceType, 0, DocumentNo, '', 0, LineNo, BaseQty) then
            Error(Text013, LineNo);
    end;

    local procedure UndoValuePostingFromJob(ItemJnlLine: Record "Item Journal Line"; ItemApplicationEntry: Record "Item Application Entry"; var TempApplyToItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUndoValuePostingFromJob(ItemJnlLine, IsHandled);
        if IsHandled then
            exit;

        if ItemJnlLine."Job No." = '' then
            exit;

        Clear(ItemJnlPostLine);
        if TempApplyToItemLedgEntry.Positive then begin
            FindItemReceiptApplication(ItemApplicationEntry, TempApplyToItemLedgEntry."Entry No.");
            ItemJnlPostLine.UndoValuePostingWithJob(TempApplyToItemLedgEntry."Entry No.", ItemApplicationEntry."Outbound Item Entry No.");
            FindItemShipmentApplication(ItemApplicationEntry, ItemJnlLine."Item Shpt. Entry No.");
            ItemJnlPostLine.UndoValuePostingWithJob(ItemApplicationEntry."Inbound Item Entry No.", ItemJnlLine."Item Shpt. Entry No.");
        end else begin
            FindItemShipmentApplication(ItemApplicationEntry, TempApplyToItemLedgEntry."Entry No.");
            ItemJnlPostLine.UndoValuePostingWithJob(ItemApplicationEntry."Inbound Item Entry No.", TempApplyToItemLedgEntry."Entry No.");
            FindItemReceiptApplication(ItemApplicationEntry, ItemJnlLine."Item Shpt. Entry No.");
            ItemJnlPostLine.UndoValuePostingWithJob(ItemJnlLine."Item Shpt. Entry No.", ItemApplicationEntry."Outbound Item Entry No.");
        end;
    end;

    procedure UpdatePurchLine(PurchLine: Record "Purchase Line"; UndoQty: Decimal; UndoQtyBase: Decimal; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        xPurchLine: Record "Purchase Line";
        PurchSetup: Record "Purchases & Payables Setup";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdatePurchLine(PurchLine, UndoQty, UndoQtyBase, TempUndoneItemLedgEntry, IsHandled);
        if IsHandled then
            exit;

        PurchSetup.Get();
        with PurchLine do begin
            xPurchLine := PurchLine;
            case "Document Type" of
                "Document Type"::"Return Order":
                    begin
                        "Return Qty. Shipped" := "Return Qty. Shipped" - UndoQty;
                        "Return Qty. Shipped (Base)" := "Return Qty. Shipped (Base)" - UndoQtyBase;
                        InitOutstanding;
                        if PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Blank then
                            "Qty. to Receive" := 0
                        else
                            InitQtyToShip;
                        OnUpdatePurchLineOnAfterSetQtyToShip(PurchLine);
                        UpdateWithWarehouseReceive;
                    end;
                "Document Type"::Order:
                    begin
                        "Quantity Received" := "Quantity Received" - UndoQty;
                        "Qty. Received (Base)" := "Qty. Received (Base)" - UndoQtyBase;
                        InitOutstanding;
                        if PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Blank then
                            "Qty. to Receive" := 0
                        else
                            InitQtyToReceive;
                        OnUpdatePurchLineOnAfterSetQtyToReceive(PurchLine);
                        UpdateWithWarehouseReceive;
                    end;
                else
                    FieldError("Document Type");
            end;
            OnUpdatePurchLineOnBeforePurchLineModify(PurchLine);
            Modify;
            RevertPostedItemTrackingFromPurchLine(PurchLine, TempUndoneItemLedgEntry);
            xPurchLine."Quantity (Base)" := 0;
            PurchLineReserveVerifyQuantity(PurchLine, xPurchLine);

            UpdateWarehouseRequest(DATABASE::"Purchase Line", "Document Type".AsInteger(), "Document No.", "Location Code");

            OnAfterUpdatePurchline(PurchLine);
        end;
    end;

    local procedure RevertPostedItemTrackingFromPurchLine(PurchLine: Record "Purchase Line"; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeRevertPostedItemTrackingFromPurchLine(PurchLine, TempUndoneItemLedgEntry, IsHandled);
        if IsHandled then
            exit;

        RevertPostedItemTracking(TempUndoneItemLedgEntry, PurchLine."Expected Receipt Date", false);
    end;

    local procedure PurchLineReserveVerifyQuantity(PurchLine: Record "Purchase Line"; xPurchLine: Record "Purchase Line")
    var
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforePurchLineReserveVerifyQuantity(PurchLine, xPurchLine, IsHandled);
        if IsHandled then
            exit;

        PurchLineReserve.VerifyQuantity(PurchLine, xPurchLine);
    end;

    procedure UpdateSalesLine(SalesLine: Record "Sales Line"; UndoQty: Decimal; UndoQtyBase: Decimal; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        xSalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateSalesLine(SalesLine, UndoQty, UndoQtyBase, TempUndoneItemLedgEntry, IsHandled);
        if IsHandled then
            exit;

        SalesSetup.Get();
        with SalesLine do begin
            xSalesLine := SalesLine;
            case "Document Type" of
                "Document Type"::"Return Order":
                    begin
                        "Return Qty. Received" := "Return Qty. Received" - UndoQty;
                        "Return Qty. Received (Base)" := "Return Qty. Received (Base)" - UndoQtyBase;
                        OnUpdateSalesLineOnBeforeInitOustanding(SalesLine, UndoQty, UndoQtyBase);
                        InitOutstanding;
                        if SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Blank then
                            "Qty. to Ship" := 0
                        else
                            InitQtyToReceive;
                        UpdateWithWarehouseShip;
                    end;
                "Document Type"::Order:
                    begin
                        "Quantity Shipped" := "Quantity Shipped" - UndoQty;
                        "Qty. Shipped (Base)" := "Qty. Shipped (Base)" - UndoQtyBase;
                        OnUpdateSalesLineOnBeforeInitOustanding(SalesLine, UndoQty, UndoQtyBase);
                        InitOutstanding;
                        if SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Blank then
                            "Qty. to Ship" := 0
                        else
                            InitQtyToShip;
                        UpdateWithWarehouseShip;
                    end;
                else
                    FieldError("Document Type");
            end;
            OnUpdateSalesLineOnBeforeSalesLineModify(SalesLine);
            Modify;
            RevertPostedItemTrackingFromSalesLine(SalesLine, TempUndoneItemLedgEntry);
            xSalesLine."Quantity (Base)" := 0;
            SalesLineReserveVerifyQuantity(SalesLine, xSalesLine);

            UpdateWarehouseRequest(DATABASE::"Sales Line", "Document Type".AsInteger(), "Document No.", "Location Code");

            OnAfterUpdateSalesLine(SalesLine);
        end;
    end;

    local procedure RevertPostedItemTrackingFromSalesLine(SalesLine: Record "Sales Line"; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeRevertPostedItemTrackingFromSalesLine(SalesLine, TempUndoneItemLedgEntry, IsHandled);
        if IsHandled then
            exit;

        RevertPostedItemTracking(TempUndoneItemLedgEntry, SalesLine."Shipment Date", false);
    end;

    local procedure SalesLineReserveVerifyQuantity(SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    var
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSalesLineReserveVerifyQuantity(SalesLine, xSalesLine, IsHandled);
        if IsHandled then
            exit;

        SalesLineReserve.VerifyQuantity(SalesLine, xSalesLine);
    end;

    procedure UpdateServLine(ServLine: Record "Service Line"; UndoQty: Decimal; UndoQtyBase: Decimal; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        xServLine: Record "Service Line";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateServLine(ServLine, UndoQty, UndoQtyBase, TempUndoneItemLedgEntry, IsHandled);
        if IsHandled then
            exit;

        xServLine := ServLine;
        case ServLine."Document Type" of
            ServLine."Document Type"::Order:
                begin
                    ServLine."Quantity Shipped" := ServLine."Quantity Shipped" - UndoQty;
                    ServLine."Qty. Shipped (Base)" := ServLine."Qty. Shipped (Base)" - UndoQtyBase;
                    ServLine."Qty. to Consume" := 0;
                    ServLine."Qty. to Consume (Base)" := 0;
                    ServLine.InitOutstanding();
                    ServLine.InitQtyToShip();
                end;
            else
                ServLine.FieldError("Document Type");
        end;
        ServLine.Modify();
        RevertPostedItemTrackingFromServiceLine(ServLine, TempUndoneItemLedgEntry);
        xServLine."Quantity (Base)" := 0;
        ServiceLineReserveVerifyQuantity(ServLine, xServLine);

        UpdateWarehouseRequest(
            DATABASE::"Service Line", ServLine."Document Type".AsInteger(), ServLine."Document No.", ServLine."Location Code");

        OnAfterUpdateServLine(ServLine);
    end;

    local procedure RevertPostedItemTrackingFromServiceLine(ServiceLine: Record "Service Line"; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeRevertPostedItemTrackingFromServiceLine(ServiceLine, TempUndoneItemLedgEntry, IsHandled);
        if IsHandled then
            exit;

        RevertPostedItemTracking(TempUndoneItemLedgEntry, ServiceLine."Posting Date", false);
    end;

    local procedure ServiceLineReserveVerifyQuantity(ServiceLine: Record "Service Line"; xServiceLine: Record "Service Line")
    var
        ServiceLineReserve: Codeunit "Service Line-Reserve";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeServiceLineReserveVerifyQuantity(ServiceLine, xServiceLine, IsHandled);
        if IsHandled then
            exit;

        ServiceLineReserve.VerifyQuantity(ServiceLine, xServiceLine);
    end;

    procedure UpdateServLineCnsm(var ServLine: Record "Service Line"; UndoQty: Decimal; UndoQtyBase: Decimal; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        ServHeader: Record "Service Header";
        xServLine: Record "Service Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ServCalcDiscount: Codeunit "Service-Calc. Discount";
    begin
        with ServLine do begin
            xServLine := ServLine;
            case "Document Type" of
                "Document Type"::Order:
                    begin
                        "Quantity Consumed" := "Quantity Consumed" - UndoQty;
                        "Qty. Consumed (Base)" := "Qty. Consumed (Base)" - UndoQtyBase;
                        "Quantity Shipped" := "Quantity Shipped" - UndoQty;
                        "Qty. Shipped (Base)" := "Qty. Shipped (Base)" - UndoQtyBase;
                        "Qty. to Invoice" := 0;
                        "Qty. to Invoice (Base)" := 0;
                        InitOutstanding;
                        InitQtyToShip;
                        Validate("Line Discount %");
                        ConfirmAdjPriceLineChange;
                        Modify;

                        SalesSetup.Get();
                        if SalesSetup."Calc. Inv. Discount" then begin
                            ServHeader.Get("Document Type", "Document No.");
                            ServCalcDiscount.CalculateWithServHeader(ServHeader, ServLine, ServLine);
                        end;
                    end;
                else
                    FieldError("Document Type");
            end;
            Modify;
            RevertPostedItemTracking(TempUndoneItemLedgEntry, "Posting Date", false);
            xServLine."Quantity (Base)" := 0;
            ServiceLineCnsmReserveVerifyQuantity(ServLine, xServLine);
        end;
    end;

    local procedure ServiceLineCnsmReserveVerifyQuantity(ServiceLine: Record "Service Line"; xServiceLine: Record "Service Line")
    var
        ServiceLineReserve: Codeunit "Service Line-Reserve";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeServiceLineCnsmReserveVerifyQuantity(ServiceLine, xServiceLine, IsHandled);
        if IsHandled then
            exit;

        ServiceLineReserve.VerifyQuantity(ServiceLine, xServiceLine);
    end;

    procedure RevertPostedItemTracking(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; AvailabilityDate: Date; RevertInvoiced: Boolean)
    var
        TrackingSpecification: Record "Tracking Specification";
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        QtyToRevert: Decimal;
        IsHandled: Boolean;
    begin
        with TempItemLedgEntry do
            if Find('-') then begin
                repeat
                    TrackingSpecification.Get("Entry No.");
                    QtyToRevert := TrackingSpecification."Quantity Invoiced (Base)";

                    IsHandled := false;
                    OnRevertPostedItemTrackingOnBeforeUpdateReservEntry(TempItemLedgEntry, TrackingSpecification, IsHandled);
                    if not IsHandled then
                        if not TrackingIsATO(TrackingSpecification) then begin
                            ReservEntry.Init();
                            ReservEntry.TransferFields(TrackingSpecification);
                            if RevertInvoiced then begin
                                ReservEntry."Quantity (Base)" := QtyToRevert;
                                ReservEntry."Quantity Invoiced (Base)" -= QtyToRevert;
                            end;
                            ReservEntry.Validate("Quantity (Base)");
                            ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Surplus;
                            if ReservEntry.Positive then
                                ReservEntry."Expected Receipt Date" := AvailabilityDate
                            else
                                ReservEntry."Shipment Date" := AvailabilityDate;
                            ReservEntry."Entry No." := 0;
                            ReservEntry.UpdateItemTracking();
                            OnRevertPostedItemTrackingOnBeforeReservEntryInsert(ReservEntry, TempItemLedgEntry);
                            ReservEntry.Insert();

                            TempReservEntry := ReservEntry;
                            TempReservEntry.Insert();
                        end;

                    if RevertInvoiced and (TrackingSpecification."Quantity (Base)" <> QtyToRevert) then begin
                        TrackingSpecification."Quantity (Base)" -= QtyToRevert;
                        TrackingSpecification."Quantity Handled (Base)" -= QtyToRevert;
                        TrackingSpecification."Quantity Invoiced (Base)" := 0;
                        TrackingSpecification."Buffer Value1" -= QtyToRevert;
                        TrackingSpecification.Modify();
                    end else
                        TrackingSpecification.Delete();
                until Next() = 0;
                ReservEngineMgt.UpdateOrderTracking(TempReservEntry);
            end;
        OnAfterRevertPostedItemTracking(TempReservEntry);
    end;

    procedure PostItemJnlLine(var ItemJnlLine: Record "Item Journal Line")
    var
        ItemJnlLine2: Record "Item Journal Line";
        PostJobConsumptionBeforePurch: Boolean;
        IsHandled: Boolean;
    begin
        Clear(ItemJnlLine2);
        ItemJnlLine2 := ItemJnlLine;

        if ItemJnlLine2."Job No." <> '' then begin
            IsHandled := false;
            OnPostItemJnlLineOnBeforePostItemJnlLineForJob(ItemJnlLine2, IsHandled, ItemJnlLine, PostJobConsumptionBeforePurch);
            if not IsHandled then
                PostJobConsumptionBeforePurch := PostItemJnlLineForJob(ItemJnlLine, ItemJnlLine2);
        end;

        ItemJnlPostLine.Run(ItemJnlLine);

        IsHandled := false;
        OnPostItemJnlLineOnBeforePostJobConsumption(ItemJnlLine2, IsHandled);
        if not IsHandled then
            if ItemJnlLine2."Job No." <> '' then
                if not PostJobConsumptionBeforePurch then begin
                    SetItemJnlLineAppliesToEntry(ItemJnlLine2, ItemJnlLine."Item Shpt. Entry No.");
                    ItemJnlPostLine.Run(ItemJnlLine2);
                end;
    end;

    local procedure PostItemJnlLineForJob(var ItemJnlLine: Record "Item Journal Line"; var ItemJnlLine2: Record "Item Journal Line"): Boolean
    var
        Job: Record Job;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforePostItemJnlLineForJob(ItemJnlLine, IsHandled);
        if IsHandled then
            exit;

        ItemJnlLine2."Entry Type" := ItemJnlLine2."Entry Type"::"Negative Adjmt.";
        Job.Get(ItemJnlLine2."Job No.");
        ItemJnlLine2."Source No." := Job."Bill-to Customer No.";
        ItemJnlLine2."Source Type" := ItemJnlLine2."Source Type"::Customer;
        ItemJnlLine2."Discount Amount" := 0;
        if ItemJnlLine2.IsPurchaseReturn then begin
            ItemJnlPostLine.Run(ItemJnlLine2);
            SetItemJnlLineAppliesToEntry(ItemJnlLine, ItemJnlLine2."Item Shpt. Entry No.");
            exit(true);
        end;
        exit(false);
    end;

    local procedure SetItemJnlLineAppliesToEntry(var ItemJnlLine: Record "Item Journal Line"; AppliesToEntry: Integer)
    var
        Item: Record Item;
    begin
        Item.Get(ItemJnlLine."Item No.");
        if Item.Type = Item.Type::Inventory then
            ItemJnlLine."Applies-to Entry" := AppliesToEntry;
    end;

    local procedure TrackingIsATO(TrackingSpecification: Record "Tracking Specification"): Boolean
    var
        ATOLink: Record "Assemble-to-Order Link";
    begin
        with TrackingSpecification do begin
            if "Source Type" <> DATABASE::"Sales Line" then
                exit(false);
            if not "Prohibit Cancellation" then
                exit(false);

            ATOLink.SetCurrentKey(Type, "Document Type", "Document No.", "Document Line No.");
            ATOLink.SetRange(Type, ATOLink.Type::Sale);
            ATOLink.SetRange("Document Type", "Source Subtype");
            ATOLink.SetRange("Document No.", "Source ID");
            ATOLink.SetRange("Document Line No.", "Source Ref. No.");
            exit(not ATOLink.IsEmpty);
        end;
    end;

#if not CLEAN20
    [Obsolete('Moved to Advance Localization Pack for Czech.', '20.0')]
    [Scope('OnPrem')]
    procedure UpdateTransferLine(TransferLine: Record "Transfer Line"; UndoQty: Decimal; UndoQtyBase: Decimal; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary)
    var
        TransferLine1: Record "Transfer Line";
        TransferLine2: Record "Transfer Line";
        ResEntry: Record "Reservation Entry";
        ItemEntryRel: Record "Item Entry Relation";
        TransferLineReserve: Codeunit "Transfer Line-Reserve";
        Line: Integer;
        ResEntryNo: Integer;
    begin
        // NAVCZ
        with TransferLine do begin
            TransferLine1 := TransferLine;
            "Quantity Shipped" := "Quantity Shipped" - UndoQty;
            "Qty. Shipped (Base)" := "Qty. Shipped (Base)" - UndoQtyBase;
            InitQtyInTransit;
            InitOutstandingQty;
            InitQtyToShip;
            InitQtyToReceive;
            Modify;
            TransferLine1."Quantity (Base)" := 0;
            TransferLineReserve.VerifyQuantity(TransferLine, TransferLine1);

            if TempUndoneItemLedgEntry.FindSet(false, false) then
                repeat
                    if (TempUndoneItemLedgEntry."Serial No." <> '') or (TempUndoneItemLedgEntry."Lot No." <> '') then begin
                        ResEntry.Reset();
                        ResEntry.SetCurrentKey("Source ID");
                        ResEntry.SetRange("Source Type", DATABASE::"Transfer Line");
                        ResEntry.SetRange("Source ID", "Document No.");
                        ResEntry.SetRange("Source Batch Name", '');
                        ResEntry.SetRange("Source Prod. Order Line", "Line No.");
                        ResEntry.SetRange("Serial No.", TempUndoneItemLedgEntry."Serial No.");
                        ResEntry.SetRange("Lot No.", TempUndoneItemLedgEntry."Lot No.");
                        while ResEntry.FindFirst do begin
                            if ResEntry."Source Ref. No." <> 0 then
                                Line := ResEntry."Source Ref. No.";
                            ResEntry.Delete();
                        end;
                        if ItemEntryRel.Get(TempUndoneItemLedgEntry."Entry No.") then begin
                            ItemEntryRel.Undo := true;
                            ItemEntryRel.Modify();
                        end;

                        ResEntry.Reset();
                        Clear(ResEntryNo);
                        if ResEntry.FindLast() then
                            ResEntryNo := ResEntry."Entry No.";
                        ResEntryNo += 1;
                        ResEntry.Init();
                        ResEntry."Entry No." := ResEntryNo;
                        ResEntry.Positive := false;
                        ResEntry."Item No." := TempUndoneItemLedgEntry."Item No.";
                        ResEntry."Location Code" := "Transfer-from Code";
                        ResEntry."Quantity (Base)" := TempUndoneItemLedgEntry.Quantity;
                        ResEntry."Reservation Status" := ResEntry."Reservation Status"::Surplus;
                        ResEntry."Creation Date" := Today;
                        ResEntry."Source Type" := 5741;
                        ResEntry."Source Subtype" := 0;
                        ResEntry."Source ID" := "Document No.";
                        ResEntry."Source Ref. No." := "Line No.";
                        ResEntry."Expected Receipt Date" := 0D;
                        ResEntry."Shipment Date" := "Shipment Date";
                        ResEntry."Created By" := UserId;
                        ResEntry."Qty. per Unit of Measure" := TempUndoneItemLedgEntry."Qty. per Unit of Measure";
                        if TempUndoneItemLedgEntry."Serial No." <> '' then
                            ResEntry.Quantity := -1
                        else
                            ResEntry.Quantity := ResEntry."Quantity (Base)" / ResEntry."Qty. per Unit of Measure";
                        ResEntry."Qty. to Handle (Base)" := ResEntry."Quantity (Base)";
                        ResEntry."Qty. to Invoice (Base)" := ResEntry."Quantity (Base)";
                        ResEntry."Lot No." := TempUndoneItemLedgEntry."Lot No.";
                        ResEntry."Variant Code" := TempUndoneItemLedgEntry."Variant Code";
                        ResEntry."Serial No." := TempUndoneItemLedgEntry."Serial No.";
                        ResEntry.Insert();
                        ResEntryNo += 1;
                        ResEntry."Entry No." := ResEntryNo;
                        ResEntry.Positive := true;
                        ResEntry."Location Code" := "Transfer-to Code";
                        ResEntry."Quantity (Base)" := -ResEntry."Quantity (Base)";
                        ResEntry."Source Subtype" := 1;
                        ResEntry."Expected Receipt Date" := "Receipt Date";
                        ResEntry."Shipment Date" := 0D;
                        ResEntry.Quantity := -ResEntry.Quantity;
                        ResEntry."Qty. to Handle (Base)" := ResEntry."Quantity (Base)";
                        ResEntry."Qty. to Invoice (Base)" := ResEntry."Quantity (Base)";
                        ResEntry.Insert();
                    end;
                until TempUndoneItemLedgEntry.Next() = 0;
            if Line <> 0 then
                TransferLine2.SetRange("Line No.", Line);
            TransferLine2.SetRange("Document No.", "Document No.");
            TransferLine2.SetRange("Derived From Line No.", "Line No.");
            TransferLine2.SetRange(Quantity, UndoQty);
            TransferLine2.FindFirst();
            TransferLine2.Delete(true);
        end;
    end;

#endif
    local procedure IsSNRequired(ItemJnlLine: Record "Item Journal Line"): Boolean
    var
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        // NAVCZ
        if Item.Get(ItemJnlLine."Item No.") then
            if ItemTrackingCode.Get(Item."Item Tracking Code") then
                exit(ItemTrackingCode."SN Specific Tracking");
    end;

    procedure TransferSourceValues(var ItemJnlLine: Record "Item Journal Line"; EntryNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
    begin
        with ItemLedgEntry do begin
            Get(EntryNo);
            ItemJnlLine."Source Type" := "Source Type";
            ItemJnlLine."Source No." := "Source No.";
            ItemJnlLine."Country/Region Code" := "Country/Region Code";
        end;

        with ValueEntry do begin
            SetRange("Item Ledger Entry No.", EntryNo);
            FindFirst();
            ItemJnlLine."Source Posting Group" := "Source Posting Group";
            ItemJnlLine."Salespers./Purch. Code" := "Salespers./Purch. Code";
        end;
    end;

    procedure ReapplyJobConsumption(ItemRcptEntryNo: Integer)
    var
        ItemApplnEntry: Record "Item Application Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeReapplyJobConsumption(ItemRcptEntryNo, IsHandled);
        if IsHandled then
            exit;

        // Purchase receipt and job consumption are reapplied with with fixed cost application
        FindItemReceiptApplication(ItemApplnEntry, ItemRcptEntryNo);
        ItemJnlPostLine.UnApply(ItemApplnEntry);
        ItemLedgEntry.Get(ItemApplnEntry."Inbound Item Entry No.");
        ItemJnlPostLine.ReApply(ItemLedgEntry, ItemApplnEntry."Outbound Item Entry No.");
    end;

    procedure FindItemReceiptApplication(var ItemApplnEntry: Record "Item Application Entry"; ItemRcptEntryNo: Integer)
    begin
        ItemApplnEntry.Reset();
        ItemApplnEntry.SetRange("Inbound Item Entry No.", ItemRcptEntryNo);
        ItemApplnEntry.SetFilter("Item Ledger Entry No.", '<>%1', ItemRcptEntryNo);
        ItemApplnEntry.FindFirst();
    end;

    procedure FindItemShipmentApplication(var ItemApplnEntry: Record "Item Application Entry"; ItemShipmentEntryNo: Integer)
    begin
        ItemApplnEntry.Reset();
        ItemApplnEntry.SetRange("Item Ledger Entry No.", ItemShipmentEntryNo);
        ItemApplnEntry.FindFirst();
    end;

    procedure UpdatePurchaseLineOverRcptQty(PurchaseLine: Record "Purchase Line"; OverRcptQty: Decimal)
    begin
        PurchaseLine.Get(PurchaseLine."Document Type"::Order, PurchaseLine."Document No.", PurchaseLine."Line No.");
        PurchaseLine."Over-Receipt Quantity" += OverRcptQty;
        PurchaseLine.Modify();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRevertPostedItemTracking(var TempReservEntry: Record "Reservation Entry" temporary)
    begin
    end;

    local procedure UpdateWarehouseRequest(SourceType: Integer; SourceSubtype: Integer; SourceNo: Code[20]; LocationCode: Code[10])
    var
        WarehouseRequest: Record "Warehouse Request";
    begin
        with WarehouseRequest do begin
            SetSourceFilter(SourceType, SourceSubtype, SourceNo);
            SetRange("Location Code", LocationCode);
            if not IsEmpty() then
                ModifyAll("Completely Handled", false);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateSalesLine(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdatePurchline(var PurchLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateServLine(var ServLine: Record "Service Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAdjustQuantityRounding(var ItemJnlLine: Record "Item Journal Line"; var NonDistrQuantity: Decimal; NonDistrQuantityBase: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckMissingItemLedgers(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; SourceType: Integer; DocumentNo: Code[20]; LineNo: Integer; BaseQty: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckItemLedgEntries(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; LineRef: Integer; InvoicedEntry: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckValueEntries(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; LineRef: Integer; InvoicedEntry: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TempApplyToItemLedgEntry: Record "Item Ledger Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostItemJnlLineForJob(var ItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReapplyJobConsumption(ItemRcptEntryNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRevertPostedItemTrackingFromPurchLine(PurchLine: Record "Purchase Line"; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchLineReserveVerifyQuantity(PurchLine: Record "Purchase Line"; xPurchLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRevertPostedItemTrackingFromSalesLine(SalesLine: Record "Sales Line"; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesLineReserveVerifyQuantity(SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRevertPostedItemTrackingFromServiceLine(ServiceLine: Record "Service Line"; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeServiceLineReserveVerifyQuantity(ServiceLine: Record "Service Line"; xServiceLine: Record "Service Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeServiceLineCnsmReserveVerifyQuantity(ServiceLine: Record "Service Line"; xServiceLine: Record "Service Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestAllTransactions(UndoType: Integer; UndoID: Code[20]; UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestPostedInvtPickLine(UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; var IsHandled: Boolean; UndoType: Integer; UndoID: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestPostedInvtPutAwayLine(UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; var IsHandled: Boolean; UndoType: Integer; UndoID: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestPostedWhseShipmentLine(UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; var IsHandled: Boolean; UndoType: Integer; UndoID: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestRgstrdWhseActivityLine(UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestWarehouseActivityLine(UndoType: Option; UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestWarehouseEntry(UndoLineNo: Integer; var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestWarehouseReceiptLine(UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestWarehouseShipmentLine(UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestWhseWorksheetLine(UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUndoValuePostingFromJob(var ItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckItemLedgEntriesOnBeforeCheckTempItemLedgEntry(var TempItemLedgEntry: Record "Item Ledger Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostItemJnlLineAppliedToListOnBeforeTempItemEntryRelationInsert(var TempItemEntryRelation: Record "Item Entry Relation" temporary; ItemJournalLine: Record "Item Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostItemJnlLineAppliedToListOnAfterPostItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TempApplyToItemLedgEntry: Record "Item Ledger Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateSalesLineOnBeforeInitOustanding(var SalesLine: Record "Sales Line"; var UndoQty: Decimal; var UndoQtyBase: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostItemJnlLineOnBeforePostJobConsumption(var ItemJnlLine2: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostItemJnlLineOnBeforePostItemJnlLineForJob(var ItemJnlLine2: Record "Item Journal Line"; var IsHandled: Boolean; var ItemJnlLine: Record "Item Journal Line"; var PostJobConsumptionBeforePurch: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestWarehouseActivityLine2(var WarehouseActivityLine: Record "Warehouse Activity Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRevertPostedItemTrackingOnBeforeReservEntryInsert(var ReservationEntry: Record "Reservation Entry"; var TempItemLedgerEntry: Record "Item Ledger Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnTestWarehouseEntryOnAfterSetFilters(var WarehouseEntry: Record "Warehouse Entry"; PostedWhseReceiptLine: Record "Posted Whse. Receipt Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdatePurchLineOnAfterSetQtyToShip(var PurchLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdatePurchLineOnAfterSetQtyToReceive(var PurchLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdatePurchLineOnBeforePurchLineModify(var PurchLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateSalesLineOnBeforeSalesLineModify(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateServLine(var ServiceLine: Record "Service Line"; var UndoQty: Decimal; var UndoQtyBase: Decimal; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdatePurchLine(PurchaseLine: Record "Purchase Line"; var UndoQty: Decimal; var UndoQtyBase: Decimal; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTestAllTransactions(UndoType: Integer; UndoID: Code[20]; UndoLineNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateSalesLine(SalesLine: Record "Sales Line"; var UndoQty: Decimal; var UndoQtyBase: Decimal; var TempUndoneItemLedgEntry: Record "Item Ledger Entry" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRevertPostedItemTrackingOnBeforeUpdateReservEntry(var TempItemLedgEntry: Record "Item Ledger Entry" temporary; var TrackingSpecification: Record "Tracking Specification"; var IsHandled: Boolean)
    begin
    end;
}
