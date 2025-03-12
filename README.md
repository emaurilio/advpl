# Integração VExpenses <> Protheus usando ADVPL

O objetivo do projeto é desenvolver uma integração de reembolsos entre VExpenses e Protheus usando a linguagem ADVPL

![Badge de Status](https://img.shields.io/badge/status-em%20desenvolvimento-orange)  <!-- Opcional -->

## Tabela de Conteúdos
- [Sobre](#sobre)
- [Funcionalidades](#funcionalidades)
- [Tecnologias Usadas](#tecnologias-usadas)
- [Como Usar](#como-usar)


## Sobre

A integração abrange somente reembolsos, mas existe uma programação para a inclusão de integração com cartões corporativos, adiantamentos, solicitação de adiantamentos e cartão VExpenses.

Ela acontece de em dois momentos:  
  1 - O relatório é aprovado no VExpenses;  
  2 - A integração roda uma vez ao dia, pegando todos os relatórios aprovados no dia anterior;  
  3 - O título de contas a pagar é criado;  
  4 - A pessoa do financeiro dá baixa nesse título;  
  5 - A integração puxa os relatórios pagos no dia anterior (roda uma vez ao dia) e devolve a informação de pago para o VExpenses.  

  Entre as informações integradas estão: data da despesa, conta contábil, centro de custos, fornecedor e valor.  

  A integração não cria um relatório por título a pagar, ela cria um título a pagar por despesa.  

  Em caso de erros, um gestor pode receber um e-mail automático com a descrição de cada erro.  

## Funcionalidades

- Funcionalidade 1: Criação do contas a pagar automaticamente.  
- Funcionalidade 2: Devolução do "Pago" no relatório, para que o usuário possa acompanhar todo o processo de reembolso pelo App VExpense.  

## Tecnologias Usadas

- **ADVPL**: Linguagem de programação do Protheus.  

## Como Usar

É necessário criar váriaveis (entrando no Protheus com o usuário "Configurador) na aba de "Parâmetros". São eles:  
  1 - MV_TOKEN - Token VExpenses;  
  2 - MV_URIVEX - URI API VExpenses;  
  3 - MV_SERVER - Server do SMTP para envio de e-mails;  
  4 - MV_USERE - Usuário SMTP;  
  5 - MV_PASS - Senha usuário SMTP;  

Sugiro que crie os parâmetros sem filial vinculado.  

Além dos parâmetros, é necessário criar os Schedules para que as funções rodem automaticamente todo dia.  
