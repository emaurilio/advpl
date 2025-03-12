#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

User Function IntegrationVExpenses()
    RpcSetEnv("99", "01")
    Local oJson := JSonObject():New()
    Local cPath := "reports/status/APROVADO?include=expenses,user,expenses.apportionment,expenses.expense_type,expenses.costs_center,expenses.payment_method,advance&search=approval_date:2025-03-09&searchFields=approval_date:=&searchJoin=and"
    Local cApiReturn
    Local oData, nI, nJ, nLen, nLenExp
    Local oExpenses, oSupplier
    Local cToken := SuperGetMV("MV_TOKEN",, "", FWxFilial("SM0"))
    Local aErrors := {}

    cApiReturn := U_ApiRequisition(cPath, cToken, "GET", "")

    oJSon:fromJson(cApiReturn)

    If oJson:GetJsonText("success") <> "true"
        ConOut(oJson:GetJsonText("success"))
        aadd(aErrors, "Erro ao consultar API: " + oJson:GetJsonText("message"))
        U_SendEmailErrors(aErrors)
        Return
    EndIf

    oData := oJson:GetJsonObject("data")

    nLen := Len(oData)
    
    For nI := 1 To nLen
        oSupplier := oData[nI]:GetJsonObject("user"):GetJsonObject("data")
        cCodSupplier := oSupplier:GetJsonText("integration_id")

        If empty(cCodSupplier) .OR. cCodSupplier = "null"
            cEmailSupplier := oSupplier:GetJsonText("email")
            aadd(aErrors, "Código do fornecedor: "+ cEmailSupplier +" está vazio")
            loop
        Endif

        cCodReport = cValToChar(oData[nI]:GetJsonText("id"))
        cReportDescription = oData[nI]:GetJsonText("description")
        cEmissionDate = oData[nI]:GetJsonText("approval_date")
        
        oExpenses := oData[nI]:GetJsonObject("expenses"):GetJsonObject("data")
        nLenExp := Len(oExpenses) 

        For nJ := 1 To nLenExp
            nValueExpenses := Val(oExpenses[nJ]:GetJsonText("value"))
            cExpensesNum := oExpenses[nJ]:GetJsonText("id")
            cExpenseTypeCode := oExpenses[nJ]:GetJsonObject("expense_type"):GetJsonObject("data"):GetJsonText("integration_id")
            cCostCenterCode := oExpenses[nJ]:GetJsonObject("costs_center"):GetJsonObject("data"):GetJsonText("integration_id")

            If empty(cExpenseTypeCode) .OR. cExpenseTypeCode = "null"
                cDescripExpType = oExpenses[nJ]:GetJsonObject("expense_type"):GetJsonObject("data"):GetJsonText("description")
                aadd(aErrors, "Código do tipo de despesa: "+ cDescripExpType +" está vazio")
                loop
            Endif

            If empty(cCostCenterCode) .OR. cCostCenterCode = "null"
                cNameCostCenter := oExpenses[nJ]:GetJsonObject("costs_center"):GetJsonObject("data"):GetJsonText("name")
                aadd(aErrors, "Código do Centro de Custos: "+ cNameCostCenter +" está vazio")
                loop
            Endif

            lSendToProtheus := U_CreateAPVExpenses(cEmissionDate, cCodReport, cCodSupplier, nValueExpenses, cExpensesNum, cCostCenterCode, cExpenseTypeCode)

            If !lSendToProtheus
                nIdExp := Val(oExpenses[nJ]:GetJsonText("id"))
                aadd(aErrors, "Erro ao criar o contas a pagar. Código da Despesa: "+ nIdExp)
            Endif

        Next nJ
    Next nI

    If Len(aErrors) < 0
        U_SendEmailErrors(aErrors)
    Endif

    RpcClearEnv()

Return
