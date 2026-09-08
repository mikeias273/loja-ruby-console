require 'json'

ARQUIVO_PRODUTOS = 'produtos.json'

# --- FUNÇÕES AUXILIARES DE TRATAMENTO DE ERROS ---

# Lê e garante que o usuário digitou um número inteiro válido
def ler_inteiro(mensagem)
  loop do
    print mensagem
    entrada = gets.chomp
    return entrada.to_i if entrada =~ /^\d+$/

    puts "--> [ERRO] Entrada invalida! Digite apenas numeros inteiros."
  end
end

# Lê e garante que o usuário digitou um número decimal válido (ex: 10 ou 10.5)
def ler_float(mensagem)
  loop do
    print mensagem
    entrada = gets.chomp.tr(',', '.')
    if entrada =~ /^\d+(\.\d+)?$/ && entrada.to_f > 0
      return entrada.to_f
    end

    puts "--> [ERRO] Preco invalido! Digite um valor numérico maior que zero (ex: 12.50)."
  end
end

# --- FUNÇÕES DE PERSISTÊNCIA ---

def carregar_produtos
  if File.exist?(ARQUIVO_PRODUTOS)
    begin
      conteudo = File.read(ARQUIVO_PRODUTOS)
      dados = JSON.parse(conteudo)
      dados.transform_keys(&:to_i)
    rescue JSON::ParserError
      puts "--> [ERRO] O arquivo JSON esta corrompido! Iniciando base vazia."
      {}
    end
  else
    puts "Arquivo de produtos nao encontrado!"
    {}
  end
end

def salvar_produtos(produtos)
  File.write(ARQUIVO_PRODUTOS, JSON.pretty_generate(produtos))
rescue StandardError => e
  puts "--> [ERRO] Nao foi possivel salvar no arquivo: #{e.message}"
end

# --- INICIALIZAÇÃO DO SISTEMA ---

produtos = carregar_produtos
carrinho = []
total_compra = 0
opcao = 0

# --- LOOP PRINCIPAL ---

while opcao != 6
  system("clear")
  puts "===================================="
  puts "       LOJA VIRTUAL - MENU          "
  puts "===================================="
  puts "1 - Ver Produtos e Estoque"
  puts "2 - Comprar Produto"
  puts "3 - Ver Carrinho de Compras"
  puts "4 - Finalizar Compra (Checkout)"
  puts "5 - Painel do Administrador (Gestao)"
  puts "6 - Sair"
  puts "===================================="

  opcao = ler_inteiro("Escolha uma opcao: ")

  case opcao
  when 1
    system("clear")
    puts "--- PRODUTOS DISPONIVEIS ---"
    if produtos.empty?
      puts "Nenhum produto cadastrado no momento."
    else
      produtos.each do |id, item|
        puts "#{id} - #{item['nome']} | Preco: R$ #{item['preco']} | Estoque: #{item['estoque']} un"
      end
    end
    puts "\nPressione ENTER para voltar ao menu..."
    gets

  when 2
    system("clear")
    puts "--- REALIZAR COMPRA ---"
    produtos.each do |id, item|
      puts "#{id} - #{item['nome']} (R$ #{item['preco']}) - Estoque: #{item['estoque']}"
    end

    id_produto = ler_inteiro("\nDigite o numero do produto desejado: ")

    if produtos.key?(id_produto)
      produto = produtos[id_produto]

      qtd = ler_inteiro("Quantas unidades de #{produto['nome']} voce quer? ")

      if qtd <= 0
        puts "\n--> [ERRO] A quantidade deve ser maior que zero!"
      elsif qtd <= produto['estoque']
        produto['estoque'] -= qtd
        salvar_produtos(produtos)

        subtotal = produto['preco'] * qtd
        total_compra += subtotal
        carrinho << "#{qtd}x #{produto['nome']} - R$ #{subtotal}"

        puts "\n--> Sucesso: #{qtd}x #{produto['nome']} adicionado(s) ao carrinho!"
        puts "--> Subtotal do item: R$ #{subtotal}"
      else
        puts "\n--> Ops! Estoque insuficiente. Temos apenas #{produto['estoque']} unidades disponiveis."
      end
    else
      puts "\n--> [ERRO] Produto nao encontrado!"
    end

    puts "\nPressione ENTER para voltar ao menu..."
    gets

  when 3
    system("clear")
    puts "--- SEU CARRINHO DE COMPRAS ---"
    if carrinho.empty?
      puts "O seu carrinho esta vazio!"
    else
      carrinho.each { |item| puts "- #{item}" }
      puts "-------------------------------"
      puts "Total parcial: R$ #{total_compra}"
    end

    puts "\nPressione ENTER para voltar ao menu..."
    gets

  when 4
    system("clear")
    puts "--- FINALIZAR COMPRA ---"
    if carrinho.empty?
      puts "Seu carrinho esta vazio! Adicione itens antes de finalizar."
    else
      puts "Itens comprados:"
      carrinho.each { |item| puts "  #{item}" }
      puts "-------------------------------"
      puts "Subtotal acumulado: R$ #{total_compra}"

      if total_compra > 100
        desconto = total_compra * 0.10
        total_final = total_compra - desconto
        puts "Parabens! Voce ganhou 10% de desconto (-R$ #{desconto})"
        puts "TOTAL A PAGAR: R$ #{total_final}"
      else
        puts "TOTAL A PAGAR: R$ #{total_compra}"
      end

      carrinho.clear
      total_compra = 0
      puts "\nObrigado pela compra! Volte sempre."
    end

    puts "\nPressione ENTER para voltar ao menu..."
    gets

  when 5
    system("clear")
    puts "===================================="
    puts "      PAINEL DO ADMINISTRADOR       "
    puts "===================================="
    puts "1 - Cadastrar Novo Produto"
    puts "2 - Adicionar Estoque (Repor)"
    puts "3 - Voltar ao Menu Principal"
    puts "===================================="

    sub_opcao = ler_inteiro("Escolha uma opcao: ")

    case sub_opcao
    when 1
      system("clear")
      puts "--- CADASTRAR NOVO PRODUTO ---"
      print "Nome do produto: "
      nome = gets.chomp

      preco = ler_float("Preco (R$): ")
      estoque = ler_inteiro("Quantidade em estoque: ")

      novo_id = produtos.keys.empty? ? 1 : produtos.keys.max + 1

      produtos[novo_id] = {
        'nome' => nome,
        'preco' => preco,
        'estoque' => estoque
      }

      salvar_produtos(produtos)
      puts "\n--> Produto '#{nome}' cadastrado com sucesso com ID #{novo_id}!"

    when 2
      system("clear")
      puts "--- REPOR ESTOQUE ---"
      produtos.each do |id, item|
        puts "#{id} - #{item['nome']} (Estoque atual: #{item['estoque']})"
      end

      id_prod = ler_inteiro("\nDigite o ID do produto para repor estoque: ")

      if produtos.key?(id_prod)
        qtd_add = ler_inteiro("Quantidade a adicionar ao estoque: ")

        if qtd_add > 0
          produtos[id_prod]['estoque'] += qtd_add
          salvar_produtos(produtos)
          puts "\n--> Estoque de '#{produtos[id_prod]['nome']}' atualizado para #{produtos[id_prod]['estoque']} un!"
        else
          puts "\n--> [ERRO] A quantidade deve ser maior que zero!"
        end
      else
        puts "\n--> [ERRO] Produto nao encontrado!"
      end
    when 3
      # Retorna ao menu principal
    else
      puts "\nOpcao invalida!"
    end

    puts "\nPressione ENTER para continuar..."
    gets

  when 6
    puts "\nSaindo do sistema... Ate logo!"
  else
    puts "\n--> Opcao invalida! Pressione ENTER para tentar novamente..."
    gets
  end
end
