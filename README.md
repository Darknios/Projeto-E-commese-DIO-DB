# Projeto-E-commerce-DIO-DB
# Projeto de Banco de Dados para E-commerce

Este projeto consiste na modelagem e implementação de um banco de dados relacional para um cenário de e-commerce. O esquema foi desenvolvido como parte de um desafio de projeto, com o objetivo de aplicar conceitos de modelagem conceitual e lógica, além de consultas SQL complexas.

## Contexto

O banco de dados gerencia informações de clientes, produtos, pedidos, pagamentos, entregas, fornecedores, vendedores e estoques. O modelo foi refinado para incluir:

- **Clientes PF e PJ**: Uma conta pode ser pessoa física ou jurídica, mas não ambas.
- **Múltiplas formas de pagamento**: Cada cliente pode cadastrar mais de uma forma de pagamento.
- **Entrega**: Cada pedido possui informações de entrega, incluindo status e código de rastreio.
- **Relacionamentos complexos**: Produtos podem ser fornecidos por diferentes fornecedores e vendidos por diferentes vendedores, além de estarem localizados em múltiplos estoques.

## Estrutura do Banco de Dados

O banco de dados é nomeado `ecommerce` e contém as seguintes tabelas principais:

- **client**: Armazena dados de clientes (PF ou PJ).
- **product**: Catálogo de produtos com avaliação e categoria.
- **orders**: Pedidos realizados pelos clientes.
- **payments**: Formas de pagamento cadastradas por cliente.
- **delivery**: Informações de entrega de cada pedido.
- **productStorage**: Locais de estoque e quantidades.
- **supplier**: Fornecedores.
- **seller**: Vendedores (terceiros).
- **productSeller**: Relaciona produtos a vendedores (estoque do vendedor).
- **productOrder**: Relaciona produtos a pedidos (itens do pedido).
- **productSupplier**: Relaciona produtos a fornecedores.
- **storageLocation**: Relaciona produtos a locais de estoque.

O diagrama relacional pode ser visualizado no arquivo [`Modelo Fisico DIO.sql`](Modelo%20Fisico%20DIO.sql) (que contém toda a definição das tabelas e inserções).

## Como Executar

1. Certifique-se de ter um servidor MySQL instalado.
2. Execute o script [`Modelo Fisico DIO.sql`](Modelo%20Fisico%20DIO.sql) em seu ambiente MySQL (workbench, linha de comando, etc.). O script criará o banco de dados, as tabelas e inserirá dados de exemplo.
3. Após a execução, você pode explorar as tabelas e executar as queries fornecidas no final do script.

## Consultas Implementadas

O script inclui diversas consultas SQL que atendem aos requisitos do desafio:

1. **Recuperações simples** com `SELECT` (ex: listar todos os clientes).
2. **Filtros com `WHERE`** (ex: pedidos com frete > 0 e pagamento em dinheiro).
3. **Atributos derivados** (ex: cálculo de valor com taxa).
4. **Ordenação com `ORDER BY`** (ex: produtos por avaliação).
5. **Filtros em grupos com `HAVING`** (ex: clientes com mais de 1 pedido).
6. **Junções entre tabelas** para responder perguntas de negócio:
   - Quantos pedidos foram feitos por cada cliente?
   - Algum vendedor também é fornecedor? (comparando CNPJ)
   - Relação de produtos, fornecedores e estoques.
   - Nomes de fornecedores e produtos fornecidos.
   - Pedidos com status de entrega e código de rastreio.
   - Produtos mais bem avaliados (média > 4) e seus estoques.
   - Clientes que fizeram pedidos com frete superior a 50.

## Perguntas que as Queries Respondem

- Qual cliente fez mais pedidos?
- Quais produtos têm avaliação acima de 4?
- Existe sobreposição entre vendedores e fornecedores?
- Onde cada produto está estocado e em que quantidade?
- Qual o status atual das entregas?

## Tecnologias Utilizadas

- **MySQL**: Sistema de gerenciamento de banco de dados relacional.
- **SQL**: Linguagem de consulta e manipulação de dados.

## Melhorias Futuras

- Implementar triggers para atualizar automaticamente o estoque quando um pedido é confirmado.
- Criar views para facilitar consultas frequentes.
- Adicionar índices para otimizar desempenho em grandes volumes de dados.

## Autor

Este projeto foi desenvolvido como parte de um desafio de banco de dados da DIO (Digital Innovation One).

---

**Nota**: O script SQL completo está disponível no arquivo [`Modelo Fisico DIO.sql`](Modelo%20Fisico%20DIO.sql). Sinta-se à vontade para clonar o repositório e testar as consultas.
