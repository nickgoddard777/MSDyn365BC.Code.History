namespace Microsoft.Finance.FinancialReports;

using Microsoft.Finance.GeneralLedger.Setup;
using Microsoft.Finance.GeneralLedger.Account;

page 104 "Account Schedule"
{
    AboutTitle = 'About (Financial Report) Row Definition';
    AboutText = 'A row definition in financial reports provide a place for calculations that can''t be made directly in the chart of accounts. For example, you can create subtotals for groups of accounts and then include that total in other totals. You can also calculate intermediate steps that aren''t shown in the final report.';
    AutoSplitKey = true;
    AnalysisModeEnabled = false;
    Caption = '(Financial Report) Row Definition';
    DataCaptionFields = "Schedule Name";
    MultipleNewLines = true;
    PageType = Worksheet;
    SourceTable = "Acc. Schedule Line";
    RefreshOnActivate = true;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            field(CurrentSchedName; CurrentSchedName)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Name';
                Lookup = true;
                ToolTip = 'Specifies the unique name (code) of the financial report row definition.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    exit(AccSchedManagement.LookupName(CurrentSchedName, Text));
                end;

                trigger OnValidate()
                begin
                    AccSchedManagement.CheckName(CurrentSchedName);
                    CurrentSchedNameOnAfterValidate();
                end;
            }
            repeater(Control1)
            {
                IndentationColumn = Rec.Indentation;
                IndentationControls = Description;
                ShowCaption = false;
                field("Row No."; Rec."Row No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a number that identifies the line.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Style = Strong;
                    StyleExpr = Rec.Bold;
                    ToolTip = 'Specifies text that will appear on the financial report line.';
                }
                field("Totaling Type"; Rec."Totaling Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the totaling type for the financial report line. The type determines which accounts within the totaling interval you specify in the Totaling field will be totaled. ';
                }
                field("Extension Source Table"; Rec."Extension Source Table")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the extension source table associated with account schedule line.';
                }
                field(Totaling; TotalingDisplayed)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Totaling';
                    ToolTip = 'Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.';
                    Lookup = true;

                    trigger OnValidate()
                    begin
                        if Rec."Totaling Type" = Rec."Totaling Type"::"Account Category" then
                            TotalingDisplayed := GetAccountCategoryTotalingToDisplay()
                        else
                            Rec.Validate(Totaling, TotalingDisplayed);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AccScheduleLine: Record "Acc. Schedule Line";
                        GLSetup: Record "General Ledger Setup";
                        AccScheduleExtension: Record "Acc. Schedule Extension";
                        GLAccList: Page "G/L Account List";
                        AccScheduleLines: Page "Acc. Schedule Lines";
                        AccScheduleExtensions: Page "Acc. Schedule Extensions";
                    begin
                        if Rec."Totaling Type" in
                           [Rec."Totaling Type"::"Posting Accounts", Rec."Totaling Type"::"Total Accounts"]
                        then begin
                            GLAccList.LookupMode(true);
                            if not (GLAccList.RunModal() = ACTION::LookupOK) then
                                exit(false);

                            Text := GLAccList.GetSelectionFilter();
                            TotalingDisplayed := CopyStr(Text, 1, 250);
                            Rec.Validate(Totaling, TotalingDisplayed);
                        end;

                        case Rec."Totaling Type" of
                            Rec."Totaling Type"::Formula:
                                begin
                                    GLSetup.Get();
                                    if GLSetup."Shared Account Schedule" <> '' then begin
                                        AccScheduleLines.LookupMode := true;
                                        AccScheduleLine.FilterGroup(2);
                                        AccScheduleLine.SetRange("Schedule Name", GLSetup."Shared Account Schedule");
                                        AccScheduleLine.FilterGroup(0);
                                        AccScheduleLines.SetTableView(AccScheduleLine);
                                        if AccScheduleLines.RunModal() = ACTION::LookupOK then begin
                                            AccScheduleLines.GetRecord(AccScheduleLine);
                                            Text := AccScheduleLine."Row No.";
                                            TotalingDisplayed := CopyStr(Text, 1, 250);
                                            Rec.Validate(Totaling, TotalingDisplayed);
                                            exit(true);
                                        end else
                                            exit(false)
                                    end;
                                end;

                            Rec."Totaling Type"::Custom:
                                if Rec."Extension Source Table" <> Rec."Extension Source Table"::" " then begin
                                    if Rec.Totaling <> '' then begin
                                        AccScheduleExtension.Get(Rec.Totaling);
                                        AccScheduleExtensions.SetRecord(AccScheduleExtension);
                                    end;
                                    AccScheduleExtension.FilterGroup(2);
                                    AccScheduleExtension.SetRange(AccScheduleExtension."Source Table", Rec."Extension Source Table" - 1);
                                    AccScheduleExtension.FilterGroup(0);
                                    AccScheduleExtensions.SetSourceTable(Rec."Extension Source Table");
                                    AccScheduleExtensions.SetTableView(AccScheduleExtension);
                                    AccScheduleExtensions.LookupMode(true);
                                    if not (AccScheduleExtensions.RunModal() = ACTION::LookupOK) then
                                        exit(false)
                                    else begin
                                        AccScheduleExtensions.GetRecord(AccScheduleExtension);
                                        Text := AccScheduleExtension.Code;
                                        TotalingDisplayed := CopyStr(Text, 1, 250);
                                        Rec.Validate(Totaling, TotalingDisplayed);
                                        exit(true);
                                    end;
                                end;
                        end;

                        Rec.LookupTotaling();
                        if Rec."Totaling Type" = Rec."Totaling Type"::"Account Category" then
                            TotalingDisplayed := GetAccountCategoryTotalingToDisplay()
                        else
                            TotalingDisplayed := Rec.Totaling;
                    end;

                }
                field("Row Type"; Rec."Row Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the row type for the row definition. The type determines how the amounts in the row are calculated.';
                }
                field("Amount Type"; Rec."Amount Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of entries that will be included in the amounts in the row definition.';
                }
                field("Corr. Totaling"; Rec."Corr. Totaling")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the corresponding total of the general ledger account associated with the account schedule line.';
                }
                field("Show Opposite Sign"; Rec."Show Opposite Sign")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to show debits in reports as negative amounts with a minus sign and credits as positive amounts.';
                }
                field("Dimension 1 Totaling"; Rec."Dimension 1 Totaling")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies which dimension value amounts will be totaled on this line.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(Rec.LookUpDimFilter(1, Text));
                    end;
                }
                field("Dimension 2 Totaling"; Rec."Dimension 2 Totaling")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies which dimension value amounts will be totaled on this line.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(Rec.LookUpDimFilter(2, Text));
                    end;
                }
                field("Dimension 3 Totaling"; Rec."Dimension 3 Totaling")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies which dimension value amounts will be totaled on this line.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(Rec.LookUpDimFilter(3, Text));
                    end;
                }
                field("Dimension 4 Totaling"; Rec."Dimension 4 Totaling")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies which dimension value amounts will be totaled on this line.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(Rec.LookUpDimFilter(4, Text));
                    end;
                }
                field("Dimension 1 Corr. Totaling"; Rec."Dimension 1 Corr. Totaling")
                {
                    ToolTip = 'Specifies which dimension value amounts will be totaled on this line.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(Rec.LookUpDimFilter(12401, Text));
                    end;
                }
                field("Dimension 2 Corr. Totaling"; Rec."Dimension 2 Corr. Totaling")
                {
                    ToolTip = 'Specifies the dimension 2 corresponding totaling account associated with the account schedule line.';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(Rec.LookUpDimFilter(12402, Text));
                    end;
                }
                field(Show; Rec.Show)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the account schedule line will be printed on the report.';
                }
                field(Bold; Rec.Bold)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to print the amounts in this row in bold.';
                }
                field(Italic; Rec.Italic)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to print the amounts in this row in italics.';
                }
                field(Underline; Rec.Underline)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to underline the amounts in this row.';
                }
                field("Double Underline"; Rec."Double Underline")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to double underline the amounts in this row.';
                    Visible = false;
                }
                field("New Page"; Rec."New Page")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether there will be a page break after the current account when the account schedule is printed.';
                }
                field(HideCurrencySymbol; Rec."Hide Currency Symbol")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether to hide currency symbols when a calculated result is not a currency.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Indent)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Indent';
                Image = Indent;
                Scope = Repeater;
                ToolTip = 'Make this row part of a group of rows. For example, indent rows that itemize a range of accounts, such as types of revenue.';

                trigger OnAction()
                var
                    AccScheduleLine: Record "Acc. Schedule Line";
                begin
                    CurrPage.SetSelectionFilter(AccScheduleLine);
                    if AccScheduleLine.FindSet() then
                        repeat
                            AccScheduleLine.Indent();
                            AccScheduleLine.Modify();
                        until AccScheduleLine.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
            action(Outdent)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Outdent';
                Image = DecreaseIndent;
                Scope = Repeater;
                ToolTip = 'Move this row out one level.';

                trigger OnAction()
                var
                    AccScheduleLine: Record "Acc. Schedule Line";
                begin
                    CurrPage.SetSelectionFilter(AccScheduleLine);
                    if AccScheduleLine.FindSet() then
                        repeat
                            AccScheduleLine.Outdent();
                            AccScheduleLine.Modify();
                        until AccScheduleLine.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(InsertGLAccounts)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Insert G/L Accounts';
                    Ellipsis = true;
                    Image = InsertAccount;
                    ToolTip = 'Open the list of general ledger accounts so you can add accounts to the row definition.';

                    trigger OnAction()
                    var
                        AccSchedLine: Record "Acc. Schedule Line";
                    begin
                        CurrPage.Update(true);
                        SetupAccSchedLine(AccSchedLine);
                        AccSchedManagement.InsertGLAccounts(AccSchedLine);
                    end;
                }
                action(InsertCFAccounts)
                {
                    ApplicationArea = Suite;
                    Caption = 'Insert CF Accounts';
                    Ellipsis = true;
                    Image = InsertAccount;
                    ToolTip = 'Mark the cash flow accounts from the chart of cash flow accounts and copy them to row definition lines.';

                    trigger OnAction()
                    var
                        AccSchedLine: Record "Acc. Schedule Line";
                    begin
                        CurrPage.Update(true);
                        SetupAccSchedLine(AccSchedLine);
                        AccSchedManagement.InsertCFAccounts(AccSchedLine);
                    end;
                }
                action(InsertCostTypes)
                {
                    ApplicationArea = CostAccounting;
                    Caption = 'Insert Cost Types';
                    Ellipsis = true;
                    Image = InsertAccount;
                    ToolTip = 'Insert cost types to analyze what the costs are, where the costs come from, and who should bear the costs.';

                    trigger OnAction()
                    var
                        AccSchedLine: Record "Acc. Schedule Line";
                    begin
                        CurrPage.Update(true);
                        SetupAccSchedLine(AccSchedLine);
                        AccSchedManagement.InsertCostTypes(AccSchedLine);
                    end;
                }
                separator(Action1210006)
                {
                }
                action("Export Settings")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Export Settings';
                    Ellipsis = true;
                    Image = Export;

                    trigger OnAction()
                    begin
                        AccScheduleName.Get(CurrentSchedName);
                        AccScheduleName.SetRecFilter();
                        AccScheduleName.ExportSettings(AccScheduleName);
                    end;
                }
                action("I&mport Settings")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'I&mport Settings';
                    Ellipsis = true;
                    Image = Import;
                    ToolTip = 'Import setup information.';

                    trigger OnAction()
                    begin
                        AccScheduleName.ImportSettings('');
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Outdent_Promoted; Outdent)
                {
                }
                actionref(Indent_Promoted; Indent)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Insert', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(InsertGLAccounts_Promoted; InsertGLAccounts)
                {
                }
                actionref(InsertCostTypes_Promoted; InsertCostTypes)
                {
                }
                actionref(InsertCFAccounts_Promoted; InsertCFAccounts)
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        FormatLines();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        FormatLines();
    end;

    trigger OnOpenPage()
    var
        FinancialReportMgt: Codeunit "Financial Report Mgt.";
        OriginalSchedName: Code[10];
    begin
        FinancialReportMgt.LaunchEditRowsWarningNotification();
        OriginalSchedName := CurrentSchedName;
        AccSchedManagement.OpenAndCheckSchedule(CurrentSchedName, Rec);
        if CurrentSchedName <> OriginalSchedName then
            CurrentSchedNameOnAfterValidate();
    end;

    var
        AccScheduleName: Record "Acc. Schedule Name";
        AccSchedManagement: Codeunit AccSchedManagement;
        CurrentSchedName: Code[10];
        DimCaptionsInitialized: Boolean;
        TotalingDisplayed: Text[250];

    procedure SetAccSchedName(NewAccSchedName: Code[10])
    begin
        CurrentSchedName := NewAccSchedName;
    end;

    local procedure CurrentSchedNameOnAfterValidate()
    begin
        CurrPage.SaveRecord();
        AccSchedManagement.SetName(CurrentSchedName, Rec);
        CurrPage.Update(false);
    end;

    local procedure FormatLines()
    begin
        if not DimCaptionsInitialized then
            DimCaptionsInitialized := true;
        if Rec."Totaling Type" = Rec."Totaling Type"::"Account Category" then
            TotalingDisplayed := GetAccountCategoryTotalingToDisplay()
        else
            TotalingDisplayed := Rec.Totaling;
    end;

    procedure SetupAccSchedLine(var AccSchedLine: Record "Acc. Schedule Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetupAccSchedLine(Rec, xRec, AccSchedLine, CurrentSchedName, IsHandled);
        if IsHandled then
            exit;

        AccSchedLine := Rec;
        if Rec."Line No." = 0 then begin
            AccSchedLine := xRec;
            AccSchedLine.SetRange("Schedule Name", CurrentSchedName);
            if AccSchedLine.Next() = 0 then
                AccSchedLine."Line No." := xRec."Line No." + 10000
            else begin
                if AccSchedLine.FindLast() then
                    AccSchedLine."Line No." += 10000;
                AccSchedLine.SetRange("Schedule Name");
            end;
        end;
    end;

    procedure GetAccountCategoryTotalingToDisplay(): Text[250]
    begin
        exit(AccSchedManagement.GLAccCategoryText(Rec));
    end;

    procedure GetAccSchedName(): Code[10]
    begin
        exit(CurrentSchedName);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetupAccSchedLine(var RecAccScheduleLine: Record "Acc. Schedule Line"; var xRecAccScheduleLine: Record "Acc. Schedule Line"; var AccScheduleLine: Record "Acc. Schedule Line"; CurrentSchedName: Code[20]; var IsHandled: Boolean)
    begin
    end;
}

