page 688 "Payment Practice Lines"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Payment Practice Line";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the payment practice line.';
                }
                field("Aggregation Type"; Rec."Aggregation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of aggregation.';
                    Visible = false;
                }
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source for the payment data.';
                    Visible = HeaderType = HeaderType::"Vendor+Customer";
                }
                field("Company Size Code"; Rec."Company Size Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the company size code.';
                    Visible = AggregationType = AggregationType::"Company Size";
                }
                field("Payment Period Code"; Rec."Payment Period Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment period code.';
                    Visible = false;
                }
                field("Payment Period Description"; Rec."Payment Period Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment period description.';
                    Visible = AggregationType = AggregationType::Period;
                }
                field("Average Agreed Payment Period"; Rec."Average Agreed Payment Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the average agreed payment period.';
                    Visible = AggregationType = AggregationType::"Company Size";
                }
                field("Average Actual Payment Period"; Rec."Average Actual Payment Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the average actual payment period.';
                    Visible = AggregationType = AggregationType::"Company Size";
                }
                field("Pct Paid on Time"; Rec."Pct Paid on Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage paid on time.';
                    Visible = AggregationType = AggregationType::"Company Size";

                    trigger OnAssistEdit()
                    begin
                        ShowLineDataLines();
                    end;
                }
                field("Pct Paid in Period"; Rec."Pct Paid in Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage paid in period.';
                    Visible = AggregationType = AggregationType::Period;

                    trigger OnAssistEdit()
                    begin
                        ShowLineDataLines();
                    end;
                }
                field("Pct Paid in Period (Amount)"; Rec."Pct Paid in Period (Amount)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the percentage paid in period (amount).';
                    Visible = AggregationType = AggregationType::Period;
                }
                field("Modified Manully"; Rec."Modified Manually")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether the line has been modified manually.';
                }
            }
        }
    }

    procedure UpdateVisibility(newAggregationType: enum "Paym. Prac. Aggregation Type"; newHeaderType: enum "Paym. Prac. Header Type")
    begin
        AggregationType := newAggregationType;
        HeaderType := newHeaderType;
    end;

    var
        AggregationType: enum "Paym. Prac. Aggregation Type";
        HeaderType: enum "Paym. Prac. Header Type";

    local procedure ShowLineDataLines()
    var
        PaymentPracticeData: Record "Payment Practice Data";
    begin
        PaymentPracticeData.SetFilterForLine(Rec);
        Page.RunModal(Page::"Payment Practice Data List", PaymentPracticeData);
    end;
}