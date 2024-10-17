codeunit 781 "Sales Pipeline Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    procedure DrillDown(var BusinessChartBuffer: Record "Business Chart Buffer"; var SalesCycleStage: Record "Sales Cycle Stage")
    var
        OppEntry: Record "Opportunity Entry";
    begin
        if SalesCycleStage.FindSet then begin
            SalesCycleStage.Next(BusinessChartBuffer."Drill-Down X Index");
            OppEntry.SetRange("Sales Cycle Code", SalesCycleStage."Sales Cycle Code");
            OppEntry.SetRange("Sales Cycle Stage", SalesCycleStage.Stage);
            PAGE.Run(PAGE::"Opportunity Entries", OppEntry);
        end;
    end;

    procedure GetOppEntryCount(SalesCycleCode: Code[10]; SalesCycleStage: Integer): Integer
    var
        OppEntry: Record "Opportunity Entry";
    begin
        OppEntry.SetRange("Sales Cycle Code", SalesCycleCode);
        OppEntry.SetRange("Sales Cycle Stage", SalesCycleStage);
        exit(OppEntry.Count);
    end;

    procedure InsertTempSalesCycleStage(var TempSalesCycleStage: Record "Sales Cycle Stage" temporary; SalesCycle: Record "Sales Cycle")
    var
        SourceSalesCycleStage: Record "Sales Cycle Stage";
    begin
        TempSalesCycleStage.Reset();
        TempSalesCycleStage.DeleteAll();

        SourceSalesCycleStage.SetRange("Sales Cycle Code", SalesCycle.Code);
        if SourceSalesCycleStage.FindSet then
            repeat
                TempSalesCycleStage := SourceSalesCycleStage;
                TempSalesCycleStage.Insert();
            until SourceSalesCycleStage.Next() = 0;
    end;

    procedure SetDefaultSalesCycle(var SalesCycle: Record "Sales Cycle"; var NextSalesCycleAvailable: Boolean; var PrevSalesCycleAvailable: Boolean): Boolean
    begin
        if not SalesCycle.FindFirst then
            exit(false);

        NextSalesCycleAvailable := TryNextSalesCycle(SalesCycle);
        PrevSalesCycleAvailable := TryPrevSalesCycle(SalesCycle);
        exit(true);
    end;

    procedure SetPrevNextSalesCycle(var SalesCycle: Record "Sales Cycle"; var NextSalesCycleAvailable: Boolean; var PrevSalesCycleAvailable: Boolean; Step: Integer)
    begin
        SalesCycle.Next(Step);
        NextSalesCycleAvailable := TryNextSalesCycle(SalesCycle);
        PrevSalesCycleAvailable := TryPrevSalesCycle(SalesCycle);
    end;

    local procedure TryNextSalesCycle(CurrentSalesCycle: Record "Sales Cycle"): Boolean
    var
        NextSalesCycle: Record "Sales Cycle";
    begin
        NextSalesCycle := CurrentSalesCycle;
        NextSalesCycle.Find('=><');
        exit(NextSalesCycle.Next <> 0);
    end;

    local procedure TryPrevSalesCycle(CurrentSalesCycle: Record "Sales Cycle"): Boolean
    var
        PrevSalesCycle: Record "Sales Cycle";
    begin
        PrevSalesCycle := CurrentSalesCycle;
        PrevSalesCycle.Find('=><');
        exit(PrevSalesCycle.Next(-1) <> 0);
    end;

    [Scope('OnPrem')]
    procedure UpdateData(var BusinessChartBuffer: Record "Business Chart Buffer"; var TempSalesCycleStage: Record "Sales Cycle Stage" temporary; SalesCycle: Record "Sales Cycle")
    var
        I: Integer;
    begin
        with BusinessChartBuffer do begin
            Initialize;
            AddIntegerMeasure(TempSalesCycleStage.FieldCaption("No. of Opportunities"), 1, "Chart Type"::Funnel);
            SetXAxis(TempSalesCycleStage.TableCaption, "Data Type"::String);
            InsertTempSalesCycleStage(TempSalesCycleStage, SalesCycle);
            if TempSalesCycleStage.FindSet then begin
                repeat
                    I += 1;
                    AddColumn(TempSalesCycleStage.Description);
                    SetValueByIndex(0, I - 1, GetOppEntryCount(TempSalesCycleStage."Sales Cycle Code", TempSalesCycleStage.Stage));
                until TempSalesCycleStage.Next() = 0;
            end;
        end;
    end;
}

