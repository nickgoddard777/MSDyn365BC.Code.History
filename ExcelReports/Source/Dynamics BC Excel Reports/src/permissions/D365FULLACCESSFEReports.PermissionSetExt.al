// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------

namespace Microsoft.ExcelReports;

using System.Security.AccessControl;

permissionsetextension 4403 "D365 FULL ACCESS - FE Reports" extends "D365 FULL ACCESS"
{
    IncludedPermissionSets = "Excel Reports - Objects";
}
