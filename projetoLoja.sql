-- Criação das Tabelas

CREATE TABLE categoria (
cod_cat integer not null,
nome varchar2(100) not null,
CONSTRAINT pk_categoria PRIMARY KEY (cod_cat)
);

CREATE TABLE produto (
cod_prod integer not null,
desc varchar2(100) not null,
cod_cat integer, /*chave estrangeira*/
preco real,
custo real,
estoque integer,
CONSTRAINT pk_produto PRIMARY KEY (cod_prod)
);

CREATE TABLE fornecedor (
cnpj varchar2(100) not null,
nome varchar2(100) not null,
endereco varchar2(100),
tel integer,
CONSTRAINT pk_fornecedor PRIMARY KEY (cnpj)
);

CREATE TABLE funcionario (
cod_func integer not null,
nome varchar2(100) not null,
admissao date,
CONSTRAINT pk_funcionario PRIMARY KEY (cod_func)
);

CREATE TABLE cliente (
cpf varchar2(100) not null,
nome varchar2(100) not null,
endereco varchar2(100),
CONSTRAINT pk_cliente PRIMARY KEY (cpf)
);

CREATE TABLE tel (
tel integer
);

CREATE TABLE veiculo (
placa varchar2(100) not null,
nome varchar2(100),
ano varchar2(100),
CONSTRAINT pk_veiculo PRIMARY KEY (placa)
);

CREATE TABLE fornecido (
cnpj varchar2(100), /*chave estrangeira*/
cod_prod integer, /*chave estrangeira*/
quant integer not null,
data date not null
);

CREATE TABLE venda (
seq_venda integer not null,
placa varchar2(100), /*chave estrangeira*/
cod_func integer, /*chave estrangeira*/
cpf varchar2(100), /*chave estrangeira*/
data date not null,
valortotal real not null,
CONSTRAINT pk_venda PRIMARY KEY (seq_venda)
);

CREATE TABLE lista_prod (
cod_prod integer not null, /*chave estrangeira*/
seq_venda integer not null, /*chave estrangeira*/
quant integer not null,
preco_uni real not null
);

CREATE TABLE servico (
seq_serv integer not null,
seq_venda integer, /*chave estrangeira*/
cod_func integer, /*chave estrangeira*/
desc varchar2(100) not null,
valor real not null,
data date not null,

--Constraints

CONSTRAINT pk_servico PRIMARY KEY (seq_serv)
);


ALTER TABLE produto ADD CONSTRAINT fk_prod_cat FOREIGN KEY(cod_cat) REFERENCES categoria (cod_cat);
ALTER TABLE fornecido ADD CONSTRAINT fk_fornecido FOREIGN KEY(cnpj) REFERENCES fornecedor (cnpj);
ALTER TABLE fornecido ADD CONSTRAINT fk_fornecido_prod FOREIGN KEY(cod_prod) REFERENCES fornecedor (cod_prod);
ALTER TABLE venda ADD CONSTRAINT fk_venda_veiculo FOREIGN KEY(placa) REFERENCES veiculo (placa);
ALTER TABLE venda ADD CONSTRAINT fk_venda_func FOREIGN KEY(cod_func) REFERENCES funcionario (cod_func);
ALTER TABLE venda ADD CONSTRAINT fk_venda_cliente FOREIGN KEY(cpf) REFERENCES cliente (cpf);
ALTER TABLE lista_prod ADD CONSTRAINT fk_lista_prod FOREIGN KEY(cod_prod) REFERENCES produto (cod_prod);
ALTER TABLE lista_prod ADD CONSTRAINT fk_lista_venda FOREIGN KEY(seq_venda) REFERENCES venda (seq_venda);
ALTER TABLE servico ADD CONSTRAINT fk_serv_venda FOREIGN KEY(seq_venda) REFERENCES venda (seq_venda);
ALTER TABLE servico ADD CONSTRAINT fk_serv_func FOREIGN KEY(cod_func) REFERENCES funcionario (cod_func);

-- Inserção de registros testes
INSERT INTO categoria VALUES  (1, 'categoria1');
INSERT INTO produto (cod_prod, desc, cod_cat) VALUES (1, 'produto1', 1);
INSERT INTO fornecedor (cnpj, nome) VALUES ('12345678000100', 'forncedor1');
INSERT INTO funcionario (cod_func, nome) VALUES (1, 'funcionario1');
INSERT INTO cliente (cpf, nome) VALUES ('00011122233', 'cliente1');
INSERT INTO veiculo (placa) VALUES ('KKK1234');
INSERT INTO fornecido VALUES ('12345678000100', 1, 1, '01-01-2016');
INSERT INTO venda VALUES (1, 'KKK1234', 1, '00011122233', '01-01-2016', 100);
INSERT INTO lista_prod VALUES (1, 1, 1, 100);
INSERT INTO servico VALUES (1, 1, 1, 'servico1', 100, '01-01-2016');			


-- Consultas testes

/*lista de servicos por periodo mensal*/
SELECT seq_serv, nome, desc, valor, data FROM servico s, funcionario f
WHERE to_char(data, 'mm') = '01' and f.cod_func = s.cod_func

/*soma de servicos por periodo mensal*/
SELECT nome, sum(valor), to_char(data, 'mm') as mesreferencia FROM servico s, funcionario f
WHERE to_char(data, 'mm') = '01' and f.cod_func = s.cod_func
GROUP BY nome
ORDER BY 1

/*lista de  preços dos produtos entre R$ 500,00 e R$ 1.000,00*/
SELECT COUNT(*), FROM produtos
WHERE preco BETWEEN 500 and 1000

/*lista de todas as placas começadas com K*/
SELECT placa FROM veículos
WHERE UPPER(placas) LIKE ‘K%’