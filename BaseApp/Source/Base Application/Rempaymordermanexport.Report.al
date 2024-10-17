report 15000000 "Rem. paym. order - man. export"
{
    Caption = 'Rem. paym. order - man. export';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Remittance Payment Order"; "Remittance Payment Order")
        {
            DataItemTableView = SORTING(ID);
            MaxIteration = 1;

            trigger OnPreDataItem()
            var
                RemPmtOrderExport: Report "Rem. Payment Order  - Export";
            begin
                if CurrentFilename = '' then
                    Error(EmptyFileNameErr);

                CurrentPaymOrder.TestField(Type, CurrentPaymOrder.Type::Export);
                RemPmtOrderExport.SetPmtOrder(CurrentPaymOrder);
                RemPmtOrderExport.SetFilename(CurrentFilename);
                RemPmtOrderExport.RunModal;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Filename; Filename)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Filename';
                        ToolTip = 'Specifies the path and the name of the file that contains the manually exported remittance payment orders.';

                        trigger OnAssistEdit()
                        var
                            FileMgt: Codeunit "File Management";
                        begin
                            CurrentFilename := FileMgt.OpenFileDialog(Text15000000, CurrentFilename, Text15000001);
                            if CurrentFilename <> '' then
                                Filename := FileMgt.GetFileName(CurrentFilename);
                        end;

                        trigger OnValidate()
                        var
                            FileMgt: Codeunit "File Management";
                        begin
                            CurrentFilename := CopyStr(Filename, 1, MaxStrLen(CurrentFilename));
                            Filename := FileMgt.GetFileName(Filename);
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CurrentPaymOrder: Record "Remittance Payment Order";
        CurrentFilename: Text[250];
        EmptyFileNameErr: Label 'You must enter a file name.';
        Text15000000: Label 'Export Remittance File.';
        Text15000001: Label 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
        Filename: Text;

    [Scope('OnPrem')]
    procedure SetPaymOrder(RemPaymOrder: Record "Remittance Payment Order")
    begin
        RemPaymOrder.TestField(Type, RemPaymOrder.Type::Export);
        CurrentPaymOrder := RemPaymOrder;
    end;
}

