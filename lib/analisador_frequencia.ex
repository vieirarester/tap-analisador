defmodule ContadorPalavras do

  def processarLinha(linha) do
    linha
    |> String.replace(~r/<i>|<\/i>|[^A-Za-z']/, " ")  # Remove <i>, </i> e outros caracteres não alfabéticos
    |> String.split(~r/\s+/)  # Divide a linha em palavras
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.downcase/1)
  end

  # faz a limpeza do arquivo para considerar apenas as palavras contáveis
  def limparArquivo(listaArquivo) do
    listaArquivo
    |> Enum.flat_map(&processarLinha/1)
  end

  # lê o arquivo .srt e conta a frequencia das palavras
  def lerArquivoSrt(arquivo) do
    arquivo
    |> File.read!()
    |> String.split(~r/\n{2,}/, trim: true)
    |> Enum.flat_map(&String.split(&1, ~r/\n/))
    |> limparArquivo()
    |> Enum.frequencies()
  end

  def formatarConteudo(arquivo) do
    arquivo
    |> lerArquivoSrt()
    |> Enum.map(fn {palavra, frequencia} ->
      %{"palavra"=> palavra, "frequencia"=> frequencia}
    end)
    |> Enum.sort(&(&1["frequencia"] >= &2["frequencia"]))
  end

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

    "[\n#{json}\n]"

    json = "[\n#{json}\n]"

    File.write!(caminho, json)

  end

  def criarResultados() do
    File.mkdir("resultados")
  end

  def processarArquivo(arquivo) do
    conteudo = lerArquivoSrt(arquivo)
    escreverJson(conteudo, "resultados/episodio-#{Path.basename(arquivo)}.json")
  end

  def processarDiretorio(diretorio) do
    Path.wildcard(Path.join([diretorio, "**/*.srt"]))
    |> Enum.each(&processarArquivo/1)
  end

  def run(diretorio) do
    criarResultados()
    processarDiretorio(diretorio)
  end
end

defmodule CLI do
  def run(args) do
    case args do
      ["--diretorio", diretorio | _rest] ->
        ContadorPalavras.run(diretorio)
      _ ->
        IO.puts("Uso: elixir analisador_frequencia.ex --diretorio <caminho_do_diretorio>")
    end
  end
end

CLI.run(System.argv())
