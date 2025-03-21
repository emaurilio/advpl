User Function ApiRequisition(cPath, cToken, cMethod, cBody)
    RpcSetEnv("99", "01")
    Local cUri := SuperGetMV("MV_URIVEX",, "", FWxFilial("SM0"))
    Local aHeadOut := {}
    Local cResponse := ""
    Local oRest := FWREST():New(curi)
    
    iF empty(cMethod)
        cMethod := "GET"
    EndIf
    
    aadd(aHeadOut,"Content-Type: application/json")
    aadd(aHeadOut,"Authorization: " + cToken)
    
    If Upper(cMethod) == "GET"
        oRest:SetPath(cPath)
        oRest:Get(aHeadOut,"", "")
    ElseIf Upper(cMethod) == "PUT"
        oRest:SetPath(cPath)
        oRest:Put(aHeadOut,cBody,"")
    Endif
    cResponse := oRest:GetResult()
Return cResponse
