# 1. BANCO DE DADOS DE PRODUTOS
produtos = {
  1 => { nome: "Arroz",   preco: 10, estoque: 10 },
  2 => { nome: "Feijao",  preco: 12, estoque: 8 },
  3 => { nome: "Cafe",    preco: 15, estoque: 5 },
  4 => { nome: "Leite",   preco: 6,  estoque: 12 },
  5 => { nome: "Bolacha", preco: 5,  estoque: 20 }
}

# 2. VARIÁVEIS DE SESSÃO
carrinho = []
total_compra = 0
opcao = 0

# 3. LOOP PRINCIPAL DO SISTEMA
while opcao != 5
  system("clear")
  puts "===================================="
  puts "       LOJA VIRTUAL - MENU          "
  puts "===================================="
  puts "1 - Ver Produtos e Estoque"
  puts "2 - Comprar Produto"
  puts "3 - Ver Carrinho de Compras"
  puts "4 - Finalizar Compra (Checkout)"
  puts "5 - Sair"
  puts "===================================="
  print "Escolha uma opcao: "
  opcao = gets.chomp.to_i

  case opcao
  when 1
    system("clear")
    puts "--- PRODUTOS DISPONIVEIS ---"
    produtos.each do |id, item|
      puts "#{id} - #{item[:nome]} | Preco: R$ #{item[:preco]} | Estoque: #{item[:estoque]} un"
    end
    puts "\nPressione ENTER para voltar ao menu..."
    gets

  when 2
    system("clear")
    puts "--- REALIZAR COMPRA ---"
    produtos.each do |id, item|
      puts "#{id} - #{item[:nome]} (R$ #{item[:preco]}) - Estoque: #{item[:estoque]}"
    end

    print "\nDigite o numero do produto desejado: "
    id_produto = gets.chomp.to_i

    if produtos.key?(id_produto)
      produto = produtos[id_produto]

      print "Quantas unidades de #{produto[:nome]} voce quer? "
      qtd = gets.chomp.to_i

      if qtd <= 0
        puts "\nQuantidade invalida!"
      elsif qtd <= produto[:estoque]
        # Abate do estoque
        produto[:estoque] -= qtd

        # Calcula subtotal e atualiza carrinho
        subtotal = produto[:preco] * qtd
        total_compra += subtotal
        carrinho << "#{qtd}x #{produto[:nome]} - R$ #{subtotal}"

        puts "\n--> Sucesso: #{qtd}x #{produto[:nome]} adicionado(s) ao carrinho!"
        puts "--> Subtotal do item: R$ #{subtotal}"
      else
        puts "\n--> Ops! Estoque insuficiente. Temos apenas #{produto[:estoque]} unidades disponiveis."
      end
    else
      puts "\nProduto nao encontrado!"
    end

    puts "\nPressione ENTER para voltar ao menu..."
    gets

  when 3
    system("clear")
    puts "--- SEU CARRINHO DE COMPRAS ---"
    if carrinho.empty?
      puts "O seu carrinho esta vazio!"
    else
      carrinho.each do |item|
        puts "- #{item}"
      end
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

      # Aplicação do Desconto
      if total_compra > 100
        desconto = total_compra * 0.10
        total_final = total_compra - desconto
        puts "Parabens! Voce ganhou 10% de desconto (-R$ #{desconto})"
        puts "TOTAL A PAGAR: R$ #{total_final}"
      else
        puts "TOTAL A PAGAR: R$ #{total_compra}"
      end

      # Zerando carrinho e compras após fechar pedido
      carrinho.clear
      total_compra = 0
      puts "\nObrigado pela compra! Volte sempre."
    end

    puts "\nPressione ENTER para voltar ao menu..."
    gets

  when 5
    puts "\nSaindo do sistema... Ate logo!"
  else
    puts "\nOpcao invalida! Pressione ENTER para tentar novamente..."
    gets
  end
end
