page 9650 "Custom Report Layouts"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Custom Report Layouts';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Custom Report Layout";
    SourceTableView = SORTING("Report ID", "Company Name", Type);
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = IsNotBuiltIn;
                    ToolTip = 'Specifies the Code.';
                    Visible = false;
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = false;
                    ToolTip = 'Specifies the object ID of the report.';
                }
                field("Report Name"; Rec."Report Name")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = false;
                    ToolTip = 'Specifies the name of the report.';
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a description of the report layout.';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Business Central company that the report layout applies to. You to create report layouts that can only be used on reports when they are run for a specific to a company. If the field is blank, then the layout will be available for use in all companies.';
                }
                field("Built-In"; Rec."Built-In")
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = false;
                    ToolTip = 'Specifies if the report layout is built-in or not.';
                }
                field(Type; Type)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the file type of the report layout. The following table includes the types that are available:';
                }
                field("Last Modified"; Rec."Last Modified")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date and time of the last change to the report layout entry.';
                    Visible = false;
                }
                field("Last Modified by User"; Rec."Last Modified by User")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the user who made the last change to the report layout entry.';
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation("Last Modified by User");
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control11; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
            systempart(Control12; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(NewLayout)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'New';
                Ellipsis = true;
                Image = NewDocument;
                ToolTip = 'Create a new built-in layout for reports.';

                trigger OnAction()
                begin
                    CopyBuiltInReportLayout();
                end;
            }
            action(CopyRec)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Copy';
                Image = CopyDocument;
                ToolTip = 'Make a copy of a built-in layout for reports.';

                trigger OnAction()
                begin
                    CopyReportLayout();
                end;
            }
        }
        area(processing)
        {
            action(ExportWordXMLPart)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export Word XML Part';
                Image = Export;
                ToolTip = 'Export to a Word XML file.';

                trigger OnAction()
                begin
                    ExportSchema('', true);
                end;
            }
            action(ImportLayout)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Layout';
                Image = Import;
                ToolTip = 'Import a Word file.';

                trigger OnAction()
                begin
                    ImportReportLayout('');
                end;
            }
            action(ExportLayout)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export Layout';
                Image = Export;
                ToolTip = 'Export a Word file.';

                trigger OnAction()
                begin
                    ExportReportLayout('', true);
                end;
            }
            action(UpdateWordLayout)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Layout';
                Image = UpdateXML;
                ToolTip = 'Update specific report layouts or all custom report layouts that might be affected by dataset changes.';

                trigger OnAction()
                begin
                    if CanBeModified() then
                        if UpdateReportLayout(false, false) then
                            Message(UpdateSuccesMsg, Format(Type))
                        else
                            Message(UpdateNotRequiredMsg, Format(Type));
                end;
            }
        }
        area(reporting)
        {
            action(RunReport)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Run Report';
                Image = "Report";
                ToolTip = 'Run a test report.';

                trigger OnAction()
                begin
                    RunCustomReport();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_New)
            {
                Caption = 'New', Comment = 'Generated from the PromotedActionCategories property index 0.';

                actionref(NewLayout_Promoted; NewLayout)
                {
                }
                actionref(CopyRec_Promoted; CopyRec)
                {
                }
            }
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(RunReport_Promoted; RunReport)
                {
                }
                group(Category_Category4)
                {
                    Caption = 'Layout', Comment = 'Generated from the PromotedActionCategories property index 3.';

                    actionref(UpdateWordLayout_Promoted; UpdateWordLayout)
                    {
                    }
                    actionref(ImportLayout_Promoted; ImportLayout)
                    {
                    }
                    actionref(ExportLayout_Promoted; ExportLayout)
                    {
                    }
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        ReportLayoutSelection: Record "Report Layout Selection";
    begin
        CurrPage.Caption := GetPageCaption();
        ReportLayoutSelection.SetTempLayoutSelected('');
        IsNotBuiltIn := not "Built-In";
    end;

    trigger OnClosePage()
    var
        ReportLayoutSelection: Record "Report Layout Selection";
    begin
        ReportLayoutSelection.SetTempLayoutSelected('');
    end;

    trigger OnOpenPage()
    begin
        PageName := CurrPage.Caption;
        CurrPage.Caption := GetPageCaption();

        // show notification if bank account is not setup
        SendSetUpBankAccountNotification();
    end;

    var
        UpdateSuccesMsg: Label 'The %1 layout has been updated to use the current report design.';
        UpdateNotRequiredMsg: Label 'The %1 layout is up-to-date. No further updates are required.';
        PageName: Text;
        CaptionTxt: Label '%1 - %2 %3', Locked = true;
        IsNotBuiltIn: Boolean;
        SetUpBankAccountMsg: Label 'Business documents often require bank information. To specify the information to include on documents, use the Payments FastTab on the Company Information page.';
        BankAccountNotificationActionMsg: Label 'Specify bank information';

    local procedure GetPageCaption(): Text
    var
        AllObjWithCaption: Record AllObjWithCaption;
        FilterText: Text;
        ReportID: Integer;
    begin
        if "Report ID" <> 0 then
            exit(StrSubstNo(CaptionTxt, PageName, "Report ID", "Report Name"));
        FilterGroup(4);
        FilterText := GetFilter("Report ID");
        FilterGroup(0);
        if Evaluate(ReportID, FilterText) then
            if AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Report, ReportID) then
                exit(StrSubstNo(CaptionTxt, PageName, ReportID, AllObjWithCaption."Object Caption"));
        exit(PageName);
    end;

    local procedure SendSetUpBankAccountNotification()
    var
        BankNotification: Notification;
    begin
        BankNotification.Message := SetUpBankAccountMsg;
        BankNotification.AddAction(BankAccountNotificationActionMsg, Codeunit::"Company Setup Notification", 'OpenCompanyInformationPage');
        BankNotification.Send();
    end;
}

