table 10561 "Payment Period Setup"
{
    Caption = 'Payment Period Setup';

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
            Editable = false;
        }
        field(2; "Days From"; Integer)
        {
            Caption = 'Days From';
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckDatePeriodConsistency;
            end;
        }
        field(3; "Days To"; Integer)
        {
            Caption = 'Days To';
            MinValue = 0;

            trigger OnValidate()
            begin
                CheckDatePeriodConsistency;
            end;
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if ("Days From" = 0) and ("Days To" = 0) then
            Error(DaysFromAndDaysToNotSpecifiedErr);
    end;

    var
        DaysFromLessThanDaysToErr: Label 'Days From must no be less than Days To.';
        DaysFromAndDaysToNotSpecifiedErr: Label 'Days From and Days To are not specified.';

    local procedure CheckDatePeriodConsistency()
    begin
        if ("Days From" <> 0) and ("Days To" <> 0) and ("Days From" > "Days To") then
            Error(DaysFromLessThanDaysToErr);
    end;
}
