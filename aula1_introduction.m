%% INTRODUÇÃO AO MATLAB
% Este script apresenta os conceitos básicos da linguagem MATLAB.
% Você pode executar linha por linha (Ctrl + Enter) para observar os resultados.

%% LIMPEZA DO AMBIENTE
% clear: remove todas as variáveis da memória
% clc: limpa a janela de comandos
% close all: fecha todas as figuras abertas

clear;
clc;
close all;

%% CRIAÇÃO DE VARIÁVEIS
% No MATLAB, você não precisa declarar o tipo da variável

a = 10;        % número inteiro
b = 3.5;       % número real (double)
nome = 'Gustavo';  % string (array de caracteres)

%% EXIBINDO RESULTADOS
% Para mostrar valores no console usamos:
disp(a);
disp(nome);

% Também podemos usar fprintf (mais flexível)
fprintf('O valor de a é: %d\n', a);
fprintf('O valor de b é: %.2f\n', b);

%% OPERAÇÕES BÁSICAS
% MATLAB funciona muito bem com operações matemáticas

soma = a + b;
subtracao = a - b;
multiplicacao = a * b;
divisao = a / b;
potencia = a^2;

disp('Resultados das operações:');
disp(soma);
disp(subtracao);
disp(multiplicacao);
disp(divisao);
disp(potencia);

%% VETORES E MATRIZES
% MATLAB é baseado em operações matriciais

vetor = [1 2 3 4 5];        % vetor linha
vetor_coluna = [1; 2; 3];   % vetor coluna

matriz = [1 2 3; 
          4 5 6; 
          7 8 9];

disp('Vetor:');
disp(vetor);

disp('Matriz:');
disp(matriz);

%% OPERAÇÕES COM VETORES
% Operações elemento a elemento usam o ponto (.)

v1 = [1 2 3];
v2 = [1 4 5];
resultado = v1 .* 2;   % multiplica cada elemento por 2

disp('Multiplicação elemento a elemento:');
disp(resultado);

resultado = v1 + v2;
disp('soma de elementos entre vetores:');
disp(resultado);

%% ENTRADA DE DADOS (INPUT)
% O MATLAB permite interação com o usuário

idade = input('Digite sua idade: ');
fprintf('Sua idade é: %d anos\n', idade);

%% ESTRUTURAS DE CONTROLE
% Exemplo de condicional

if idade >= 18
    disp('Você é maior de idade.');
else
    disp('Você é menor de idade.');
end

%% LAÇOS (LOOPS)

% Loop for
for i = 1:5
    fprintf('Valor de i: %d\n', i);
end

% Loop while
contador = 1;
while contador <= 3
    disp(contador);
    contador = contador + 1;
end

%% FUNÇÕES SIMPLES
% Podemos definir funções em arquivos separados ou no final do script

resultado = minha_funcao(5);
fprintf('Resultado da função: %d\n', resultado);

%% DEFINIÇÃO DE FUNÇÃO
function y = minha_funcao(x)
    % Esta função retorna o dobro do valor de entrada
    y = x * 2;
end