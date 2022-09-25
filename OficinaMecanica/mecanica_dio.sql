-------------------------------------------------------------
-- Criação do banco de dados para o modelo de Mecanica DIO --
-------------------------------------------------------------

create database mecanica_dio;

use mecanica_dio;

--------------------
-- Tabela Cliente --
--------------------

create table cliente(
	id_cliente int auto_increment primary key,
	nome varchar(45) not null,
	documento varhcar(15) not null,
	dt_nascimento date,
	constraint unique_documento unique (documento)
);

--------------------
-- Tabela Veiculo --
--------------------

create table veiculo(
	id_veiculo int auto_increment primary key,
	id_veiculo_cliente int not null,
	marca varchar(45),
	modelo varchar(45),
	ano varchar(45),
	placa varchar(45),
	constraint fk_id_veiculo_cliente foreign key (id_veiculo_cliente) references cliente(id_cliente)
);

--------------------
-- Tabela Servico --
--------------------

create table servico(
	id_servico int auto_increment primary key,
	nome varchar(100) not null,
	prazo int not null,
	valor_custo float not null,
);

------------------------
-- Tabela Funcionario --
------------------------

create table funcionario(
	id_funcionario int auto_increment primary key,
	nome varchar(100) not null,
	documento varchar(11) not null,
	endereco varchar(100) not null,
	especializacao varchar(50) not null,
);

------------------
-- Tabela Peças --
------------------

create table peca(
	id_peca int auto_increment primary key,
	nome varchar(100) not null,
	valor_custo float not null,
	quantidade int not null,
);

--------------------------
-- Tabela Ordem Servico --
--------------------------

create table ordem_servico(
	id_ordem_servico int auto_increment primary key,
	id_ordem_servico_veiculo int not null,
	numero varchar(45) not null,
	data_inicial date not null,
	data_final date not null,
	valor_total float,
	autorizado boolean not null,
	constraint fk_id_ordem_servico_veiculo foreign key (id_ordem_servico_veiculo) references veiculo(id_veiculo)
);

------------------------------
-- Tabela servico realizado --
------------------------------

create table servico_realizado(
	id_servico_realizado_servico int not null,
	id_servico_realizado_ordem int not null,
	constraint fk_id_servico_realizado_servico foreign key (id_servico_realizado_servico) references servico(id_servico),
	constraint fk_id_servico_realizado_ordem foreign key (id_servico_realizado_ordem) references ordem_servico(id_ordem_servico)
);

-------------------
-- Tabela Equipe --
-------------------

create table equipe(
	id_equipe_funcionario int not null,
	id_equipe_ordem int not null,
	constraint fk_id_equipe_funcionario foreign key (id_equipe_funcionario) references funcionario(id_funcionario),
	constraint fk_id_equipe_ordem foreign key (id_equipe_ordem) references ordem_servico(id_ordem_servico)
);

-----------------------------
-- Tabela Peças Utilizadas --
-----------------------------

create table peca_utilizada(
	id_peca_utilizada_peca int not null,
	id_peca_utilizada_ordem int not null,
	constraint fk_id_peca_utilizada_peca foreign key (id_peca_utilizada_peca) references peca(id_peca),
	constraint fk_id_peca_utilizada_ordem foreign key (id_peca_utilizada_ordem) references ordem_servico(id_ordem_servico)
);


------------
-- Querys --
------------

----------------------------------------------------------------
-- Listar quantas vezes cada cliente foi a oficina, por carro --
----------------------------------------------------------------

select count(1), C.nome, C.documento, B.placa, B.marca
	from ordem_servico A
inner join veiculo B on (A.id_ordem_servico_veiculo = B.id_veiculo)
inner join cliente C on (B.id_veiculo_cliente = C.id_cliente)
group by C.nome, C.documento, B.placa, B.marca
;

------------------------------------------------
-- Relação dos funcionarios ordenado por nome --
------------------------------------------------

select * from funcionario
order by nome
;