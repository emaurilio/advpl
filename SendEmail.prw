User Function SendEmailErrors(aErrors)
    RpcSetEnv("99", "01")

    Local oEmail     := TMailManager():New()
    Local oMessage   := TMailMessage():New()
    Local cServer    := SuperGetMV("MV_SERVER",, "", FWxFilial("SM0"))
    Local cAccount   := SuperGetMV("MV_USERE",, "", FWxFilial("SM0"))
    Local cPassword  := SuperGetMV("MV_PASS",, "", FWxFilial("SM0"))
    Local nPort      := 587
    Local nTimeOut   := 60
    Local cTo        := "destinatario@empresa.com.br"
    Local cSubject   := "Rotina Integração VExpenses <> Protheus - Erros"
    Local cBody      := ""
    Local nErro      := 0
    Local nI         := 0
    Local cBreak := Chr(13) + Chr(10)

    cBody := "Foram encontrados os seguintes erros na integração VExpenses <> Protheus:" + cBreak
    
    For nI := 1 To Len(aErrors)
        cBody += "Erro " + cValToChar(nI) + ": " + aErrors[nI] + cBreak
    Next nI
    
    cBody += cBreak + cBreak + "Este e-mail foi gerado automaticamente pelo sistema."
    
    oEmail:SetUseTLS(.F.)
    oEmail:Init("", cServer, cAccount, cPassword, 0, nPort)
    oEmail:SetSMTPTimeout(nTimeOut)
    
    If (nErro := oEmail:SmtpConnect(nPort)) != 0
        MsgStop("Erro ao conectar: " + oEmail:GetErrorString(nErro))
        Return
    EndIf

    If (nErro := oEmail:SmtpAuth(cAccount, cPassword)) != 0
        MsgStop("Erro de autenticação: " + oEmail:GetErrorString(nErro))
        oEmail:SmtpDisconnect()
        Return
    EndIf
    
    oMessage:Clear()
    oMessage:cFrom    := cAccount
    oMessage:cTo      := cTo
    oMessage:cSubject := cSubject
    oMessage:cBody    := cBody
    
    If (nErro := oMessage:Send(oEmail)) != 0
        ConOut("Erro ao enviar: " + oEmail:GetErrorString(nErro))
    EndIf

    oEmail:SmtpDisconnect()

Return
