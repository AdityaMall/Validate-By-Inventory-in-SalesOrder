pageextension 50111 SalesLineSubformExt extends "Sales Order Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                itemLedgerEntry: Record "Item Ledger Entry";
                Salesline: Record "Sales Line";
                salesLine2: Record "Sales Line";



            begin
                salesLine2.reset;
                Salesline.SetRange("Document No.", rec."Document No.");
                Salesline.SetRange("No.", rec."No.");
                Salesline.SetRange("Location Code", rec."Location Code");
                if Salesline.FindFirst() then
                    itemLedgerEntry.SetRange("Item No.", Salesline."No.");
                itemLedgerEntry.SetRange("Location Code", Salesline."Location Code");
                if itemLedgerEntry.FindFirst() then
                    repeat
                        salesLine2.SetRange("No.", rec."No.");
                        salesLine2.SetRange("Document No.", rec."Document No.");
                        salesLine2.SetRange("Location Code", rec."Location Code");
                        if salesLine2.FindFirst() then
                            salesLine2.CalcSums(Quantity);
                        if salesLine2.Quantity <= itemLedgerEntry.Quantity then
                            clear(salesLine2.Quantity)
                        else
                            Error('Taken Quantity of Item No. ' + rec."No." + ' is greater than their Location code ' + rec."Location Code" + '.\Quanity of given item no. is =%1', itemLedgerEntry.Quantity);
                        exit;
                        CurrPage.UPDATE(TRUE);
                    until salesLine2.Next() = 0;
            end;

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}