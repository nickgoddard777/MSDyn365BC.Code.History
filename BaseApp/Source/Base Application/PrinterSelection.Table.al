table 78 "Printer Selection"
{
    Caption = 'Printer Selection';
    DataPerCompany = false;
    LookupPageID = "Printer Selections";

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;
        }
        field(2; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(3; "Printer Name"; Text[250])
        {
            Caption = 'Printer Name';
            TableRelation = Printer;
        }
        field(4; "Report Caption"; Text[250])
        {
            CalcFormula = Lookup (AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("Report ID")));
            Caption = 'Report Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10600; "First Page - Paper Source"; Option)
        {
            Caption = 'First Page - Paper Source';
            ObsoleteReason = 'Not needed after refactoring';
            ObsoleteState = Removed;
            OptionCaption = ' ,Upper or Only One Feed,Lower Feed,Middle Feed,Manual Feed,Envelope Feed,Envelope Manual Feed,Automatic Feed,Tractor Feed,Small-format Feed,Large-format Feed,Large-capacity Feed,,,Cassette Feed,Automatically Select,Printer Specific Feed 1,Printer Specific Feed 2,Printer Specific Feed 3,Printer Specific Feed 4,Printer Specific Feed 5,Printer Specific Feed 6,Printer Specific Feed 7,Printer Specific Feed 8';
            OptionMembers = " ","Upper or Only One Feed","Lower Feed","Middle Feed","Manual Feed","Envelope Feed","Envelope Manual Feed","Automatic Feed","Tractor Feed","Small-format Feed","Large-format Feed","Large-capacity Feed",,,"Cassette Feed","Automatically Select","Printer Specific Feed 1","Printer Specific Feed 2","Printer Specific Feed 3","Printer Specific Feed 4","Printer Specific Feed 5","Printer Specific Feed 6","Printer Specific Feed 7","Printer Specific Feed 8";
        }
        field(10601; "First Page - Tray Number"; Integer)
        {
            BlankZero = true;
            Caption = 'First Page - Tray Number';
            ObsoleteReason = 'Not needed after refactoring';
            ObsoleteState = Removed;
        }
        field(10602; "Other Pages - Paper Source"; Option)
        {
            Caption = 'Other Pages - Paper Source';
            ObsoleteReason = 'Not needed after refactoring';
            ObsoleteState = Removed;
            OptionCaption = ' ,Upper or Only One Feed,Lower Feed,Middle Feed,Manual Feed,Envelope Feed,Envelope Manual Feed,Automatic Feed,Tractor Feed,Small-format Feed,Large-format Feed,Large-capacity Feed,,,Cassette Feed,Automatically Select,Printer Specific Feed 1,Printer Specific Feed 2,Printer Specific Feed 3,Printer Specific Feed 4,Printer Specific Feed 5,Printer Specific Feed 6,Printer Specific Feed 7,Printer Specific Feed 8';
            OptionMembers = " ","Upper or Only One Feed","Lower Feed","Middle Feed","Manual Feed","Envelope Feed","Envelope Manual Feed","Automatic Feed","Tractor Feed","Small-format Feed","Large-format Feed","Large-capacity Feed",,,"Cassette Feed","Automatically Select","Printer Specific Feed 1","Printer Specific Feed 2","Printer Specific Feed 3","Printer Specific Feed 4","Printer Specific Feed 5","Printer Specific Feed 6","Printer Specific Feed 7","Printer Specific Feed 8";
        }
        field(10603; "Other Pages - Tray Number"; Integer)
        {
            BlankZero = true;
            Caption = 'Other Pages - Tray Number';
            ObsoleteReason = 'Not needed after refactoring';
            ObsoleteState = Removed;
        }
        field(10604; "Giro Page - Paper Source"; Option)
        {
            Caption = 'Giro Page - Paper Source';
            ObsoleteReason = 'Not needed after refactoring';
            ObsoleteState = Removed;
            OptionCaption = ' ,Upper or Only One Feed,Lower Feed,Middle Feed,Manual Feed,Envelope Feed,Envelope Manual Feed,Automatic Feed,Tractor Feed,Small-format Feed,Large-format Feed,Large-capacity Feed,,,Cassette Feed,Automatically Select,Printer Specific Feed 1,Printer Specific Feed 2,Printer Specific Feed 3,Printer Specific Feed 4,Printer Specific Feed 5,Printer Specific Feed 6,Printer Specific Feed 7,Printer Specific Feed 8';
            OptionMembers = " ","Upper or Only One Feed","Lower Feed","Middle Feed","Manual Feed","Envelope Feed","Envelope Manual Feed","Automatic Feed","Tractor Feed","Small-format Feed","Large-format Feed","Large-capacity Feed",,,"Cassette Feed","Automatically Select","Printer Specific Feed 1","Printer Specific Feed 2","Printer Specific Feed 3","Printer Specific Feed 4","Printer Specific Feed 5","Printer Specific Feed 6","Printer Specific Feed 7","Printer Specific Feed 8";
        }
        field(10605; "Giro Page - Tray Number"; Integer)
        {
            BlankZero = true;
            Caption = 'Giro Page - Tray Number';
            ObsoleteReason = 'Not needed after refactoring';
            ObsoleteState = Removed;
        }
    }

    keys
    {
        key(Key1; "User ID", "Report ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

