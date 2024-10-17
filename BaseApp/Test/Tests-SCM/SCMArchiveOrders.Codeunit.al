codeunit 137207 "SCM Archive Orders"
{
    Subtype = Test;
    TestPermissions = Disabled;

    trigger OnRun()
    begin
        // [FEATURE] [Archive]
        isInitialized := false;
    end;

    var
        LibraryUtility: Codeunit "Library - Utility";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryPurchase: Codeunit "Library - Purchase";
        LibrarySales: Codeunit "Library - Sales";
        LibraryRandom: Codeunit "Library - Random";
        LibraryReportDataset: Codeunit "Library - Report Dataset";
        LibraryVariableStorage: Codeunit "Library - Variable Storage";
        LibrarySetupStorage: Codeunit "Library - Setup Storage";
        Assert: Codeunit Assert;
        LibraryTestInitialize: Codeunit "Library - Test Initialize";
        isInitialized: Boolean;
        DocumentNo: Code[20];
        ArchiveDocMsg: Label 'Document %1 has been archived.', Comment = '%1 = Document No.';
        NoOfArchivedDocErr: Label 'Wrong number of archived documents.';

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandlerArchive')]
    [Scope('OnPrem')]
    procedure ArchivePurchReturnOrderOneVersion()
    var
        PurchaseHeader: Record "Purchase Header";
        TempPurchaseLine: Record "Purchase Line" temporary;
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        // [FEATURE] [Purchase] [Return Order]
        // Setup: Create Purchase Return Order with a number of lines.
        Initialize;
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::"Return Order", '');
        CreatePurchLines(TempPurchaseLine, PurchaseHeader, 1 + LibraryRandom.RandInt(5));
        DocumentNo := PurchaseHeader."No.";

        // Exercise: Archive Purchase Return Order.
        ArchiveManagement.ArchivePurchDocument(PurchaseHeader);

        // Verify: Archived lines.
        VerifyArchivedPurchRetOrder(TempPurchaseLine, PurchaseHeader, 1);
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandlerArchive')]
    [Scope('OnPrem')]
    procedure ArchivePurchReturnOrderTwoVersions()
    var
        PurchaseHeader: Record "Purchase Header";
        TempPurchaseLine: Record "Purchase Line" temporary;
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        // [FEATURE] [Purchase] [Return Order]
        // Setup: Create Purchase Return Order with a number of lines. Archive.
        Initialize;
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::"Return Order", '');
        CreatePurchLines(TempPurchaseLine, PurchaseHeader, 1 + LibraryRandom.RandInt(5));
        DocumentNo := PurchaseHeader."No.";
        ArchiveManagement.ArchivePurchDocument(PurchaseHeader);

        // Exercise: Add more lines and archive Purchase Return Order again.
        CreatePurchLines(TempPurchaseLine, PurchaseHeader, 1 + LibraryRandom.RandInt(5));
        ArchiveManagement.ArchivePurchDocument(PurchaseHeader);

        // Verify: Archived lines.
        VerifyArchivedPurchRetOrder(TempPurchaseLine, PurchaseHeader, 2);
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    [Scope('OnPrem')]
    procedure RestoreSalesRetOrderRestoresLineDiscountPriceCost()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesLineRestored: Record "Sales Line";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        // [FEATURE] [Sales] [Return Order]
        // [SCENARIO 381149] Restoring archived Sales Return Order should restore Line Discount, Unit Price and Unit Cost.

        // [GIVEN] Sales Return Order with Unit Price = "X", Line Discount % = "Y", Unit Cost = "Z".
        CreateSalesDocument(SalesHeader, SalesLine, SalesHeader."Document Type"::"Return Order");

        // [GIVEN] Archive Sales Return Order.
        ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);

        // [WHEN] Restore the archived Sales Return Order version.
        SalesHeader.Find;
        GetSalesHeaderArchivedVersion(SalesHeaderArchive, SalesHeader);
        ArchiveManagement.RestoreSalesDocument(SalesHeaderArchive);

        // [THEN] Unit Price = "X" and Line Discount % = "Y" in the restored document.
        SalesLineRestored.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.");
        SalesLineRestored.TestField("Unit Price", SalesLine."Unit Price");
        SalesLineRestored.TestField("Line Discount %", SalesLine."Line Discount %");

        // [THEN] Unit Cost = "Z" in the restored document.
        SalesLineRestored.TestField("Unit Cost", SalesLine."Unit Cost");
        SalesLineRestored.TestField("Unit Cost (LCY)", SalesLine."Unit Cost (LCY)");
    end;

    [Test]
    [HandlerFunctions('ReportHandlerPurchArchivedQuote')]
    [Scope('OnPrem')]
    procedure PrintArchivedPurchQuote()
    var
        PurchaseHeader: Record "Purchase Header";
        TempPurchaseLine: Record "Purchase Line" temporary;
        PurchaseHeaderArchive: Record "Purchase Header Archive";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        // [FEATURE] [Purchase] [Quote]
        // Setup: Create Purchase Return Order with a number of lines.
        Initialize;
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Quote, '');
        CreatePurchLines(TempPurchaseLine, PurchaseHeader, 1 + LibraryRandom.RandInt(5));
        DocumentNo := PurchaseHeader."No.";

        // Exercise: Archive Purchase Order.
        ArchiveManagement.ArchPurchDocumentNoConfirm(PurchaseHeader);
        PurchaseHeaderArchive.Get(PurchaseHeader."Document Type", PurchaseHeader."No.", 1, 1);
        SaveArchivedPurchQuote(PurchaseHeaderArchive);

        // Verify: Verify Saved Report Data.
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists('Purchase_Header_Archive_No_', PurchaseHeader."No.");
    end;

    [Test]
    [HandlerFunctions('ReportHandlerPurchArchivedOrder')]
    [Scope('OnPrem')]
    procedure PrintArchivedPurchOrder()
    var
        PurchaseHeader: Record "Purchase Header";
        TempPurchaseLine: Record "Purchase Line" temporary;
        PurchaseHeaderArchive: Record "Purchase Header Archive";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        // [FEATURE] [Purchase] [Order]
        // Setup: Create Purchase Return Order with a number of lines.
        Initialize;
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Order, '');
        CreatePurchLines(TempPurchaseLine, PurchaseHeader, 1 + LibraryRandom.RandInt(5));
        DocumentNo := PurchaseHeader."No.";

        // Exercise: Archive Purchase Order.
        ArchiveManagement.ArchPurchDocumentNoConfirm(PurchaseHeader);
        PurchaseHeaderArchive.Get(PurchaseHeader."Document Type", PurchaseHeader."No.", 1, 1);
        SaveArchivedPurchOrder(PurchaseHeaderArchive);

        // Verify: Verify Saved Report Data.
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists('ArchiveNo_PurchHeader', PurchaseHeader."No.");
    end;

    [Test]
    [HandlerFunctions('ReportHandlerPurchArchivedReturnOrder')]
    [Scope('OnPrem')]
    procedure PrintArchivedPurchReturnOrder()
    var
        PurchaseHeader: Record "Purchase Header";
        TempPurchaseLine: Record "Purchase Line" temporary;
        PurchaseHeaderArchive: Record "Purchase Header Archive";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        // [FEATURE] [Purchase] [Return Order]
        // Setup: Create Purchase Return Order with a number of lines.
        Initialize;
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::"Return Order", '');
        CreatePurchLines(TempPurchaseLine, PurchaseHeader, 1 + LibraryRandom.RandInt(5));
        DocumentNo := PurchaseHeader."No.";

        // Exercise: Archive Purchase Return Order.
        ArchiveManagement.ArchPurchDocumentNoConfirm(PurchaseHeader);
        PurchaseHeaderArchive.Get(PurchaseHeader."Document Type", PurchaseHeader."No.", 1, 1);
        SaveArchivedPurchReturnOrder(PurchaseHeaderArchive);

        // Verify: Verify Saved Report Data.
        LibraryReportDataset.LoadDataSetFile;
        LibraryReportDataset.AssertElementWithValueExists('No_PurchHdrArchive', PurchaseHeader."No.");
    end;

    [Test]
    [HandlerFunctions('OrderConfirmation_RPH')]
    [Scope('OnPrem')]
    procedure SalesOrderConfirmationWithoutArchiveAndDisabledArchiveSetup()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        // [FEATURE] [Sales] [Order] [Report] [Order Confirmation]
        // [SCENARIO 379837] Sales Order's Number of Archived Version = 0 after "Order Confirmation" report in case of "Archive Document" = FALSE and "Sales & Receivables Setup"."Archive Orders" = FALSE
        // this test also refers to tfs id 255792
        Initialize;

        // [GIVEN] "Sales & Receivables Setup"."Archive Orders" = FALSE
        LibrarySales.SetArchiveOrders(false);
        // [GIVEN] Sales Order
        CreateSalesDocument(SalesHeader, SalesLine, SalesHeader."Document Type"::Order);

        // [WHEN] Run "Order Confirmation" report with "Archive Document" = FALSE
        RunOrderConfirmationReport(SalesHeader."No.", false, true);

        // [THEN] Sales Order's "Number of Archived Version" = 0
        VerifyNoOfSalesArchivedDocs(SalesHeader, 0);
    end;

    [Test]
    [HandlerFunctions('OrderConfirmation_RPH')]
    [Scope('OnPrem')]
    procedure SalesOrderConfirmationWithoutArchiveAndEnabledArchiveSetup()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        // [FEATURE] [Sales] [Order] [Report] [Order Confirmation]
        // [SCENARIO 379837] Sales Order's Number of Archived Version = 0 after "Order Confirmation" report in case of "Archive Document" = FALSE and "Sales & Receivables Setup"."Archive Orders" = TRUE
        Initialize;

        // [GIVEN] "Sales & Receivables Setup"."Archive Orders" = TRUE
        LibrarySales.SetArchiveOrders(true);
        // [GIVEN] Sales Order
        CreateSalesDocument(SalesHeader, SalesLine, SalesHeader."Document Type"::Order);

        // [WHEN] Run "Order Confirmation" report with "Archive Document" = FALSE
        RunOrderConfirmationReport(SalesHeader."No.", false, true);

        // [THEN] Sales Order's "Number of Archived Version" = 0
        VerifyNoOfSalesArchivedDocs(SalesHeader, 0);
    end;

    [Test]
    [HandlerFunctions('OrderConfirmation_RPH')]
    [Scope('OnPrem')]
    procedure SalesOrderConfirmationWithArchiveAndDisabledArchiveSetup()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        // [FEATURE] [Sales] [Order] [Report] [Order Confirmation]
        // [SCENARIO 379837] Sales Order's Number of Archived Version = 1 after "Order Confirmation" report in case of "Archive Document" = TRUE and "Sales & Receivables Setup"."Archive Orders" = FALSE
        // this test also refers to tfs id 255792
        Initialize;

        // [GIVEN] "Sales & Receivables Setup"."Archive Orders" = FALSE
        LibrarySales.SetArchiveOrders(false);
        // [GIVEN] Sales Order
        CreateSalesDocument(SalesHeader, SalesLine, SalesHeader."Document Type"::Order);

        // [WHEN] Run "Order Confirmation" report with "Archive Document" = TRUE
        RunOrderConfirmationReport(SalesHeader."No.", true, true);

        // [THEN] Sales Order's "Number of Archived Version" = 1
        VerifyNoOfSalesArchivedDocs(SalesHeader, 1);
    end;

    [Test]
    [HandlerFunctions('OrderConfirmation_RPH')]
    [Scope('OnPrem')]
    procedure SalesOrderConfirmationWithArchiveAndEnabledArchiveSetup()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        // [FEATURE] [Sales] [Order] [Report] [Order Confirmation]
        // [SCENARIO 379837] Sales Order's Number of Archived Version = 1 after "Order Confirmation" report in case of "Archive Document" = TRUE and "Sales & Receivables Setup"."Archive Orders" = TRUE
        Initialize;

        // [GIVEN] "Sales & Receivables Setup"."Archive Orders" = TRUE
        LibrarySales.SetArchiveOrders(true);
        // [GIVEN] Sales Order
        CreateSalesDocument(SalesHeader, SalesLine, SalesHeader."Document Type"::Order);

        // [WHEN] Run "Order Confirmation" report with "Archive Document" = TRUE
        RunOrderConfirmationReport(SalesHeader."No.", true, true);

        // [THEN] Sales Order's "Number of Archived Version" = 1
        VerifyNoOfSalesArchivedDocs(SalesHeader, 1);
    end;

    [Test]
    [HandlerFunctions('OrderConfirmation_RH')]
    [Scope('OnPrem')]
    procedure SalesOrderEmailConfirmationDisabledArchiveSetup()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        // [FEATURE] [Sales] [Order] [Email Confirmation]
        // [SCENARIO 379837] Sales Order's Number of Archived Version = 0 after "Email Confirmation" and "Sales & Receivables Setup"."Archive Orders" = FALSE
        // this test also refers to tfs id 255792
        Initialize;

        // [GIVEN] "Sales & Receivables Setup"."Archive Orders" = FALSE
        LibrarySales.SetArchiveOrders(false);
        // [GIVEN] Sales Order
        CreateSalesDocument(SalesHeader, SalesLine, SalesHeader."Document Type"::Order);

        // [WHEN] Run "Email Confirmation" action
        RunOrderConfirmationReport(SalesHeader."No.", true, false);

        // [THEN] Sales Order's "Number of Archived Version" = 0
        VerifyNoOfSalesArchivedDocs(SalesHeader, 0);
    end;

    [Test]
    [HandlerFunctions('OrderConfirmation_RH')]
    [Scope('OnPrem')]
    procedure SalesOrderEmailConfirmationEnabledArchiveSetup()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        // [FEATURE] [Sales] [Order] [Email Confirmation]
        // [SCENARIO 379837] Sales Order's Number of Archived Version = 1 after "Email Confirmation" and "Sales & Receivables Setup"."Archive Orders" = TRUE
        Initialize;

        // [GIVEN] "Sales & Receivables Setup"."Archive Orders" = TRUE
        LibrarySales.SetArchiveOrders(true);
        // [GIVEN] Sales Order
        CreateSalesDocument(SalesHeader, SalesLine, SalesHeader."Document Type"::Order);

        // [WHEN] Run "Email Confirmation" action
        RunOrderConfirmationReport(SalesHeader."No.", true, false);

        // [THEN] Sales Order's "Number of Archived Version" = 1
        VerifyNoOfSalesArchivedDocs(SalesHeader, 1);
    end;

    [Test]
    [HandlerFunctions('SalesQuote_RH,ConfirmHandlerNo')]
    [Scope('OnPrem')]
    procedure SalesQuoteEmailDisabledArchiveSetup()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        // [FEATURE] [Sales] [Quote] [Email]
        // [SCENARIO 379837] Sales Quote's Number of Archived Version = 0 after "Email" and "Sales & Receivables Setup"."Archive Orders" = FALSE
        // this test also refers to tfs id 255792
        Initialize;

        // [GIVEN] "Sales & Receivables Setup"."Archive Orders" = FALSE
        LibrarySales.SetArchiveOrders(false);
        // [GIVEN] Sales Quote
        CreateSalesDocument(SalesHeader, SalesLine, SalesHeader."Document Type"::Quote);

        // [WHEN] Run "Email" action
        RunSalesQuoteReport(SalesHeader."No.", true, false);

        // [THEN] Sales Quote's "Number of Archived Version" = 0
        VerifyNoOfSalesArchivedDocs(SalesHeader, 0);
    end;

    [Test]
    [HandlerFunctions('SalesQuote_RH,ConfirmHandlerNo')]
    [Scope('OnPrem')]
    procedure SalesQuoteEmailEnabledArchiveSetup()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        // [FEATURE] [Sales] [Quote] [Email]
        // [SCENARIO 379837] Sales Quote's Number of Archived Version = 1 after "Email" and "Sales & Receivables Setup"."Archive Orders" = TRUE
        Initialize;

        // [GIVEN] "Sales & Receivables Setup"."Archive Orders" = TRUE
        LibrarySales.SetArchiveOrders(true);
        LibrarySales.SetArchiveQuoteAlways;

        // [GIVEN] Sales Quote
        CreateSalesDocument(SalesHeader, SalesLine, SalesHeader."Document Type"::Quote);

        // [WHEN] Run "Email" action
        RunSalesQuoteReport(SalesHeader."No.", true, false);

        // [THEN] Sales Quote's "Number of Archived Version" = 1
        VerifyNoOfSalesArchivedDocs(SalesHeader, 1);
    end;

    [Test]
    [Scope('OnPrem')]
    procedure DocNoOccurance_PurchaseHeader_InitRecord()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        // [FEATURE] [UT] [Doc. No. Occurrence] [Purchase]
        // [SCENARIO 382257] "Doc. No. Occurrence" = 1 on PurchaseHeader.InitRecord()
        Initialize;

        PurchaseHeader.Init;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader.InitRecord;
        Assert.AreEqual(1, PurchaseHeader."Doc. No. Occurrence", PurchaseHeader.FieldCaption("Doc. No. Occurrence"));
    end;

    [Test]
    [Scope('OnPrem')]
    procedure DocNoOccurance_PurchaseHeader_Insert()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        // [FEATURE] [UT] [Doc. No. Occurrence] [Purchase]
        // [SCENARIO 382257] "Doc. No. Occurrence" = 1 on PurchaseHeader.INSERT(TRUE)
        Initialize;

        PurchaseHeader.Init;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader.Insert(true);
        Assert.AreEqual(1, PurchaseHeader."Doc. No. Occurrence", PurchaseHeader.FieldCaption("Doc. No. Occurrence"));
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    [Scope('OnPrem')]
    procedure DocNoOccurance_PurchaseHeader_InitRecordAfterArchive()
    var
        PurchaseHeader: Record "Purchase Header";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        // [FEATURE] [UT] [Doc. No. Occurrence] [Purchase]
        // [SCENARIO 382257] "Doc. No. Occurrence" = 2 on PurchaseHeader.InitRecord() after archive

        PurchaseHeader.Init;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader.Insert(true);
        ArchiveManagement.ArchivePurchDocument(PurchaseHeader);
        PurchaseHeader.InitRecord;
        Assert.AreEqual(2, PurchaseHeader."Doc. No. Occurrence", PurchaseHeader.FieldCaption("Doc. No. Occurrence"));
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    [Scope('OnPrem')]
    procedure DocNoOccurance_PurchaseHeader_ClearBuyFromVendorNo()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        // [FEATURE] [Doc. No. Occurrence] [Purchase]
        // [SCENARIO 382257] "Doc. No. Occurrence" = 1 after clear "Buy-from Vendor No." field value
        Initialize;

        // [GIVEN] Purchase Order
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Order, LibraryPurchase.CreateVendorNo);

        // [WHEN] Clear "Buy-from Vendor No." field value
        PurchaseHeader.Validate("Buy-from Vendor No.", '');

        // [THEN] PurchaseHeader."Doc. No. Occurrence" = 1
        Assert.AreEqual(1, PurchaseHeader."Doc. No. Occurrence", PurchaseHeader.FieldCaption("Doc. No. Occurrence"));
    end;

    [Test]
    [Scope('OnPrem')]
    procedure DocNoOccurance_SalesHeader_InitRecord()
    var
        SalesHeader: Record "Sales Header";
    begin
        // [FEATURE] [UT] [Doc. No. Occurrence] [Sales]
        // [SCENARIO 382257] "Doc. No. Occurrence" = 1 on SalesHeader.InitRecord()
        Initialize;

        SalesHeader.Init;
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.InitRecord;
        Assert.AreEqual(1, SalesHeader."Doc. No. Occurrence", SalesHeader.FieldCaption("Doc. No. Occurrence"));
    end;

    [Test]
    [Scope('OnPrem')]
    procedure DocNoOccurance_SalesHeader_Insert()
    var
        SalesHeader: Record "Sales Header";
    begin
        // [FEATURE] [UT] [Doc. No. Occurrence] [Sales]
        // [SCENARIO 382257] "Doc. No. Occurrence" = 1 on SalesHeader.INSERT(TRUE)
        Initialize;

        SalesHeader.Init;
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.Insert(true);
        Assert.AreEqual(1, SalesHeader."Doc. No. Occurrence", SalesHeader.FieldCaption("Doc. No. Occurrence"));
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    [Scope('OnPrem')]
    procedure DocNoOccurance_SalesHeader_InitRecordAfterArchive()
    var
        SalesHeader: Record "Sales Header";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        // [FEATURE] [UT] [Doc. No. Occurrence] [Sales]
        // [SCENARIO 382257] "Doc. No. Occurrence" = 2 on SalesHeader.InitRecord() after archive
        Initialize;

        SalesHeader.Init;
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.Insert(true);
        ArchiveManagement.ArchiveSalesDocument(SalesHeader);
        SalesHeader.InitRecord;
        Assert.AreEqual(2, SalesHeader."Doc. No. Occurrence", SalesHeader.FieldCaption("Doc. No. Occurrence"));
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    [Scope('OnPrem')]
    procedure DocNoOccurance_SalesHeader_ClearSellToCustomer()
    var
        SalesHeader: Record "Sales Header";
    begin
        // [FEATURE] [Doc. No. Occurrence] [Sales]
        // [SCENARIO 382257] "Doc. No. Occurrence" = 1 after clear "Sell-to Customer No." field value
        Initialize;

        // [GIVEN] Sales Order
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Order, LibrarySales.CreateCustomerNo);

        // [WHEN] Clear "Sell-to Customer No." field value
        SalesHeader.Validate("Sell-to Customer No.", '');

        // [THEN] SalesHeader."Doc. No. Occurrence" = 1
        Assert.AreEqual(1, SalesHeader."Doc. No. Occurrence", SalesHeader.FieldCaption("Doc. No. Occurrence"));
    end;

    [Test]
    [HandlerFunctions('StandardPurchaseOrder_RPH')]
    [Scope('OnPrem')]
    procedure StandardPurchaseOrder_NotArchive()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseHeaderArchive: Record "Purchase Header Archive";
    begin
        // [FEATURE] [Purchase] [Report] [Standard Purchase - Order]
        // [SCENARIO 205113] REP 1322 "Standard Purchase - Order" doesn't archive order in case of "Archive Orders" = FALSE
        // this test also refers to tfs id 255792
        Initialize;

        // [GIVEN] "Purchases & Payables Setup"."Archive Orders" = FALSE
        LibraryPurchase.SetArchiveOrders(false);

        // [GIVEN] Purchase Order "PO"
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Order, LibraryPurchase.CreateVendorNo);

        // [GIVEN] Run REP 1322 "Standard Purchase - Order"
        // [GIVEN] Report request page's field "Archive Document" has predefined value = FALSE
        // [WHEN] Print the order
        DeleteObjectOptions;
        RunStandardPurchaseOrderReport(PurchaseHeader."No.", false);

        // [THEN] There is no archived "PO" purchase order
        PurchaseHeaderArchive.SetRange("No.", PurchaseHeader."No.");
        Assert.RecordIsEmpty(PurchaseHeaderArchive);
    end;

    [Test]
    [HandlerFunctions('StandardPurchaseOrder_RPH')]
    [Scope('OnPrem')]
    procedure StandardPurchaseOrder_Archive()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseHeaderArchive: Record "Purchase Header Archive";
    begin
        // [FEATURE] [Purchase] [Report] [Standard Purchase - Order]
        // [SCENARIO 205113] REP 1322 "Standard Purchase - Order" archives order in case of "Archive Orders" = TRUE
        // this test also refers to tfs id 255792
        Initialize;

        // [GIVEN] "Purchases & Payables Setup"."Archive Orders" = TRUE
        LibraryPurchase.SetArchiveOrders(true);

        // [GIVEN] Purchase Order "PO"
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Order, LibraryPurchase.CreateVendorNo);

        // [GIVEN] Run REP 1322 "Standard Purchase - Order"
        // [GIVEN] Report request page's field "Archive Document" has predefined value = TRUE
        // [WHEN] Print the order
        DeleteObjectOptions;
        RunStandardPurchaseOrderReport(PurchaseHeader."No.", true);

        // [THEN] There is an archived "PO" purchase order
        FilterPurchArchiveByDocument(PurchaseHeaderArchive, PurchaseHeader);
        Assert.RecordCount(PurchaseHeaderArchive, 1);
    end;

    [Test]
    [HandlerFunctions('GetReceiptLinesPageHandler,ConfirmHandler,MessageHandler')]
    [Scope('OnPrem')]
    procedure ArchiveInvoicedBlnktPurchOrderWithArchOrdersTrue()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseHeaderOrder: Record "Purchase Header";
        PurchaseHeaderArchive: Record "Purchase Header Archive";
    begin
        // [FEATURE] [Purchase] [Blanket Order]
        // [SCENARIO 255792] Archive Blanket Purchase Order must not be created when you delete a fully received and invoiced Blanket Purchase order with Delete Invoiced Blanket Purchase Order Report and option Archive Blanket Orders is enabled in Purchas

        Initialize;

        // [GIVEN] Blanket Purchase Order and Receipt for it
        CreateBlanketPurchOrderAndReceiptForIt(PurchaseHeader, PurchaseHeaderOrder);

        // [GIVEN] New Purchase Invoice for the same Vendor and "Get Receipt Lines", then post it
        CreatePurchInvFromReceipt(PurchaseHeader."Buy-from Vendor No.");

        // [GIVEN] Purchases & Payables Setup has "Archive Blanket Orders" = TRUE
        LibraryPurchase.SetArchiveBlanketOrders(true);

        // [WHEN] Run "Delete Invoiced Blanket Purchase Orders" (Report 491)
        PurchaseHeaderOrder.Delete(true);
        PurchaseHeader.SetRecFilter;
        RunDeletionReport(REPORT::"Delete Invd Blnkt Purch Orders", PurchaseHeader);

        // [THEN] Blanket Purchase Order is not archived
        FilterPurchArchiveByDocument(PurchaseHeaderArchive, PurchaseHeader);
        Assert.RecordCount(PurchaseHeaderArchive, 1);
    end;

    [Test]
    [HandlerFunctions('GetReceiptLinesPageHandler,ConfirmHandler,MessageHandler')]
    [Scope('OnPrem')]
    procedure ArchiveInvoicedBlnktPurchOrderWithArchOrdersFalse()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseHeaderOrder: Record "Purchase Header";
        PurchaseHeaderArchive: Record "Purchase Header Archive";
    begin
        // [FEATURE] [Purchase] [Blanket Order]
        // [SCENARIO 255792] Archive Blanket Purchase Order must not be created when you delete a fully received and invoiced Blanket Purchase order with Delete Invoiced Blanket Purchase Order Report and option Archive Blanket Orders is disabled in Purcha

        Initialize;

        // [GIVEN] Blanket Purchase Order and Receipt for it
        CreateBlanketPurchOrderAndReceiptForIt(PurchaseHeader, PurchaseHeaderOrder);

        // [GIVEN] New Purchase Invoice for the same Vendor and "Get Receipt Lines", then post it
        CreatePurchInvFromReceipt(PurchaseHeader."Buy-from Vendor No.");

        // [GIVEN] Purchases & Payables Setup has "Archive Blanket Orders" = FALSE
        LibraryPurchase.SetArchiveBlanketOrders(false);

        // [WHEN] Run "Delete Invoiced Blanket Purchase Orders" (Report 491)
        PurchaseHeaderOrder.Delete(true);
        PurchaseHeader.SetRecFilter;
        RunDeletionReport(REPORT::"Delete Invd Blnkt Purch Orders", PurchaseHeader);

        // [THEN] Blanket Purchase Order is not archived
        FilterPurchArchiveByDocument(PurchaseHeaderArchive, PurchaseHeader);
        Assert.RecordIsEmpty(PurchaseHeaderArchive);
    end;

    [Test]
    [HandlerFunctions('GetReceiptLinesPageHandler')]
    [Scope('OnPrem')]
    procedure ArchiveInvoicedPurchOrder()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseHeaderArchive: Record "Purchase Header Archive";
    begin
        // [FEATURE] [Purchase] [Order]
        // [SCENARIO 255792] Archive Purchase Order must be created when you delete a fully received and invoiced purchase order with Delete Invoiced Purchase Order Report and option Archive Orders is enabled in Purchases & Payables Setup.

        Initialize;

        // [GIVEN] Purchase Order and Receipt for it
        PostPurchaseDocumnet(PurchaseHeader, PurchaseHeader."Document Type"::Order);

        // [GIVEN] New Purchase Invoice for the same Vendor and "Get Receipt Lines", then post it
        CreatePurchInvFromReceipt(PurchaseHeader."Buy-from Vendor No.");

        // [GIVEN] Purchases & Payables Setup has "Archive Orders" = TRUE
        LibraryPurchase.SetArchiveOrders(true);

        // [WHEN] Run "Delete Invoiced Purch. Orders" (Report 499)
        PurchaseHeader.SetRecFilter;
        RunDeletionReport(REPORT::"Delete Invoiced Purch. Orders", PurchaseHeader);

        // [THEN] Purchase Order is archived
        FilterPurchArchiveByDocument(PurchaseHeaderArchive, PurchaseHeader);
        Assert.RecordCount(PurchaseHeaderArchive, 1);
    end;

    [Test]
    [HandlerFunctions('GetReturnShipmentLinesForPurchasePageHandler')]
    [Scope('OnPrem')]
    procedure ArchiveInvoicedPurchRetOrderWithArchOrdersTrue()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseHeaderArchive: Record "Purchase Header Archive";
    begin
        // [FEATURE] [Purchase] [Return Order]
        // [SCENARIO 255792] Archive Purchase Return Order must be created when you delete a fully received and invoiced purchase order with Delete Invoiced Purchase Order Report and option Archive Return Orders is enabled in Purchases & Payables Set

        Initialize;

        // [GIVEN] Purchase Return Order and Receipt for it
        PostPurchaseDocumnet(PurchaseHeader, PurchaseHeader."Document Type"::"Return Order");

        // [GIVEN] New Purchase Cr Memo for the same Vendor and "Get Return Shipment Lines", then post it
        CreatePurchCrMemoFromReturnShipment(PurchaseHeader."Buy-from Vendor No.");

        // [GIVEN] Purchases & Payables Setup has "Archive Return Orders" = TRUE
        LibraryPurchase.SetArchiveReturnOrders(true);

        // [WHEN] Run "Delete Invoiced Purch. Ret. Orders" (Report 6661)
        PurchaseHeader.SetRecFilter;
        RunDeletionReport(REPORT::"Delete Invd Purch. Ret. Orders", PurchaseHeader);

        // [THEN] Purchase Return Order is archived
        FilterPurchArchiveByDocument(PurchaseHeaderArchive, PurchaseHeader);
        Assert.RecordCount(PurchaseHeaderArchive, 1);
    end;

    [Test]
    [HandlerFunctions('GetReturnShipmentLinesForPurchasePageHandler')]
    [Scope('OnPrem')]
    procedure ArchiveInvoicedPurchRetOrderWithArchOrdersFalse()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseHeaderArchive: Record "Purchase Header Archive";
    begin
        // [FEATURE] [Purchase] [Return Order]
        // [SCENARIO 255792] Archive Purchase Return Order must not be created when you delete a fully received and invoiced purchase order with Delete Invoiced Purchase Order Report and option Archive Return Orders is disabled in Purchases & Payables Se

        Initialize;

        // [GIVEN] Purchase Return Order and Receipt for it
        PostPurchaseDocumnet(PurchaseHeader, PurchaseHeader."Document Type"::"Return Order");

        // [GIVEN] New Purchase Cr Memo for the same Vendor and "Get Return Shipment Lines", then post it
        CreatePurchCrMemoFromReturnShipment(PurchaseHeader."Buy-from Vendor No.");

        // [GIVEN] Purchases & Payables Setup has "Archive Return Orders" = FALSE
        LibraryPurchase.SetArchiveReturnOrders(false);

        // [WHEN] Run "Delete Invoiced Purch. Ret. Orders" (Report 6661)
        PurchaseHeader.SetRecFilter;
        RunDeletionReport(REPORT::"Delete Invd Purch. Ret. Orders", PurchaseHeader);

        // [THEN] Purchase Return Order is not archived
        FilterPurchArchiveByDocument(PurchaseHeaderArchive, PurchaseHeader);
        Assert.RecordIsEmpty(PurchaseHeaderArchive);
    end;

    [Test]
    [HandlerFunctions('GetShipmentLinesHandler')]
    [Scope('OnPrem')]
    procedure ArchiveInvoicedSalesOrder()
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        // [FEATURE] [Sales] [Order]
        // [SCENARIO 255792] Archive Sales Order must be created when you delete a fully shiped and invoiced sales order with Delete Invoiced Sales Order Report and option Archive Orders is enabled in Sales & Receivables Setup.

        Initialize;

        // [GIVEN] Sales Order and Shipment for it
        PostSalesDocumnet(SalesHeader, SalesHeader."Document Type"::Order);

        // [GIVEN] New Sales Invoice for the same Customer and "Get Shipment Lines", then post it
        CreateSalesInvFromShipment(SalesHeader."Sell-to Customer No.");

        // [GIVEN] Sales  & Receivables Setup has "Archive Orders" = TRUE
        LibrarySales.SetArchiveOrders(true);

        // [WHEN] Run "Delete Invoiced Sales Orders" (Report 299)
        SalesHeader.SetRecFilter;
        RunDeletionReport(REPORT::"Delete Invoiced Sales Orders", SalesHeader);

        // [THEN] Sales Order is archived
        FilterSalesArchiveByDocument(SalesHeaderArchive, SalesHeader);
        Assert.RecordCount(SalesHeaderArchive, 1);
    end;

    [Test]
    [HandlerFunctions('GetReturnReceiptLines')]
    [Scope('OnPrem')]
    procedure ArchiveInvoicedSalesRetOrderWithArchOrdersTrue()
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        // [FEATURE] [Sales] [Return Order]
        // [SCENARIO 255792] Archive Sales Return Order must be created when you delete a fully shipped and invoiced sales return order with Delete Invd Sales Ret. Orders Report and option Archive Return Orders is enabled in Sales & Receivables Setup.

        Initialize;

        // [GIVEN] Sales Return Order and Shipment for it
        PostSalesDocumnet(SalesHeader, SalesHeader."Document Type"::"Return Order");

        // [GIVEN] New Sales Cr Memo for the same Vendor and "Sales-Get Return Receipts", then post it
        CreateSalesCrMemoFromReturnReceipt(SalesHeader."Sell-to Customer No.");

        // [GIVEN] Sales & Receivables Setup has "Archive Return Orders" = TRUE
        LibrarySales.SetArchiveReturnOrders(true);

        // [WHEN] Run "Delete Invoiced Sales Ret. Orders" (Report 6651)
        SalesHeader.SetRecFilter;
        RunDeletionReport(REPORT::"Delete Invd Sales Ret. Orders", SalesHeader);

        // [THEN] Sales Return Order is archived
        FilterSalesArchiveByDocument(SalesHeaderArchive, SalesHeader);
        Assert.RecordCount(SalesHeaderArchive, 1);
    end;

    [Test]
    [HandlerFunctions('GetReturnReceiptLines')]
    [Scope('OnPrem')]
    procedure ArchiveInvoicedSalesRetWithArchOrdersFalse()
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        // [FEATURE] [Sales] [Return Order]
        // [SCENARIO 255792] Archive Sales Return Order must not be created when you delete a fully shipped and invoiced sales order with Delete Invoiced Sales Order Report and option Archive Quote and Order is disabled in Sales & Receivables Setup.

        Initialize;

        // [GIVEN] Sales Return Order and Shipment for it
        PostSalesDocumnet(SalesHeader, SalesHeader."Document Type"::"Return Order");

        // [GIVEN] New Sales Cr Memo for the same Vendor and "Sales-Get Return Receipts", then post it
        CreateSalesCrMemoFromReturnReceipt(SalesHeader."Sell-to Customer No.");

        // [GIVEN] Sales & Receivables Setup has "Archive Return Orders" = FALSE
        LibrarySales.SetArchiveReturnOrders(false);

        // [WHEN] Run "Delete Invoiced Sales Ret. Orders" (Report 6651)
        SalesHeader.SetRecFilter;
        RunDeletionReport(REPORT::"Delete Invd Sales Ret. Orders", SalesHeader);

        // [THEN] Sales Return Order is not archived
        FilterSalesArchiveByDocument(SalesHeaderArchive, SalesHeader);
        Assert.RecordCount(SalesHeaderArchive, 0);
    end;

    [Test]
    [HandlerFunctions('GetShipmentLinesHandler,ConfirmHandler,MessageHandler')]
    [Scope('OnPrem')]
    procedure ArchiveInvoicedBlnktSalesOrderWithArchOrdersTrue()
    var
        SalesHeaderBlanketOrder: Record "Sales Header";
        SalesHeaderOrder: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
    begin
        // [FEATURE] [Sales] [Blanket Order]
        // [SCENARIO 255792] Archive Blanket Sales Order must be created when you delete a fully shiped and invoiced Blanket sales order with Delete Invoiced Blanket Sales Order Report and option Archive Blanket Orders is enabled in Sales & Receivable

        Initialize;

        // [GIVEN] Blanket Sales Order and Shipment for it
        CreateBlanketSalesOrderAndShipmentForIt(SalesHeaderBlanketOrder, SalesHeaderOrder);

        // [GIVEN] New Sales Invoice for the same Customer and "Get Shipment Lines", then post it
        CreateSalesInvFromShipment(SalesHeaderBlanketOrder."Sell-to Customer No.");

        // [GIVEN] Sales  & Receivables Setup has "Archive Blanket Orders" = TRUE
        LibrarySales.SetArchiveBlanketOrders(true);

        // [WHEN] Run "Delete Invoiced Blanket Sales Orders" (Report 291)
        SalesHeaderOrder.Find;
        SalesHeaderOrder.Delete(true);
        SalesHeaderBlanketOrder.SetRecFilter;
        RunDeletionReport(REPORT::"Delete Invd Blnkt Sales Orders", SalesHeaderBlanketOrder);

        // [THEN] Blanket Sales Order is archived
        FilterSalesArchiveByDocument(SalesHeaderArchive, SalesHeaderBlanketOrder);
        Assert.RecordCount(SalesHeaderArchive, 1);
        NotificationLifecycleMgt.RecallAllNotifications;
    end;

    [Test]
    [HandlerFunctions('GetShipmentLinesHandler,ConfirmHandler,MessageHandler')]
    [Scope('OnPrem')]
    procedure ArchiveInvoicedBlnktSalesOrderWithArchOrdersFalse()
    var
        SalesHeaderBlanketOrder: Record "Sales Header";
        SalesHeaderOrder: Record "Sales Header";
        SalesHeaderArchive: Record "Sales Header Archive";
        NotificationLifecycleMgt: Codeunit "Notification Lifecycle Mgt.";
    begin
        // [FEATURE] [Sales] [Blanket Order]
        // [SCENARIO 255792] Archive Blanket Sales Order must not be created when you delete a fully shiped and invoiced Blanket sales order with Delete Invoiced Blanket Sales Order Report and option Archive Blanket Orders is disabled in Sales & Receivabl

        Initialize;

        // [GIVEN] Blanket Sales Order and Shipment for it
        CreateBlanketSalesOrderAndShipmentForIt(SalesHeaderBlanketOrder, SalesHeaderOrder);

        // [GIVEN] New Sales Invoice for the same Customer and "Get Shipment Lines", then post it
        CreateSalesInvFromShipment(SalesHeaderBlanketOrder."Sell-to Customer No.");

        // [GIVEN] Sales  & Receivables Setup has "Archive Blanket Orders" = FALSE
        LibrarySales.SetArchiveBlanketOrders(false);

        // [WHEN] Run "Delete Invoiced Blanket Sales Orders" (Report 291)
        SalesHeaderBlanketOrder.SetRecFilter;
        RunDeletionReport(REPORT::"Delete Invd Blnkt Sales Orders", SalesHeaderBlanketOrder);

        // [THEN] Blanket Sales Order is not archived
        FilterSalesArchiveByDocument(SalesHeaderArchive, SalesHeaderBlanketOrder);
        Assert.RecordCount(SalesHeaderArchive, 0);
        NotificationLifecycleMgt.RecallAllNotifications;
    end;

    local procedure Initialize()
    var
        LibraryERMCountryData: Codeunit "Library - ERM Country Data";
    begin
        LibraryTestInitialize.OnTestInitialize(CODEUNIT::"SCM Archive Orders");
        Clear(DocumentNo);
        LibraryVariableStorage.Clear;
        LibrarySetupStorage.Restore;

        // Lazy Setup.
        if isInitialized then
            exit;
        LibraryTestInitialize.OnBeforeTestSuiteInitialize(CODEUNIT::"SCM Archive Orders");

        LibraryERMCountryData.UpdateGeneralPostingSetup;
        LibraryERMCountryData.CreateVATData;
        LibrarySetupStorage.Save(DATABASE::"Sales & Receivables Setup");
        LibrarySetupStorage.Save(DATABASE::"Purchases & Payables Setup");

        isInitialized := true;
        Commit;
        LibraryTestInitialize.OnAfterTestSuiteInitialize(CODEUNIT::"SCM Archive Orders");
    end;

    local procedure VerifyArchivedPurchRetOrder(var TempPurchaseLine: Record "Purchase Line" temporary; PurchaseHeader: Record "Purchase Header"; VersionNo: Integer)
    var
        PurchaseHeaderArchive: Record "Purchase Header Archive";
        PurchaseLineArchive: Record "Purchase Line Archive";
    begin
        // Verify archived Header.
        PurchaseHeaderArchive.Get(PurchaseHeader."Document Type", PurchaseHeader."No.", 1, VersionNo);
        PurchaseHeaderArchive.TestField("Archived By", UserId);
        PurchaseHeaderArchive.TestField("Date Archived", WorkDate);

        // Get actual archived lines.
        PurchaseLineArchive.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLineArchive.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLineArchive.SetRange("Version No.", VersionNo);
        PurchaseLineArchive.SetRange("Doc. No. Occurrence", 1);
        PurchaseLineArchive.FindSet;

        // Verify archived lines.
        TempPurchaseLine.FindSet;
        repeat
            TempPurchaseLine.SetRange("Document Type", PurchaseLineArchive."Document Type");
            TempPurchaseLine.SetRange("Document No.", PurchaseLineArchive."Document No.");
            TempPurchaseLine.SetRange(Type, PurchaseLineArchive.Type);
            TempPurchaseLine.SetRange("No.", PurchaseLineArchive."No.");
            TempPurchaseLine.SetRange(Quantity, PurchaseLineArchive.Quantity);
            TempPurchaseLine.SetRange("Unit of Measure", PurchaseLineArchive."Unit of Measure");
            TempPurchaseLine.SetRange(Amount, PurchaseLineArchive.Amount);
            Assert.AreEqual(1, TempPurchaseLine.Count, 'Archive line mismatch for line ' + Format(TempPurchaseLine."Line No."));
            TempPurchaseLine.FindFirst;
            TempPurchaseLine.Delete(true);
        until PurchaseLineArchive.Next = 0;

        // Verify there are no un-archived lines.
        TempPurchaseLine.Reset;
        Assert.AreEqual(0, TempPurchaseLine.Count, 'Remaining un-archived lines.');
    end;

    local procedure CreateBlanketPurchOrderAndReceiptForIt(var PurchaseHeader: Record "Purchase Header"; var PurchaseHeaderOrder: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::"Blanket Order", LibraryPurchase.CreateVendorNo);
        LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, LibraryInventory.CreateItemNo, 1);
        CODEUNIT.Run(CODEUNIT::"Blnkt Purch Ord. to Ord. (Y/N)", PurchaseHeader);
        PurchaseHeaderOrder.SetRange("Document Type", PurchaseHeaderOrder."Document Type"::Order);
        PurchaseHeaderOrder.SetRange("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        PurchaseHeaderOrder.FindFirst;
        LibraryPurchase.PostPurchaseDocument(PurchaseHeaderOrder, true, false);
    end;

    local procedure CreateBlanketSalesOrderAndShipmentForIt(var SalesHeader: Record "Sales Header"; var SalesHeaderOrder: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::"Blanket Order", LibrarySales.CreateCustomerNo);
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, LibraryInventory.CreateItemNo, 1);
        CODEUNIT.Run(CODEUNIT::"Blnkt Sales Ord. to Ord. (Y/N)", SalesHeader);
        SalesHeaderOrder.SetRange("Document Type", SalesHeaderOrder."Document Type"::Order);
        SalesHeaderOrder.SetRange("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        SalesHeaderOrder.FindFirst;
        LibrarySales.PostSalesDocument(SalesHeaderOrder, true, false);
    end;

    local procedure CreatePurchCrMemoFromReturnShipment(VendorNo: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchase.CreatePurchHeader(
          PurchaseHeader, PurchaseHeader."Document Type"::"Credit Memo", VendorNo);
        LibraryPurchase.CreatePurchaseLineSimple(PurchaseLine, PurchaseHeader);
        CODEUNIT.Run(CODEUNIT::"Purch.-Get Return Shipments", PurchaseLine);
        LibraryPurchase.PostPurchaseDocument(PurchaseHeader, false, true);
    end;

    local procedure CreatePurchInvFromReceipt(VendorNo: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, PurchaseHeader."Document Type"::Invoice, VendorNo);
        LibraryPurchase.CreatePurchaseLineSimple(PurchaseLine, PurchaseHeader);
        CODEUNIT.Run(CODEUNIT::"Purch.-Get Receipt", PurchaseLine);
        LibraryPurchase.PostPurchaseDocument(PurchaseHeader, false, true);
    end;

    local procedure CreatePurchLines(var TempPurchaseLine: Record "Purchase Line" temporary; PurchaseHeader: Record "Purchase Header"; NoOfLines: Integer)
    var
        Item: Record Item;
        PurchaseLine: Record "Purchase Line";
        i: Integer;
    begin
        for i := 1 to NoOfLines do begin
            LibraryInventory.CreateItem(Item);
            LibraryPurchase.CreatePurchaseLine(
              PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, Item."No.", LibraryRandom.RandDec(10, 2));
            TempPurchaseLine := PurchaseLine;
            TempPurchaseLine.Insert;
        end;
    end;

    local procedure CreateSalesCrMemoFromReturnReceipt(CustomerNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::"Credit Memo", CustomerNo);
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        CODEUNIT.Run(CODEUNIT::"Sales-Get Return Receipts", SalesLine);
        LibrarySales.PostSalesDocument(SalesHeader, false, true);
    end;

    local procedure CreateSalesDocument(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; DocumentType: Option)
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, DocumentType, '');
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, '', 1);
        SalesLine.Validate("Unit Price", LibraryRandom.RandDecInRange(100, 1000, 2));
        SalesLine.Validate("Line Discount %", LibraryRandom.RandIntInRange(10, 50));
        SalesLine.Validate("Unit Cost (LCY)", LibraryRandom.RandDec(10, 2));
        SalesLine.Modify(true);
    end;

    local procedure CreateSalesInvFromShipment(CustomerNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, SalesHeader."Document Type"::Invoice, CustomerNo);
        LibrarySales.CreateSalesLineSimple(SalesLine, SalesHeader);
        CODEUNIT.Run(CODEUNIT::"Sales-Get Shipment", SalesLine);
        LibrarySales.PostSalesDocument(SalesHeader, false, true);
    end;

    local procedure FilterPurchArchiveByDocument(var PurchaseHeaderArchive: Record "Purchase Header Archive"; PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeaderArchive.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseHeaderArchive.SetRange("No.", PurchaseHeader."No.");
    end;

    local procedure FilterSalesArchiveByDocument(var SalesHeaderArchive: Record "Sales Header Archive"; SalesHeader: Record "Sales Header")
    begin
        SalesHeaderArchive.SetRange("Document Type", SalesHeader."Document Type");
        SalesHeaderArchive.SetRange("No.", SalesHeader."No.");
    end;

    local procedure MockSalesHeaderArchive(var SalesHeaderArchive: Record "Sales Header Archive")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeaderArchive.Init;
        SalesHeaderArchive."Document Type" := SalesHeaderArchive."Document Type"::Order;
        SalesHeaderArchive."No." := LibraryUtility.GenerateRandomCode(SalesHeader.FieldNo("No."), DATABASE::"Sales Header");
        SalesHeaderArchive.Insert(true);
    end;

    local procedure MockPurchaseHeaderArchive(var PurchaseHeaderArchive: Record "Purchase Header Archive")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeaderArchive.Init;
        PurchaseHeaderArchive."Document Type" := PurchaseHeaderArchive."Document Type"::Order;
        PurchaseHeaderArchive."No." := LibraryUtility.GenerateRandomCode(PurchaseHeader.FieldNo("No."), DATABASE::"Purchase Header");
        PurchaseHeaderArchive.Insert(true);
    end;

    local procedure GetSalesHeaderArchivedVersion(var SalesHeaderArchive: Record "Sales Header Archive"; SalesHeader: Record "Sales Header")
    begin
        with SalesHeader do begin
            CalcFields("No. of Archived Versions");
            SalesHeaderArchive.Get("Document Type", "No.", "Doc. No. Occurrence", "No. of Archived Versions");
        end;
    end;

    local procedure PostPurchaseDocumnet(var PurchaseHeader: Record "Purchase Header"; DocType: Option)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        LibraryPurchase.CreatePurchHeader(PurchaseHeader, DocType, LibraryPurchase.CreateVendorNo);
        LibraryPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, LibraryInventory.CreateItemNo, 1);
        LibraryPurchase.PostPurchaseDocument(PurchaseHeader, true, false);
    end;

    local procedure PostSalesDocumnet(var SalesHeader: Record "Sales Header"; DocType: Option)
    var
        SalesLine: Record "Sales Line";
    begin
        LibrarySales.CreateSalesHeader(SalesHeader, DocType, LibrarySales.CreateCustomerNo);
        LibrarySales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, LibraryInventory.CreateItemNo, 1);
        LibrarySales.PostSalesDocument(SalesHeader, true, false);
    end;

    local procedure SaveArchivedPurchQuote(var PurchaseHeaderArchive: Record "Purchase Header Archive")
    var
        ArchivedPurchaseQuote: Report "Archived Purchase Quote";
    begin
        Commit; // Required to run report with request page.
        Clear(ArchivedPurchaseQuote);
        PurchaseHeaderArchive.SetRecFilter;
        ArchivedPurchaseQuote.SetTableView(PurchaseHeaderArchive);
        ArchivedPurchaseQuote.Run;
    end;

    local procedure SaveArchivedPurchOrder(var PurchaseHeaderArchive: Record "Purchase Header Archive")
    var
        ArchivedPurchaseOrder: Report "Archived Purchase Order";
    begin
        Commit; // Required to run report with request page.
        Clear(ArchivedPurchaseOrder);
        PurchaseHeaderArchive.SetRecFilter;
        ArchivedPurchaseOrder.SetTableView(PurchaseHeaderArchive);
        ArchivedPurchaseOrder.Run;
    end;

    local procedure SaveArchivedPurchReturnOrder(var PurchaseHeaderArchive: Record "Purchase Header Archive")
    var
        ArchPurchReturnOrder: Report "Arch.Purch. Return Order";
    begin
        Commit; // Required to run report with request page.
        Clear(ArchPurchReturnOrder);
        PurchaseHeaderArchive.SetRecFilter;
        ArchPurchReturnOrder.SetTableView(PurchaseHeaderArchive);
        ArchPurchReturnOrder.Run;
    end;

    local procedure RunDeletionReport(ReportID: Integer; Rec: Variant)
    begin
        REPORT.RunModal(ReportID, false, false, Rec);
    end;

    local procedure RunOrderConfirmationReport(DocumentNo: Code[20]; Archive: Boolean; UseRequestPage: Boolean)
    var
        SalesHeader: Record "Sales Header";
        OrderConfirmation: Report "Order Confirmation";
    begin
        SalesHeader.SetRange("No.", DocumentNo);
        LibraryVariableStorage.Enqueue(Archive);
        Commit;
        OrderConfirmation.SetTableView(SalesHeader);
        OrderConfirmation.UseRequestPage(UseRequestPage);
        OrderConfirmation.RunModal;
    end;

    local procedure RunSalesQuoteReport(DocumentNo: Code[20]; Archive: Boolean; UseRequestPage: Boolean)
    var
        SalesHeader: Record "Sales Header";
        SalesQuote: Report "Sales - Quote";
    begin
        SalesHeader.SetRange("No.", DocumentNo);
        LibraryVariableStorage.Enqueue(Archive);
        Commit;
        SalesQuote.SetTableView(SalesHeader);
        SalesQuote.UseRequestPage(UseRequestPage);
        SalesQuote.RunModal;
    end;

    local procedure RunStandardPurchaseOrderReport(OrderNo: Code[20]; ExpectedArchiveValue: Boolean)
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        LibraryVariableStorage.Enqueue(ExpectedArchiveValue);
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.SetRange("No.", OrderNo);
        Commit;
        REPORT.Run(REPORT::"Standard Purchase - Order", true, false, PurchaseHeader);
    end;

    local procedure VerifyNoOfSalesArchivedDocs(SalesHeader: Record "Sales Header"; ExpectedCount: Integer)
    begin
        SalesHeader.CalcFields("No. of Archived Versions");
        Assert.AreEqual(ExpectedCount, SalesHeader."No. of Archived Versions", NoOfArchivedDocErr);
    end;

    local procedure DeleteObjectOptions()
    var
        ObjectOptions: Record "Object Options";
    begin
        ObjectOptions.DeleteAll;
    end;

    [ConfirmHandler]
    [Scope('OnPrem')]
    procedure ConfirmHandler(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    [ConfirmHandler]
    [Scope('OnPrem')]
    procedure ConfirmHandlerNo(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := false;
    end;

    [MessageHandler]
    [Scope('OnPrem')]
    procedure MessageHandlerArchive(Message: Text[1024])
    begin
        Assert.AreEqual(StrSubstNo(ArchiveDocMsg, DocumentNo), Message, 'Wrong archiving message.');
    end;

    [MessageHandler]
    [Scope('OnPrem')]
    procedure MessageHandler(Message: Text[1024])
    begin
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure ReportHandlerPurchArchivedReturnOrder(var ArchPurchReturnOrder: TestRequestPage "Arch.Purch. Return Order")
    begin
        ArchPurchReturnOrder.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure ReportHandlerPurchArchivedOrder(var ArchivedPurchaseOrder: TestRequestPage "Archived Purchase Order")
    begin
        ArchivedPurchaseOrder.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure ReportHandlerPurchArchivedQuote(var ArchivedPurchaseQuote: TestRequestPage "Archived Purchase Quote")
    begin
        ArchivedPurchaseQuote.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure OrderConfirmation_RPH(var OrderConfirmation: TestRequestPage "Order Confirmation")
    begin
        OrderConfirmation.ArchiveDocument.SetValue(LibraryVariableStorage.DequeueBoolean);
        OrderConfirmation.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [ReportHandler]
    [Scope('OnPrem')]
    procedure OrderConfirmation_RH(var OrderConfirmation: Report "Order Confirmation")
    begin
        OrderConfirmation.SaveAsXml(LibraryReportDataset.GetParametersFileName);
    end;

    [ReportHandler]
    [Scope('OnPrem')]
    procedure SalesQuote_RH(var SalesQuote: Report "Sales - Quote")
    begin
        SalesQuote.SaveAsXml(LibraryReportDataset.GetParametersFileName);
    end;

    [RequestPageHandler]
    [Scope('OnPrem')]
    procedure StandardPurchaseOrder_RPH(var StandardPurchaseOrder: TestRequestPage "Standard Purchase - Order")
    begin
        StandardPurchaseOrder.ArchiveDocument.AssertEquals(LibraryVariableStorage.DequeueBoolean);
        StandardPurchaseOrder.SaveAsXml(LibraryReportDataset.GetParametersFileName, LibraryReportDataset.GetFileName);
    end;

    [ModalPageHandler]
    [Scope('OnPrem')]
    procedure GetReceiptLinesPageHandler(var GetReceiptLines: TestPage "Get Receipt Lines")
    begin
        GetReceiptLines.OK.Invoke;
    end;

    [ModalPageHandler]
    [Scope('OnPrem')]
    procedure GetReturnShipmentLinesForPurchasePageHandler(var GetReturnShipmentLines: TestPage "Get Return Shipment Lines")
    begin
        GetReturnShipmentLines.OK.Invoke;
    end;

    [ModalPageHandler]
    [Scope('OnPrem')]
    procedure GetReturnReceiptLines(var GetReturnReceiptLines: TestPage "Get Return Receipt Lines")
    begin
        GetReturnReceiptLines.OK.Invoke;
    end;

    [ModalPageHandler]
    [Scope('OnPrem')]
    procedure GetShipmentLinesHandler(var GetShipmentLines: TestPage "Get Shipment Lines")
    begin
        GetShipmentLines.First;
        GetShipmentLines.OK.Invoke;
    end;
}

