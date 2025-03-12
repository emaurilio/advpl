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
  1 - O relatório é aprovado no VExpenses chr(10);
  2 - A integração roda uma vez ao dia, pegando todos os relatórios aprovados no dia anterior chr(10);
  3 - O título de contas a pagar é criado chr(10);
  4 - A pessoa do financeiro dá baixa nesse título chr(10);
  5 - A integração puxa os relatórios pagos no dia anterior (roda uma vez ao dia) e devolve a informação de pago para o VExpenses chr(10).

  Entre as informações integradas estão: data da despesa, conta contábil, centro de custos, fornecedor e valor chr(10).

  A integração não cria um relatório por título a pagar, ela cria um título a pagar por despesa chr(10).

  Em caso de erros, um gestor pode receber um e-mail automático com a descrição de cada erro chr(10).

## Funcionalidades

- Funcionalidade 1: Criação do contas a pagar automaticamente chr(10).
- Funcionalidade 2: Devolução do "Pago" no relatório, para que o usuário possa acompanhar todo o processo de reembolso pelo App VExpense chr(10).

## Tecnologias Usadas

- **ADVPL**: Linguagem de programação do Protheus.

## Como Usar

É necessário criar váriaveis (entrando no Protheus com o usuário "Configurador) na aba de "Parâmetros". São eles:
  1 - MV_TOKEN - Token VExpenses;
  2 - MV_SERVER - Server do SMTP para envio de e-mails;
  3 - MV_USERE - Usuário SMTP;
  4 - MV_PASS - Senha usuário SMTP;

Sugiro que crie os parâmetros sem filial vinculado.

Além dos parâmetros, é necessário criar os Schedules para que as funções rodem automaticamente todo dia.
