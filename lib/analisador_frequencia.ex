defmodule ContadorPalavras do

  # Função para processar uma linha de texto
  def processarLinha(linha) do
    linha
    |> String.replace(~r/<i>|<\/i>|[^A-Za-z']/, " ")  # Remove marcações <i>, </i> e outros caracteres não alfabéticos
    |> String.split(~r/\s+/)  # Divide a linha em palavras
    |> Enum.reject(&(&1 == ""))  # Remove strings vazias
    |> Enum.map(&String.downcase/1)  # Converte todas as letras para minúsculas
  end

  # Função para limpar uma lista de linhas de texto
  def limparArquivo(listaArquivo) do
    listaArquivo
    |> Enum.flat_map(&processarLinha/1)  # Aplica a função processarLinha a cada elemento e concatena as listas resultantes
  end

  # Função para ler um arquivo .srt e contar a frequência das palavras
  def lerArquivoSrt(arquivo) do
    arquivo
    |> File.read!()  # Lê o conteúdo do arquivo
    |> String.split(~r/\n{2,}/, trim: true)  # Divide o texto em legendas
    |> Enum.flat_map(&String.split(&1, ~r/\n/))  # Divide cada legenda em linhas
    |> limparArquivo()  # Limpa o conteúdo para considerar apenas as palavras contáveis
    |> Enum.frequencies()  # Conta a frequência das palavras
  end

  # Função para formatar o conteúdo no formato desejado
  def formatarConteudo(arquivo) do
    arquivo
    |> Enum.map(fn {palavra, frequencia} ->
      %{"palavra"=> palavra, "frequencia"=> frequencia}
    end)
    |> Enum.sort(&(&1["frequencia"] >= &2["frequencia"]))  # Ordena por frequência
  end

  # Função para escrever o conteúdo no formato JSON
  def escreverJson(arquivo, caminho) do
    conteudo = formatarConteudo(arquivo)

    json =
      Enum.map(conteudo, fn %{"palavra" => palavra, "frequencia" => frequencia} ->
        """
          {
            "palavra": "#{palavra}",
            "frequencia": #{frequencia}
          }
        """
      end)
      |> Enum.join(",\n")

    json = "[\n#{json}\n]"

    File.write!(caminho, json)  # Escreve o JSON no arquivo
  end

  # Função para criar a pasta de resultados e remover se já existir
  def criarResultados() do
    diretorioResultados = "../resultados"

    if File.dir?(diretorioResultados) do
      File.rm_rf!(diretorioResultados)  # Remove a pasta de resultados se existir
    end

    File.mkdir(diretorioResultados)  # Cria a pasta de resultados
  end

  # Função para processar um arquivo .srt
  def processarArquivo(arquivo) do
    IO.inspect("Processando arquivo: #{arquivo}")  # Adiciona um log para indicar que o arquivo está sendo processado

    conteudo = lerArquivoSrt(arquivo)
    nomeArquivo = Path.basename(arquivo, ".srt")
    caminhoArquivo = "../resultados/episodio-#{nomeArquivo}.json"
    escreverJson(conteudo, caminhoArquivo)
  end

  # Função para processar todos os arquivos de um diretório
  def processarDiretorio(diretorio) do
    Path.wildcard(Path.join([diretorio, "**/*.srt"]))  # Encontra todos os arquivos .srt no diretório e subdiretórios
    |> Enum.each(&processarArquivo/1)  # Processa cada arquivo encontrado
  end

  # Função principal para rodar o programa
  def run(diretorio) do
    criarResultados()  # Cria a pasta de resultados
    processarDiretorio(diretorio)  # Processa os arquivos no diretório fornecido
  end
end

# Módulo de interação com o usuário
defmodule Usuario do
  def main(args) do
    case args do
      ["--d", diretorio | _rest] -> ContadorPalavras.run(diretorio)  # Chama a função run com o diretório fornecido pelo usuário
      _ -> IO.puts("Uso: elixir analisador_frequencia.ex --d <caminho_do_diretorio>")  # Mensagem de uso para o usuário
    end
  end
end

Usuario.main(System.argv())  # Chama a função main com os argumentos do sistema
