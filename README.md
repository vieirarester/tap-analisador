# Analisador de frequência

Escrever um programa que conte quantas vezes uma determinada palavra apareceu em uma temporada da série.

## Requisitos
1. O programa deverá:
* ler de um diretório especificado pelo usuário (via linha de comando), todos os arquivos com a extensão .srt, independente do nome do arquivo.

Observações:
* Marcações de tempo não devem ser contabilizadas (filtrar conteúdo)
* Símbolos não devem ser contabilizados (Ex: ? , . ! @ ♪ - :)
* Números não devem ser contabilizados
* Abreviações devem ser contabilizadas (Ex: Ins’t, we’re, I’m, you’ll, doesn’t, didn’t, what’s …)
* As palavras não devem ser case-sensitive


2. o programa deverá criar uma pasta com o nome **resultados** e, dentro do diretório, deve-se possuir os seguintes arquivos:
* para cada episódio, possuir um arquivo chamado episodio-(nome-do-arquivo).json contendo um array de objetos resumindo cada palavra, ordenado de forma decrescente (do maior para o menor). 
Ex:
```json
[
    {
        “palavra”: “Ins’t”, 
        “frequencia”: 1436
    }, 
    {
        “palavra”: “or”, 
        “frequencia”: 1311
    }, … ]
```
* para cada temporada, possuir um arquivo chamado temporada-(nome-do-diretorio).json contendo um array de objetos resumindo cada palavra, ordenado de forma decrescente.

O programa deverá ser escrito na linguagem de programação escolhida em sala de aula utilizando o paradigma funcional.

## Resultados
O aluno deverá realizar um fork deste repositório e adicionar em `INSTRUCTIONS.md` as intruções de instalação e execução do programa. Todo código utilizado deverá está contido dentro do fork do repositório. Após finalizar o programa, deve-se:
* encaminhar para o e-mail do docente o link do repositório
* um pequeno vídeo apresentando o projeto desenvolvido e explicando cada função implementada
** No vídeo, apresentar o projeto em execução e os resultados obtidos
>>>>>>> 947eb422f25356e89510152ee0f9e73954611298
