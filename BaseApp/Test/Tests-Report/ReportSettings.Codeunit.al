codeunit 136908 "Report Settings"
{
    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        // [FEATURE] [Object Options] [Report]
    end;

    var
        Assert: Codeunit Assert;
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibraryUtility: Codeunit "Library - Utility";
        TestReportID: Integer;
        PageAction: Option OK,Cancel;
        IsInitialized: Boolean;
        ObjectOptionsInsertedErr: Label 'Object Options inserted.';

    [Test]
    [HandlerFunctions('PickReportPageModalHandler')]
    [Scope('OnPrem')]
    procedure CancelOnPickReport()
    var
        ObjectOptions: Record "Object Options";
        ReportSettings: TestPage "Report Settings";
    begin
        // [FEATURE]
        // [SCENARIO 176067] If Cancel is pressed in 'Pick Report' page, no Object Options is inserted.
        Initialize;

        // [GIVEN] Open 'Report Settings', press 'New' action. 'Pick Report' is opened.
        ReportSettings.OpenEdit;

        // [WHEN] On 'Pick Report' press 'Cancel'.
        LibraryVariableStorage.Enqueue(PageAction::Cancel); // for PickReportPageModalHandler

        ReportSettings.NewSettings.Invoke;

        // [THEN] No 'Object Options' is inserted.
        Assert.IsTrue(ObjectOptions.IsEmpty, ObjectOptionsInsertedErr);
    end;

    [Test]
    [HandlerFunctions('PickReportPageModalHandler,TestReportRequestPageModalHandler')]
    [Scope('OnPrem')]
    procedure CancelOnReportRequestPage()
    var
        ObjectOptions: Record "Object Options";
        ReportSettings: TestPage "Report Settings";
    begin
        // [FEATURE]
        // [SCENARIO 176067] If Cancel is pressed in RequestPage for report settings, no Object Options is inserted.
        Initialize;

        // [GIVEN] Open 'Report Settings', press 'New' action. 'Pick Report' is opened.
        ReportSettings.OpenEdit;

        // [GIVEN] On 'Pick Report' set 'Name', set 'Report ID' and press 'OK'. RequestPage is opened.
        LibraryVariableStorage.Enqueue(PageAction::OK); // for PickReportPageModalHandler
        LibraryVariableStorage.Enqueue(LibraryUtility.GenerateGUID); // for PickReportPageModalHandler

        // [WHEN] On RequestPage press 'Cancel'.
        LibraryVariableStorage.Enqueue(PageAction::Cancel); // for TestReportRequestPageModalHandler

        ReportSettings.NewSettings.Invoke;

        // [THEN] No 'Object Options' is inserted.
        Assert.IsTrue(ObjectOptions.IsEmpty, ObjectOptionsInsertedErr);
    end;

    [Test]
    [HandlerFunctions('PickReportPageModalHandler,TestReportRequestPageModalHandler')]
    [Scope('OnPrem')]
    procedure OkOnReportRequestPage()
    var
        ObjectOptions: Record "Object Options";
        ReportSettings: TestPage "Report Settings";
        ParameterName: Text;
    begin
        // [FEATURE]
        // [SCENARIO 176067] If OK is pressed in RequestPage for report settings, Object Options is inserted for given report.
        Initialize;

        // [GIVEN] Open 'Report Settings', press 'New' action. 'Pick Report' is opened.
        ParameterName := LibraryUtility.GenerateGUID;
        ReportSettings.OpenEdit;

        // [GIVEN] On 'Pick Report' set 'Name', set 'Report ID' and press 'OK'. RequestPage is opened.
        LibraryVariableStorage.Enqueue(PageAction::OK); // for PickReportPageModalHandler
        LibraryVariableStorage.Enqueue(ParameterName); // for PickReportPageModalHandler

        // [WHEN] On RequestPage press 'OK'.
        LibraryVariableStorage.Enqueue(PageAction::OK); // for TestReportRequestPageModalHandler
        ReportSettings.NewSettings.Invoke;

        // [THEN] 'Object Options' is inserted successfully.
        ObjectOptions.Get(
          ParameterName, TestReportID, ObjectOptions."Object Type"::Report, UserId, CompanyName);
        ObjectOptions.TestField("Created By", UserId);
    end;

    local procedure Initialize()
    begin
        LibraryTestInitialize.OnTestInitialize(CODEUNIT::"Report Settings");
        LibraryVariableStorage.Clear;
        ClearObjectOptions;

        if IsInitialized then
            exit;
        LibraryTestInitialize.OnBeforeTestSuiteInitialize(CODEUNIT::"Report Settings");

        TestReportID := REPORT::"Customer - Top 10 List";
        IsInitialized := true;
        LibraryTestInitialize.OnAfterTestSuiteInitialize(CODEUNIT::"Report Settings");
    end;

    local procedure ClearObjectOptions()
    var
        ObjectOptions: Record "Object Options";
    begin
        ObjectOptions.DeleteAll;
        Commit;
    end;

    [ModalPageHandler]
    [Scope('OnPrem')]
    procedure PickReportPageModalHandler(var PickReport: TestPage "Pick Report")
    begin
        case LibraryVariableStorage.DequeueInteger of
            PageAction::Cancel:
                PickReport.Cancel.Invoke;
            PageAction::OK:
                begin
                    PickReport.Name.SetValue(LibraryVariableStorage.DequeueText);
                    PickReport."Report ID".SetValue(TestReportID);
                    Commit;
                    PickReport.OK.Invoke;
                end;
        end;
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure TestReportRequestPageModalHandler(var CustomerTop10List: TestRequestPage "Customer - Top 10 List")
    begin
        case LibraryVariableStorage.DequeueInteger of
            PageAction::Cancel:
                CustomerTop10List.Cancel.Invoke;
            PageAction::OK:
                CustomerTop10List.OK.Invoke;
        end;
    end;
}

