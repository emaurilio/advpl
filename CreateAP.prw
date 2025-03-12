#Include "TOTVS.CH"
#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

User Function CreateAPVExpenses(cEmissionDate, cReportNum, cCodeSupplier, nValueExpenses, cExpenseNum, cCostCenterCode, cExpenseTypeCode)
    Local lRet      := .T.
    Local dDueDate   := Date() + 30
    Local cDataStr  := cEmissionDate
    Local cFromatDate   := ""
    Local dEmissionDate := CToD("")
    
    Private lMsErroAuto := .F.

    cFromatDate := SubStr(cDataStr, 9, 2) + "/" + SubStr(cDataStr, 6, 2) + "/" + SubStr(cDataStr, 1, 4)
    dEmissionDate := CTOD(cFromatDate)
    
    RpcSetEnv("99", "01")
    DbUseArea(.T., "TOPCONN", "SE2", "SE2", .F., .F.)

    aVetor := {}
    AAdd(aVetor, {"E2_FILIAL",  "01",             Nil})
    AAdd(aVetor, {"E2_PREFIXO", "VEX",            Nil})
    AAdd(aVetor, {"E2_NUM",     "5",       Nil})
    AAdd(aVetor, {"E2_PARCELA", "A",              Nil})
    AAdd(aVetor, {"E2_TIPO",    "RC",             Nil})
    AAdd(aVetor, {"E2_NATUREZ", "REEMBOLSO",      Nil})
    AAdd(aVetor, {"E2_FORNECE", cCodeSupplier,    Nil})
    AAdd(aVetor, {"E2_LOJA",    1,                Nil})
    AAdd(aVetor, {"E2_EMISSAO", dEmissionDate,    Nil})
    AAdd(aVetor, {"E2_VENCTO",  dDueDate,         Nil})
    AAdd(aVetor, {"E2_VENCREA", dDueDate,         Nil})
    AAdd(aVetor, {"E2_VALOR",   nValueExpenses,   Nil})
    AAdd(aVetor, {"E2_HIST",    cReportNum,       Nil})
    AAdd(aVetor, {"E2_MOEDA",   1,                Nil})
    AAdd(aVetor, {"E2_CONTAD",  "COMBUSTIVEL",    Nil})
    AAdd(aVetor, {"E2_CCUSTO",  cCostCenterCode,  Nil})
    AAdd(aVetor, {"E2_RATEIO",  "N",              Nil})

    MSExecAuto({|x, y, z| FINA050(x, y, z)}, aVetor, 3)
            
    If lMsErroAuto
        MostraErro()
        lRet := .F.
    Else
        ConfirmSX8()
        MsgInfo("Título criado com sucesso!", "Sucesso")
    EndIf

    Return lRet
