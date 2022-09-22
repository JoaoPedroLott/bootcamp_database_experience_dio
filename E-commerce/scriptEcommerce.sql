-----------------------------------------------------------
-- Criação do banco de dados para o modelo de E-commerce --
-----------------------------------------------------------

create database ecommerce;

use ecommerce;

--------------------
-- Tabela Cliente --
--------------------

create table cliente(
	id_cliente int auto_increment primary key,
	nome varchar(45) not null,
	tp_cliente enum('CPF', 'CNPJ') varchar(3) not null,
	documento varhcar(15) not null,
	dt_nascimento date,
	constraint unique_documento unique (documento)
);

---------------------
-- Tabela Endereco --
---------------------

create table endereco(
	id_endereco int auto_increment primary key,
	id_endereco_cliente int not null,
	rua varchar(45),
	cidade varchar(45),
	estado varchar(45),
	pais varchar(25),
	cep varchar(8),
	constraint fk_id_endereco_cliente foreign key (id_endereco_cliente) references cliente(id_cliente)
);

------------------------------
-- Tabela Formato Pagamento --
------------------------------

create table formato_pagamento(
	id_formato_pagamento int auto_increment primary key,
	id_formato_pagamento_cliente int not null,
	tp_formato_pagamento varchar(45) not null,
	numero varchar(45),
	dt_vencimento date,
	codigo_seguranca int,
	constraint fk_id_formato_pagamento_cliente foreign key (id_formato_pagamento_cliente) references cliente(id_cliente)
);

-------------------
-- Tabela Pedido --
-------------------

create table pedido(
	id_pedido int auto_increment primary key,
	id_pedido_cliente int not null,
	id_pedido_endereco int not null,
	status_pedido varchar(45) not null,
	descricao_pedido varchar(45),
	valor_frete float not null,
	constraint fk_id_pedido_cliente foreign key (id_pedido_cliente) references cliente(id_cliente),
	constraint fk_id_pedido_endereco foreign key (id_pedido_endereco) references endereco(id_endereco)
);

--------------------
-- Tabela Entrega --
--------------------

create table entrega(
	id_entrega int auto_increment primary key,
	id_entrega_pedido int not null,
	status_entrega varchar(45) not null,
	data_entrega date not null,
	codigo_rastreio varchar(45) not null,
	constraint fk_id_entrega_pedido foreign key (id_entrega_pedido) references pedido(id_pedido)
);

--------------------
-- Tabela Produto --
--------------------

create table produto(
	id_produto int auto_increment primary key,
	categoria varchar(45) not null,
	descricao varchar(100) not null,
	valor float not null
);

----------------------------------------
-- Tabela Relação de Produto / Pedido --
----------------------------------------

create table produto_pedido(
	id_produto_pedido_produto int not null,
	id_produto_pedido_pedido int not null,
	quantidade int not null,
	constraint fk_id_produto_pedido_pedido foreign key (id_produto_pedido_pedido) references pedido(id_pedido),
	constraint fk_id_produto_pedido_produto foreign key (id_produto_pedido_produto) references produto(id_produto)
);

---------------------
-- Tabela Vendedor --
---------------------

create table vendedor(
	id_vendedor int auto_increment primary key,
	razao_social varchar(45) not null,
	localizacao varchar(45)
);

----------------------------------
-- Tabela Produtos por Vendedor --
----------------------------------

create table vendedor_produto(
	id_vendedor_produto_produto int not null,
	id_vendedor_produto_vendedor int not null,
	quantidade int not null,
	constraint fk_id_vendedor_produto_vendedor foreign key (id_vendedor_produto_vendedor) references vendedor(id_vendedor),
	constraint fk_id_vendedor_produto_produto foreign key (id_vendedor_produto_produto) references produto(id_produto)
);

-----------------------
-- Tabela Fornecedor --
-----------------------

create table fornecedor(
	id_fornecedor int auto_increment primary key,
	razao_social varchar(45) not null,
	cnpj varchar(15) not null
);

--------------------------------------------
-- Tabela Relação de Fornecedor / Produto --
--------------------------------------------

create table fornecedor_produto(
	id_fornecedor_produto_produto int not null,
	id_fornecedor_produto_fornecedor int not null,
	constraint fk_id_fornecedor_produto_fornecedor foreign key (id_fornecedor_produto_fornecedor) references fornecedor(id_fornecedor),
	constraint fk_id_fornecedor_produto_produto foreign key (id_fornecedor_produto_produto) references produto(id_produto)
);

--------------------
-- Tabela Estoque --
--------------------

create table estoque(
	id_estoque int auto_increment primary key,
	localizacao varchar(45) not null,
);

-----------------------------------------
-- Tabela Relação de Estoque / Produto --
-----------------------------------------

create table estoque_produto(
	id_estoque_produto_produto int not null,
	id_estoque_produto_estoque int not null,
	quantidade int not null,
	constraint fk_id_estoque_produto_estoque foreign key (id_estoque_produto_estoque) references estoque(id_estoque),
	constraint fk_id_estoque_produto_produto foreign key (id_estoque_produto_produto) references produto(id_produto)
);


------------
-- Querys --
------------

----------------------------------------------------
-- Quantos pedidos foram feitos por cada cliente? --
----------------------------------------------------

select count(1), B.id_cliente, B.nome
	from pedido A
inner join cliente B on (A.id_pedido_cliente = B.id_cliente)
group by B.id_cliente, B.nome
order by B.id_cliente;

-------------------------------------------------------------
-- Relação de nomes dos fornecedores e nomes dos produtos; --
-------------------------------------------------------------

select B.razao_social, C.descricao 
	from fornecedor_produto A
inner join fornecedor B on (A.id_fornecedor_produto_fornecedor = B.id_fornecedor)
inner join produto C on (A.id_fornecedor_produto_produto = C.id_produto)
