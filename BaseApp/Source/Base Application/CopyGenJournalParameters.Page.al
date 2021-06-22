page 184 "Copy Gen. Journal Parameters"
{
    Caption = 'Copy Gen. Journal Parameters';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Copy Gen. Journal Parameters";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SourceJnlTemplateName; SourceJnlTemplateName)
                {
                    Caption = 'Source Journal Template';
                    ToolTip = 'Specifies original journal template.';
                    Editable = false;
                }
                field(SourceJnlBatchName; SourceJnlBatchName)
                {
                    Caption = 'Source Journal Batch';
                    ToolTip = 'Specifies original journal batch.';
                    Editable = false;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                field("Journal Template Name"; "Journal Template Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Target Journal Template';
                    ToolTip = 'Specifies journal template is used to copy posted journal lines.';
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Target Journal Batch';
                    ToolTip = 'Specifies journal batch is used to copy posted journal lines.';
                }
                field("Replace Posting Date"; "Replace Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Replace Posting Date';
                    ToolTip = 'Specifies if the posting date will be replaced with the value of current field while copy posted journal lines.';
                }
                field("Replace Document No."; "Replace Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Replace Document No.';
                    ToolTip = 'Specifies if the document number will be replaced with the value of current field while copy posted journal lines.';
                }
                field("Reverse Sign"; "Reverse Sign")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reverse Sign';
                    ToolTip = 'Specifies if the posted journal line amount will be passed to journal line with reversed sign.';
                }
            }
        }
    }

    var
        SourceJnlTemplateName: Text;
        SourceJnlBatchName: Text;
        MultipleTxt: Label '(multiple)';

    trigger OnOpenPage()
    begin
        InsertRecord();

        if (SourceJnlTemplateName = '') or (SourceJnlBatchName = '') then begin
            SourceJnlTemplateName := MultipleTxt;
            SourceJnlBatchName := MultipleTxt;
        end;
    end;

    procedure GetCopyParameters(var CopyGenJournalParameters: Record "Copy Gen. Journal Parameters")
    begin
        CopyGenJournalParameters := Rec;
    end;

    procedure SetCopyParameters(CopyGenJournalParameters: Record "Copy Gen. Journal Parameters"; TempGenJournalBatch: Record "Gen. Journal Batch" temporary)
    begin
        InsertRecord();

        Rec := CopyGenJournalParameters;
        Modify(true);

        SourceJnlTemplateName := TempGenJournalBatch."Journal Template Name";
        SourceJnlBatchName := TempGenJournalBatch.Name;
    end;

    local procedure InsertRecord()
    begin
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}