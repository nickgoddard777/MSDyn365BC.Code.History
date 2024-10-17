page 1009 "Job WIP G/L Entries"
{
    AdditionalSearchTerms = 'work in process to general ledger entries,work in progress to general ledger entries';
    ApplicationArea = Jobs;
    Caption = 'Job WIP G/L Entries';
    DataCaptionFields = "Job No.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Entry';
    SourceTable = "Job WIP G/L Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Reversed; Reversed)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the entry has been reversed. If the check box is selected, the entry has been reversed from the G/L.';
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting date you entered in the Posting Date field, on the Options FastTab, in the Job Post WIP to G/L batch job.';
                }
                field("WIP Posting Date"; "WIP Posting Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting date you entered in the Posting Date field, on the Options FastTab, in the Job Calculate WIP batch job.';
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the document number you entered in the Document No. field on the Options FastTab in the Job Post WIP to G/L batch job.';
                }
                field("Job No."; "Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the related job.';
                }
                field("Job Complete"; "Job Complete")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether a job is complete. This check box is selected if the Job WIP G/L Entry was created for a Job with a Completed status.';
                }
                field("Job WIP Total Entry No."; "Job WIP Total Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the entry number from the associated job WIP total.';
                }
                field("G/L Account No."; "G/L Account No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general ledger account number to which the WIP, on this entry, is posted.';
                }
                field("G/L Bal. Account No."; "G/L Bal. Account No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the general ledger balancing account number that WIP on this entry was posted to.';
                }
                field("Reverse Date"; "Reverse Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the reverse date. If the WIP on this entry is reversed, you can see the date of the reversal in the Reverse Date field.';
                }
                field("WIP Method Used"; "WIP Method Used")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the WIP method that was specified for the job when you ran the Job Calculate WIP batch job.';
                }
                field("WIP Posting Method Used"; "WIP Posting Method Used")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the WIP posting method used in the context of the general ledger. The information in this field comes from the setting you have specified on the job card.';
                }
                field(Type; Type)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the WIP type for this entry.';
                }
                field("WIP Entry Amount"; "WIP Entry Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the WIP amount that was posted in the general ledger for this entry.';
                }
                field("Job Posting Group"; "Job Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the posting group related to this entry.';
                }
                field("WIP Transaction No."; "WIP Transaction No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the transaction number assigned to all the entries involved in the same transaction.';
                }
                field(Reverse; Reverse)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the entry has been part of a reverse transaction (correction) made by the reverse function.';
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
                field("G/L Entry No."; "G/L Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the G/L Entry No. to which this entry is linked.';
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.';
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
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("<Action57>")
                {
                    ApplicationArea = Jobs;
                    Caption = 'WIP Totals';
                    Image = EntriesList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Job WIP Totals";
                    RunPageLink = "Entry No." = FIELD("Job WIP Total Entry No.");
                    ToolTip = 'View the job''s WIP totals.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(SetDimensionFilter)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Set Dimension Filter';
                    Ellipsis = true;
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Limit the entries according to the dimension filters that you specify. NOTE: If you use a high number of dimension combinations, this function may not work and can result in a message that the SQL server only supports a maximum of 2100 parameters.';

                    trigger OnAction()
                    begin
                        SetFilter("Dimension Set ID", DimensionSetIDFilter.LookupFilter);
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Jobs;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
        DimensionSetIDFilter: Page "Dimension Set ID Filter";
}

