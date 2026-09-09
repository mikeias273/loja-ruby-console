{
  "1": { "nome": "Marcador de Pagina (Personalizado)", "preco": 12.00, "estoque": 50 },
  "2": { "nome": "Chaveiro QR Code Instagram", "preco": 18.00, "estoque": 30 },
  "3": { "nome": "Caneta Decorada", "preco": 15.00, "estoque": 25 }
}

require 'json'

ARQUIVO_PRODUTOS = 'produtos.json'
ARQUIVO_ENCOMENDAS = 'encomendas.json'

# --- TRATAMENTO DE ENTRADAS ---

def ler_inteiro(mensagem)
  loop do
    print mensagem
    entrada = gets.chomp
    return entrada.to_i if entrada =~ /^\d+$/

    puts "--> [ERRO] Entrada invalida! Digite apenas numeros inteiros."
  end
end

def ler_float(mensagem)
  loop do
    print mensagem
    entrada = gets.chomp.tr(',', '.')
    return entrada.to_f if entrada =~ /^\d+(\.\d+)?$/ && entrada.to_f > 0

    puts "--> [ERRO] Preco invalido! Digite um valor numerico maior que zero."
  end
end

# --- CARREGAR E SALVAR DADOS ---

def carregar_json(caminho)
  if File.exist?(caminho)
    begin
      conteudo = File.read(caminho)
      dados = JSON.parse(conteudo)
      dados.transform_keys(&:to_i)
    rescue JSON::ParserError
      puts "--> [ERRO] O arquivo #{caminho} esta corrompido! Criando base vazia."
      {}
    end
  else
    {}
  end
end

def salvar_json(caminho, dados)
  File.write(caminho, JSON.pretty_generate(dados))
rescue StandardError => e
  puts "--> [ERRO] Nao foi possivel salvar em #{caminho}: #{e.message}"
end

# --- SESSÃO DO SISTEMA ---

produtos = carregar_json(ARQUIVO_PRODUTOS)
encomendas = carregar_json(ARQUIVO_ENCOMENDAS)
opcao = 0

# --- LOOP PRINCIPAL ---

while opcao != 6
  system("clear")
  puts "===================================="
  puts "     PAPELARIA PAPELIE - GESTAO     "
  puts "===================================="
  puts "1 - Ver Produtos e Estoque"
  puts "2 - Nova Encomenda / Venda (WhatsApp)"
  puts "3 - Listar / Status das Encomendas"
  puts "4 - Painel do Administrador (Produtos)"
  puts "5 - Limpar / Cancelar Carrinho Atual"
  puts "6 - Sair"
  puts "===================================="

  opcao = ler_inteiro("Escolha uma opcao: ")

  case opcao
  when 1
    system("clear")
    puts "--- CATÁLOGO DE PRODUTOS ---"
    if produtos.empty?
      puts "Nenhum produto cadastrado."
    else
      produtos.each do |id, item|
        puts "#{id} - #{item['nome']} | R$ #{'%.2f' % item['preco']} | Estoque: #{item['estoque']} un"
      end
    end
    puts "\nPressione ENTER para voltar ao menu..."
    gets

  when 2
    system("clear")
    puts "--- NOVA ENCOMENDA (PERSONALIZADA) ---"
    print "Nome do Cliente: "
    cliente = gets.chomp

    print "Telefone/WhatsApp do Cliente: "
    telefone = gets.chomp

    itens_pedido = []
    total_pedido = 0.0

    loop do
      puts "\n--- Escolha um Produto ---"
      produtos.each do |id, item|
        puts "#{id} - #{item['nome']} (R$ #{'%.2f' % item['preco']}) - Est: #{item['estoque']}"
      end
      puts "0 - Finalizar inclusao de itens"

      id_prod = ler_inteiro("Digite o ID do produto: ")
      break if id_prod == 0

      if produtos.key?(id_prod)
        prod = produtos[id_prod]
        qtd = ler_inteiro("Quantidade: ")

        if qtd <= 0
          puts "--> Quantidade invalida!"
        elsif qtd <= prod['estoque']
          print "Detalhe da Personalizacao (ex: Tema, Nome, QR Code): "
          detalhes = gets.chomp

          prod['estoque'] -= qtd
          salvar_json(ARQUIVO_PRODUTOS, produtos)

          subtotal = prod['preco'] * qtd
          total_pedido += subtotal

          itens_pedido << {
            'produto' => prod['nome'],
            'qtd' => qtd,
            'detalhes' => detalhes,
            'subtotal' => subtotal
          }

          puts "--> Item adicionado ao pedido!"
        else
          puts "--> Estoque insuficiente! Apenas #{prod['estoque']} disponiveis."
        end
      else
        puts "--> Produto nao encontrado!"
      end
    end

    if itens_pedido.empty?
      puts "\nNenhum item adicionado à encomenda."
    else
      novo_id_enc = encomendas.keys.empty? ? 1 : encomendas.keys.max + 1

      encomendas[novo_id_enc] = {
        'cliente' => cliente,
        'telefone' => telefone,
        'itens' => itens_pedido,
        'total' => total_pedido,
        'status' => 'Em Producao'
      }

      salvar_json(ARQUIVO_ENCOMENDAS, encomendas)

      system("clear")
      puts "============================================="
      puts "  ENCOMENDA ##{novo_id_enc} CRIADA COM SUCESSO!"
      puts "============================================="
      puts "\n--- RESUMO DA MENSAGEM PARA WHATSAPP ---"
      puts "Olá #{cliente}! Agradecemos seu pedido na Papelaria Papelie! ✨"
      puts "\n*Resumo do Pedido ##{novo_id_enc}:*"
      itens_pedido.each do |it|
        puts "• #{it['qtd']}x #{it['produto']} (R$ #{'%.2f' % it['subtotal']})"
        puts "  └ Detalhes: #{it['detalhes']}" unless it['detalhes'].empty?
      end
      puts "\n*Total:* R$ #{'%.2f' % total_pedido}"
      puts "============================================="
    end

    puts "\nPressione ENTER para continuar..."
    gets

  when 3
    system("clear")
    puts "--- PAINEL DE ENCOMENDAS ---"
    if encomendas.empty?
      puts "Nenhuma encomenda cadastrada."
    else
      encomendas.each do |id, enc|
        puts "--------------------------------------------"
        puts "Pedido ##{id} | Cliente: #{enc['cliente']} (#{enc['telefone']})"
        puts "Status: [ #{enc['status']} ] | Total: R$ #{'%.2f' % enc['total']}"
        puts "Itens:"
        enc['itens'].each do |item|
          puts " - #{item['qtd']}x #{item['produto']} (#{item['detalhes']})"
        end
      end
      puts "--------------------------------------------"

      puts "\nDeseja atualizar o status de alguma encomenda? (S/N)"
      resp = gets.chomp.upcase
      if resp == 'S'
        id_e = ler_inteiro("Digite o numero da encomenda: ")
        if encomendas.key?(id_e)
          puts "1 - Em Producao | 2 - Pronto para Envio | 3 - Entregue"
          st_op = ler_inteiro("Escolha o novo status: ")
          case st_op
          when 1 then encomendas[id_e]['status'] = 'Em Producao'
          when 2 then encomendas[id_e]['status'] = 'Pronto para Envio'
          when 3 then encomendas[id_e]['status'] = 'Entregue'
          end
          salvar_json(ARQUIVO_ENCOMENDAS, encomendas)
          puts "--> Status atualizado com sucesso!"
        else
          puts "--> Encomenda nao encontrada!"
        end
      end
    end

    puts "\nPressione ENTER para voltar..."
    gets

  when 4
    system("clear")
    puts "--- GESTAO DE PRODUTOS ---"
    puts "1 - Cadastrar Novo Produto"
    puts "2 - Repor Estoque"
    puts "3 - Voltar"

    sub_op = ler_inteiro("Escolha uma opcao: ")
    case sub_op
    when 1
      print "Nome do Produto: "
      nome = gets.chomp
      preco = ler_float("Preco (R$): ")
      estoque = ler_inteiro("Estoque Inicial: ")

      novo_id = produtos.keys.empty? ? 1 : produtos.keys.max + 1
      produtos[novo_id] = { 'nome' => nome, 'preco' => preco, 'estoque' => estoque }
      salvar_json(ARQUIVO_PRODUTOS, produtos)
      puts "--> Produto cadastrado!"
    when 2
      produtos.each { |i, p| puts "#{i} - #{p['nome']} (Estoque: #{p['estoque']})" }
      id_p = ler_inteiro("ID do Produto: ")
      if produtos.key?(id_p)
        qtd = ler_inteiro("Quantidade a adicionar: ")
        produtos[id_p]['estoque'] += qtd
        salvar_json(ARQUIVO_PRODUTOS, produtos)
        puts "--> Estoque atualizado!"
      end
    end

    puts "\nPressione ENTER para continuar..."
    gets

  when 5
    puts "\nRecarregando dados..."
    produtos = carregar_json(ARQUIVO_PRODUTOS)
    encomendas = carregar_json(ARQUIVO_ENCOMENDAS)
    puts "Pronto! Pressione ENTER..."
    gets

  when 6
    puts "\nSaindo do sistema da Papelaria Papelie... Ate logo!"
  end
end
