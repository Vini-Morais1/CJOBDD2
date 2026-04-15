-- 16. Escreva uma consulta que conte o número de faturas.
SELECT COUNT(*) AS [Total Faturas]
FROM INVOICE;

-- 17. Escreva uma consulta que conte o número de clientes com saldo superior a US$ 500.
SELECT COUNT(*) AS [Total Clientes]
FROM CUSTOMER
WHERE CUS_BALANCE > 500;

-- 18. Gere uma listagem de todas as compras feitas por clientes, utilizando como orientação o resultado apresentado na Figura P7.16. (Sugestão: Utilize a cláusula ORDER BY para ordenar as linhas resultantes apresentadas na Figura P7.16.)
SELECT 
    I.CUS_CODE, 
    I.INV_NUMBER, 
    I.INV_DATE, 
    P.P_DESCRIPT, 
    L.LINE_UNITS, 
    L.LINE_PRICE
FROM INVOICE I
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
JOIN PRODUCT P ON L.P_CODE = P.P_CODE
ORDER BY I.CUS_CODE, I.INV_NUMBER, P.P_DESCRIPT;

-- 19. Utilizando como orientação o resultado apresentado na Figura P7.17, gere uma lista de compras de clientes, incluindo os subtotais de cada número de linha de fatura. (Sugestão: Modifique o formato da consulta utilizada para produzir a lista de compras de clientes do Problema 18, exclua a coluna INV_DATE e adicione o atributo derivado (computado) LINE_UNITS * LINE_PRICE para calcular os subtotais.)
SELECT 
    I.CUS_CODE, 
    I.INV_NUMBER, 
    P.P_DESCRIPT, 
    L.LINE_UNITS, 
    L.LINE_PRICE,
    (L.LINE_UNITS * L.LINE_PRICE) AS [Subtotal]
FROM INVOICE I
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
JOIN PRODUCT P ON L.P_CODE = P.P_CODE
ORDER BY I.CUS_CODE, I.INV_NUMBER, P.P_DESCRIPT;

-- 20. Modifique a consulta utilizada no Problema 19 para produzir o resumo apresentado na Figura P7.18.
SELECT 
    C.CUS_CODE, 
    C.CUS_BALANCE,
    SUM(L.LINE_UNITS * L.LINE_PRICE) AS [Total Purchases]
FROM CUSTOMER C
JOIN INVOICE I ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY C.CUS_CODE, C.CUS_BALANCE
ORDER BY C.CUS_CODE;

-- 21. Modifique a consulta do Problema 20 de modo a incluir o número de compras individuais de produtos feitas por cliente.
SELECT 
    C.CUS_CODE, 
    C.CUS_BALANCE,
    SUM(L.LINE_UNITS * L.LINE_PRICE) AS [Total Purchases],
    COUNT(*) AS [Number of Purchases]
FROM CUSTOMER C
JOIN INVOICE I ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY C.CUS_CODE, C.CUS_BALANCE
ORDER BY C.CUS_CODE;

-- 22. Utilize uma consulta para computar a quantia média de compras por produto feita por cliente. (Sugestão: Utilize os resultados do Problema 21 como base desta consulta.)
SELECT 
    C.CUS_CODE, 
    C.CUS_BALANCE,
    SUM(L.LINE_UNITS * L.LINE_PRICE) AS [Total Purchases],
    COUNT(*) AS [Number of Purchases],
    CAST(SUM(L.LINE_UNITS * L.LINE_PRICE) / COUNT(*) AS DECIMAL(10,2)) AS [Average Purchase Amount]
FROM CUSTOMER C
JOIN INVOICE I ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY C.CUS_CODE, C.CUS_BALANCE
ORDER BY C.CUS_CODE;

-- 23. Crie uma consulta para produzir as compras totais por fatura, gerando os resultados apresentados na Figura P7.21.
SELECT 
    INV_NUMBER, 
    SUM(LINE_UNITS * LINE_PRICE) AS [Invoice Total]
FROM LINE
GROUP BY INV_NUMBER
ORDER BY INV_NUMBER;

-- 24. Utilize uma consulta para mostrar as faturas e totais de faturas conforme apresentado na Figura P7.22. (Sugestão: Agrupe por CUS_CODE.)
SELECT 
    I.CUS_CODE, 
    I.INV_NUMBER, 
    SUM(L.LINE_UNITS * L.LINE_PRICE) AS [Invoice Total]
FROM INVOICE I
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY I.CUS_CODE, I.INV_NUMBER
ORDER BY I.CUS_CODE, I.INV_NUMBER;

-- 25. Escreva uma consulta que produza o número de faturas e as quantias totais de compras por cliente, utilizando como orientação o resultado da Figura P7.23.
SELECT 
    I.CUS_CODE, 
    COUNT(DISTINCT I.INV_NUMBER) AS [Number of Invoices],
    SUM(L.LINE_UNITS * L.LINE_PRICE) AS [Total Customer Purchases]
FROM INVOICE I
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY I.CUS_CODE
ORDER BY I.CUS_CODE;

-- 26. Utilizando os resultados do Problema 25 como base, escreva uma consulta que gere o número total de faturas, o total de todas as faturas, o menor e maior valor de fatura, e o valor médio de todas as faturas.
SELECT 
    SUM([Number of Invoices]) AS [Total Invoices],
    SUM([Total Customer Purchases]) AS [Total Sales],
    MIN([Total Customer Purchases]) AS [Minimum Sale],
    MAX([Total Customer Purchases]) AS [Largest Sale],
    CAST(AVG([Total Customer Purchases]) AS DECIMAL(10,2)) AS [Average Sale]
FROM (
    SELECT 
        I.CUS_CODE,
        COUNT(DISTINCT I.INV_NUMBER) AS [Number of Invoices],
        SUM(L.LINE_UNITS * L.LINE_PRICE) AS [Total Customer Purchases]
    FROM INVOICE I
    JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
    GROUP BY I.CUS_CODE
) AS ResumoClientes;

-- 27. Liste as características dos saldos dos clientes que fizeram compras durante o ciclo atual de faturas - ou seja, dos clientes que aparecem na tabela INVOICE.
SELECT 
    CUS_CODE, 
    CUS_BALANCE
FROM CUSTOMER
WHERE CUS_CODE IN (SELECT CUS_CODE FROM INVOICE)
ORDER BY CUS_CODE;

-- 28. Utilizando os resultados da consulta criada no Problema 27, forneça um resumo das características dos saldos de clientes, conforme a Figura P7.26.
SELECT 
    MIN(CUS_BALANCE) AS [Minimum Balance],
    MAX(CUS_BALANCE) AS [Maximum Balance],
    CAST(AVG(CUS_BALANCE) AS DECIMAL(10,2)) AS [Average Balance]
FROM CUSTOMER
WHERE CUS_CODE IN (SELECT CUS_CODE FROM INVOICE);

-- 29. Crie uma consulta que encontre as características de saldos de todos os clientes, incluindo o total de saldos a receber.
SELECT 
    SUM(CUS_BALANCE) AS [Total Balance],
    MIN(CUS_BALANCE) AS [Minimum Balance],
    MAX(CUS_BALANCE) AS [Maximum Balance],
    CAST(AVG(CUS_BALANCE) AS DECIMAL(10,2)) AS [Average Balance]
FROM CUSTOMER;

-- 30. Obtenha a listagem de clientes que não fizeram compras durante o período de faturamento.
SELECT 
    CUS_CODE, 
    CUS_BALANCE
FROM CUSTOMER
WHERE CUS_CODE NOT IN (SELECT CUS_CODE FROM INVOICE)
ORDER BY CUS_CODE;

-- 31. Obtenha o resumo dos saldos de todos os clientes que não fizeram compras durante o período atual de faturamento.
SELECT 
    SUM(CUS_BALANCE) AS [Total Balance],
    MIN(CUS_BALANCE) AS [Minimum Balance],
    MAX(CUS_BALANCE) AS [Maximum Balance],
    CAST(AVG(CUS_BALANCE) AS DECIMAL(10,2)) AS [Average Balance]
FROM CUSTOMER
WHERE CUS_CODE NOT IN (SELECT CUS_CODE FROM INVOICE);

-- 32. Crie uma consulta para produzir o resumo do valor dos produtos atualmente em estoque.
SELECT 
    P_DESCRIPT, 
    P_QOH, 
    P_PRICE,
    (P_QOH * P_PRICE) AS [Subtotal]
FROM PRODUCT
ORDER BY P_CODE;

-- 33. Utilizando os resultados da consulta criada no Problema 32, obtenha o valor total do estoque de produtos.
SELECT 
    SUM(P_QOH * P_PRICE) AS [Total Value of Inventory]
FROM PRODUCT;