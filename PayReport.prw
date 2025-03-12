User Function PayReport()
    RpcSetEnv("99", "01")
    Local cQuery := ""
    Local nI := 0
    Local nTotal := 0
    Local cToken := SuperGetMV("MV_TOKEN",, "", FWxFilial("SM0"))
    Local aErrors := {}
    Local oJson := JSonObject():New()

    cQuery := " SELECT DISTINCT(E2_HIST), E2_NUM, E2_PREFIXO, E2_FORNECE, E2_LOJA, E2_VALOR, E2_BAIXA "
    cQuery += " FROM " + RetSqlName("SE2") + " SE2 "
    cQuery += " WHERE SE2.D_E_L_E_T_ = ' ' "
    cQuery += " AND E2_BAIXA = '" + DTOS(Date()) + "' "
    cQuery += " AND E2_SALDO = 0 "
    cQuery += " AND E2_BAIXA <> ' ' "
    cQuery += " AND E2_PREFIXO = 'VEX' "
    cQuery += " ORDER BY E2_FORNECE, E2_LOJA, E2_PREFIXO, E2_NUM "

    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB", .F., .T.)
    
    TRB->(dbGoTop())
    Count To nTotal

    TRB->(dbGoTop())

    For nI := 1 To nTotal
        cNumReport := TRB->E2_HIST
        CDatePayment := TRB->E2_BAIXA
        cFromatDate := SubStr(CDatePayment, 1, 4) + "-" + SubStr(CDatePayment, 5, 2) + "-" + SubStr(CDatePayment, 7, 2)
        cBody := '{"payment_date":"'+cFromatDate+' 01:10:00"}'
        cReturn := U_ApiRequisition('reports/'+AllTrim(cNumReport)+'/pay', cToken, 'PUT' ,cBody)
        oJSon:fromJson(cReturn)
        ce := oJson:GetJsonText("message")
        If oJson:GetJsonText("success") <> "true"
            aadd(aErrors, "Erro ao consultar API: " + oJson:GetJsonText("message"))
        EndIf

        TRB->(dbSkip())

    Next nI

    TRB->(dbCloseArea())

    If Len(aErrors) > 0
        U_SendEmailErrors(aErrors)
    Endif

Return
