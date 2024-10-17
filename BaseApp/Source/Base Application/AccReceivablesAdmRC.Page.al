page 9003 "Acc. Receivables Adm. RC"
{
    Caption = 'Accounts Receivable Administrator', Comment = '{Dependency=Match,"ProfileDescription_ARADMINISTRATOR"}';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                part(Control1902899408; "Acc. Receivable Activities")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                part(Control1907692008; "My Customers")
                {
                    ApplicationArea = Basic, Suite;
                }
                part(Control1905989608; "My Items")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                part(Control38; "Report Inbox Part")
                {
                    ApplicationArea = Basic, Suite;
                }
                part(Control1; "My Job Queue")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                systempart(Control1901377608; MyNotes)
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("C&ustomer - List")
            {
                ApplicationArea = Suite;
                Caption = 'C&ustomer - List';
                Image = "Report";
                RunObject = Report "Customer - List";
                ToolTip = 'View various information for customers, such as customer posting group, discount group, finance charge and payment information, salesperson, the customer''s default currency and credit limit (in LCY), and the customer''s current balance (in LCY).';
            }
            action("Customer - &Balance to Date")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer - &Balance to Date';
                Image = "Report";
                RunObject = Report "Customer - Balance to Date";
                ToolTip = 'View a list with customers'' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.';
            }
            action("Aged &Accounts Receivable")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Aged &Accounts Receivable';
                Image = "Report";
                RunObject = Report "Aged Accounts Receivable";
                ToolTip = 'View an overview of when your receivables from customers are due or overdue (divided into four periods). You must specify the date you want aging calculated from and the length of the period that each column will contain data for.';
            }
            action("Customer - &Summary Aging Simp.")
            {
                ApplicationArea = Suite;
                Caption = 'Customer - &Summary Aging Simp.';
                Image = "Report";
                RunObject = Report "Customer - Summary Aging Simp.";
                ToolTip = 'View, print, or save a summary of each customer''s total payments due, divided into three time periods. The report can be used to decide when to issue reminders, to evaluate a customer''s creditworthiness, or to prepare liquidity analyses.';
            }
            action("Customer - Trial Balan&ce")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer - Trial Balan&ce';
                Image = "Report";
                RunObject = Report "Customer - Trial Balance";
                ToolTip = 'View the beginning and ending balance for customers with entries within a specified period. The report can be used to verify that the balance for a customer posting group is equal to the balance on the corresponding general ledger account on a certain date.';
            }
            action("Cus&tomer/Item Sales")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cus&tomer/Item Sales';
                Image = "Report";
                RunObject = Report "Customer/Item Sales";
                ToolTip = 'View a list of item sales for each customer during a selected time period. The report contains information on quantity, sales amount, profit, and possible discounts. It can be used, for example, to analyze a company''s customer groups.';
            }
            separator(Action20)
            {
            }
            action("Customer &Document Nos.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer &Document Nos.';
                Image = "Report";
                RunObject = Report "Customer Document Nos.";
                ToolTip = 'View a list of customer ledger entries, sorted by document type and number. The report includes the document type, document number, posting date and source code of the entry, the name and number of the customer, and so on. A warning appears when there is a gap in the number series or when the documents were not posted in document-number order.';
            }
            action("Sales &Invoice Nos.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales &Invoice Nos.';
                Image = "Report";
                RunObject = Report "Sales Invoice Nos.";
                ToolTip = 'View or edit number series for sales invoices.';
            }
            action("Sa&les Credit Memo Nos.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sa&les Credit Memo Nos.';
                Image = "Report";
                RunObject = Report "Sales Credit Memo Nos.";
                ToolTip = 'View or edit number series for sales credit memos.';
            }
            action("Re&minder Nos.")
            {
                ApplicationArea = Suite;
                Caption = 'Re&minder Nos.';
                Image = "Report";
                RunObject = Report "Reminder Nos.";
                ToolTip = 'View or set up number series for reminders.';
            }
            action("Finance Cha&rge Memo Nos.")
            {
                ApplicationArea = Suite;
                Caption = 'Finance Cha&rge Memo Nos.';
                Image = "Report";
                RunObject = Report "Finance Charge Memo Nos.";
                ToolTip = 'View or edit number series for finance charge memos.';
            }
            separator(Action1100007)
            {
            }
            action("Customer - Due Payments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customer - Due Payments';
                Image = "Report";
                RunObject = Report "Customer - Due Payments";
                ToolTip = 'View a list of payments due from a particular customer sorted by due date.';
            }
            group("Cartera Bill Groups")
            {
                Caption = 'Cartera Bill Groups';
                action("Closed Bill Group Listing")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Closed Bill Group Listing';
                    Image = "Report";
                    RunObject = Report "Closed Bill Group Listing";
                    ToolTip = 'View the list of completed bill groups.';
                }
                action("Posted Bill Group Listing")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Bill Group Listing';
                    Image = "Report";
                    RunObject = Report "Posted Bill Group Listing";
                    ToolTip = 'View the list of posted bill groups. When a bill group has been posted, the related documents are available for settlement, rejection, or recirculation.';
                }
                action("Bill Group Listing")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bill Group Listing';
                    Image = "Report";
                    RunObject = Report "Bill Group Listing";
                    ToolTip = 'View or edit a bill group. Bill groups are receivables documents that are grouped together to submit to a bank for collection. For example, you may want to group documents for the same customer or group documents with the same due date.';
                }
                action("Bank - Summ. Bill Group")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank - Summ. Bill Group';
                    Image = "Report";
                    RunObject = Report "Bank - Summ. Bill Group";
                    ToolTip = 'View a detailed summary for existing bill groups.';
                }
                action("Bank - Risk")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank - Risk';
                    Image = "Report";
                    RunObject = Report "Bank - Risk";
                    ToolTip = 'View the risk status for discounting bills with the selected bank.';
                }
                action("Notice Assignment Credits")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Notice Assignment Credits';
                    Image = "Report";
                    RunObject = Report "Notice Assignment Credits";
                    ToolTip = 'Define how your company decides to administer its billing using a factoring (factor) entity. You send your customers a notification letter, telling them that it is going to assign its billing to another entity. As of that moment, the client will no longer have to pay the company, they will pay the factoring entity instead.';
                }
            }
        }
        area(embedding)
        {
            action(Customers)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
                ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
            }
            action(CustomersBalance)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Balance';
                Image = Balance;
                RunObject = Page "Customer List";
                RunPageView = WHERE("Balance (LCY)" = FILTER(<> 0));
                ToolTip = 'View a summary of the bank account balance in different periods.';
            }
            action("Sales Orders")
            {
                ApplicationArea = Suite;
                Caption = 'Sales Orders';
                Image = "Order";
                RunObject = Page "Sales Order List";
                ToolTip = 'Record your agreements with customers to sell certain products on certain delivery and payment terms. Sales orders, unlike sales invoices, allow you to ship partially, deliver directly from your vendor to your customer, initiate warehouse handling, and print various customer-facing documents. Sales invoicing is integrated in the sales order process.';
            }
            action("Sales Invoices")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List";
                ToolTip = 'Register your sales to customers and invite them to pay according to the delivery and payment terms by sending them a sales invoice document. Posting a sales invoice registers shipment and records an open receivable entry on the customer''s account, which will be closed when payment is received. To manage the shipment process, use sales orders, in which sales invoicing is integrated.';
            }
            action("Bill Groups List")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bill Groups List';
                RunObject = Page "Bill Groups List";
                ToolTip = 'View or edit a bill group. Bill groups are receivables documents that are grouped together to submit to a bank for collection. For example, you may want to group documents for the same customer or group documents with the same due date.';
            }
            action("Posted Bill Groups List")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted Bill Groups List';
                RunObject = Page "Posted Bill Groups List";
                ToolTip = 'View the list of posted bill groups. When a bill group has been posted, the related documents are available for settlement, rejection, or recirculation.';
            }
            action("Sales Return Orders")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Return Orders';
                Image = ReturnOrder;
                RunObject = Page "Sales Return Order List";
                ToolTip = 'Compensate your customers for incorrect or damaged items that you sent to them and received payment for. Sales return orders enable you to receive items from multiple sales documents with one sales return, automatically create related sales credit memos or other return-related documents, such as a replacement sales order, and support warehouse documents for the item handling. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.';
            }
            action("Bank Accounts")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page "Bank Account List";
                ToolTip = 'View or set up detailed information about your bank account, such as which currency to use, the format of bank files that you import and export as electronic payments, and the numbering of checks.';
            }
            action(Reminders)
            {
                ApplicationArea = Suite;
                Caption = 'Reminders';
                Image = Reminder;
                RunObject = Page "Reminder List";
                ToolTip = 'Remind customers about overdue amounts based on reminder terms and the related reminder levels. Each reminder level includes rules about when the reminder will be issued in relation to the invoice due date or the date of the previous reminder and whether interests are added. Reminders are integrated with finance charge memos, which are documents informing customers of interests or other money penalties for payment delays.';
            }
            action("Finance Charge Memos")
            {
                ApplicationArea = Suite;
                Caption = 'Finance Charge Memos';
                Image = FinChargeMemo;
                RunObject = Page "Finance Charge Memo List";
                ToolTip = 'Send finance charge memos to customers with delayed payments, typically following a reminder process. Finance charges are calculated automatically and added to the overdue amounts on the customer''s account according to the specified finance charge terms and penalty/interest amounts.';
            }
            action(Items)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
                ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
            }
            action(SalesJournals)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Journals';
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE("Template Type" = CONST(Sales),
                                    Recurring = CONST(false));
                ToolTip = 'Post any sales-related transaction directly to a customer, bank, or general ledger account instead of using dedicated documents. You can post all types of financial sales transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a sales journal.';
            }
            action(CashReceiptJournals)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cash Receipt Journals';
                Image = Journals;
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
                                    Recurring = CONST(false));
                ToolTip = 'Register received payments by manually applying them to the related customer, vendor, or bank ledger entries. Then, post the payments to G/L accounts and thereby close the related ledger entries.';
            }
            action(GeneralJournals)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'General Journals';
                Image = Journal;
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE("Template Type" = CONST(General),
                                    Recurring = CONST(false));
                ToolTip = 'Post financial transactions directly to general ledger accounts and other accounts, such as bank, customer, vendor, and employee accounts. Posting with a general journal always creates entries on general ledger accounts. This is true even when, for example, you post a journal line to a customer account, because an entry is posted to a general ledger receivables account through a posting group.';
            }
            action("Direct Debit Collections")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Direct Debit Collections';
                RunObject = Page "Direct Debit Collections";
                ToolTip = 'Instruct your bank to withdraw payment amounts from your customer''s bank account and transfer them to your company''s account. A direct debit collection holds information about the customer''s bank account, the affected sales invoices, and the customer''s agreement, the so-called direct-debit mandate. From the resulting direct-debit collection entry, you can then export an XML file that you send or upload to your bank for processing.';
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Sales Shipments")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Sales Shipments";
                    ToolTip = 'Open the list of posted sales shipments.';
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }
                action("Posted Return Receipts")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Return Receipts';
                    Image = PostedReturnReceipt;
                    RunObject = Page "Posted Return Receipts";
                    ToolTip = 'Open the list of posted return receipts.';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos.';
                }
                action("Receivable Closed Cartera Docs")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Receivable Closed Cartera Docs';
                    RunObject = Page "Receivable Closed Cartera Docs";
                    ToolTip = 'View the customer bills and invoices that are in the closed bill groups.';
                }
                action("Closed Bill Groups List")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Closed Bill Groups List';
                    RunObject = Page "Closed Bill Groups List";
                    ToolTip = 'View the list of completed bill groups.';
                }
                action("Posted Purchase Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Invoices';
                    RunObject = Page "Posted Purchase Invoices";
                    ToolTip = 'Open the list of posted purchase invoices.';
                }
                action("Posted Purchase Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Purchase Credit Memos';
                    RunObject = Page "Posted Purchase Credit Memos";
                    ToolTip = 'Open the list of posted purchase credit memos.';
                }
                action("Issued Reminders")
                {
                    ApplicationArea = Suite;
                    Caption = 'Issued Reminders';
                    Image = OrderReminder;
                    RunObject = Page "Issued Reminder List";
                    ToolTip = 'View the list of issued reminders.';
                }
                action("Issued Fin. Charge Memos")
                {
                    ApplicationArea = Suite;
                    Caption = 'Issued Fin. Charge Memos';
                    Image = PostedMemo;
                    RunObject = Page "Issued Fin. Charge Memo List";
                    ToolTip = 'View the list of issued finance charge memos.';
                }
                action("G/L Registers")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'G/L Registers';
                    Image = GLRegisters;
                    RunObject = Page "G/L Registers";
                    ToolTip = 'View posted G/L entries.';
                }
            }
        }
        area(processing)
        {
            separator(New)
            {
                Caption = 'New';
                IsHeader = true;
            }
            action("C&ustomer")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'C&ustomer';
                Image = Customer;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Customer Card";
                RunPageMode = Create;
                ToolTip = 'Create a new customer card.';
            }
            action(PaymentRegistration)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Register Customer Payments';
                Image = Payment;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Payment Registration";
                ToolTip = 'Process your customer payments by matching amounts received on your bank account with the related unpaid sales invoices, and then post the payments.';
            }
            group("&Sales")
            {
                Caption = '&Sales';
                Image = Sales;
                action("Sales &Order")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Order";
                    RunPageMode = Create;
                    ToolTip = 'Create a new sales order for items or services.';
                }
                action("Sales &Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales &Invoice';
                    Image = NewSalesInvoice;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Invoice";
                    RunPageMode = Create;
                    ToolTip = 'Create a new invoice for the sales of items or services. Invoice quantities cannot be posted partially.';
                }
                action("Sales &Credit Memo")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales &Credit Memo';
                    Image = CreditMemo;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Sales Credit Memo";
                    RunPageMode = Create;
                    ToolTip = 'Create a new sales credit memo to revert a posted sales invoice.';
                }
                action("Sales &Fin. Charge Memo")
                {
                    ApplicationArea = Suite;
                    Caption = 'Sales &Fin. Charge Memo';
                    Image = FinChargeMemo;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Finance Charge Memo";
                    RunPageMode = Create;
                    ToolTip = 'Create a new finance charge memo to fine a customer for late payment.';
                }
                action("Sales &Reminder")
                {
                    ApplicationArea = Suite;
                    Caption = 'Sales &Reminder';
                    Image = Reminder;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page Reminder;
                    RunPageMode = Create;
                    ToolTip = 'Create a new reminder for a customer who has overdue payments.';
                }
            }
            action("Bill Group")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Bill Group';
                Image = VoucherGroup;
                RunObject = Page "Bill Groups";
                ToolTip = 'View or edit a bill group. Bill groups are receivables documents that are grouped together to submit to a bank for collection. For example, you may want to group documents for the same customer or group documents with the same due date.';
            }
            separator(Tasks)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Cash Receipt &Journal")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cash Receipt &Journal';
                Image = CashReceiptJournal;
                RunObject = Page "Cash Receipt Journal";
                ToolTip = 'Open the cash receipt journal to post incoming payments.';
            }
            separator(Action111)
            {
            }
            action("Combine Shi&pments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Combine Shi&pments';
                Ellipsis = true;
                Image = "Action";
                RunObject = Report "Combine Shipments";
                ToolTip = 'Gather all non-invoiced shipments to the same customer on one sales invoice.';
            }
            action("Combine Return S&hipments")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Combine Return S&hipments';
                Ellipsis = true;
                Image = "Action";
                RunObject = Report "Combine Return Receipts";
                ToolTip = 'Return items covered by different purchase return orders to the same vendor on one shipment. When you ship the items, you post the related purchase return orders as shipped and this creates posted purchase return shipments. When you are ready to invoice these items, you can create one purchase credit memo that automatically includes the posted purchase return shipment lines so that you invoice all the open purchase return orders at the same time.';
            }
            separator(Action1100020)
            {
            }
            action("Posted Bill Group Select.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted Bill Group Select.';
                RunObject = Page "Posted Bill Group Select.";
                ToolTip = 'View or edit where ledger entries are posted when you post a bill group.';
            }
            group("Bill Group - Export Formats")
            {
                Caption = 'Bill Group - Export Formats';
                action("Bill Group - Export Factoring")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bill Group - Export Factoring';
                    Image = "Report";
                    RunObject = Report "Bill group - Export factoring";
                    ToolTip = 'Send the factoring bill groups to a magnetic media.';
                }
            }
            action("Create Recurring Invoices")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Recurring Invoices';
                Ellipsis = true;
                Image = CreateDocument;
                RunObject = Report "Create Recurring Sales Inv.";
                ToolTip = 'Create sales invoices according to standard sales lines that are assigned to the customers and with posting dates within the valid-from and valid-to dates that you specify on the standard sales code. Can also be used for SEPA direct debit. ';
            }
            separator(Administration)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("Sales && Recei&vables Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales && Recei&vables Setup';
                Image = Setup;
                RunObject = Page "Sales & Receivables Setup";
                ToolTip = 'Define your general policies for sales invoicing and returns, such as when to show credit and stockout warnings and how to post sales discounts. Set up your number series for creating customers and different sales documents.';
            }
            separator(History)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Navi&gate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';
            }
        }
    }
}

