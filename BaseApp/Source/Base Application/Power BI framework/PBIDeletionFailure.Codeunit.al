#if not CLEAN18
codeunit 6316 "PBI Deletion Failure"
{
    // // Handles background task failures triggered when doing Power BI report deletion in
    // // codeunit 6315 - just sets the flag in table 6308 to show that no background
    // // deletion is happening anymore.

    ObsoleteState = Pending;
    ObsoleteReason = 'The Power BI synchronization has been merged into "Power BI Report Synchronizer" and error handling is handled by the Job Queue framework.';
    ObsoleteTag = '18.0';

    trigger OnRun()
    begin
        PowerBIServiceMgt.SetIsDeletingReports(false);
    end;

    var
        PowerBIServiceMgt: Codeunit "Power BI Service Mgt.";
}
#endif