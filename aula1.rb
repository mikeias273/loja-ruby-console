produtos = {
  produto1: {
    nome: "Arroz",
    preco: 10,
    estoque:10
  },

  produto2: {
    nome:"Feijao",
    preco: 12,
    estoque:8
  },

  produto3: {
    nome:"Cafe",
    preco: 15,
    estoque:5 
  },

  produto4: {
    nome: "Leite",
    preco: 6,
    estoque:12 
  },

  produto5: {
    nome: "Bolacha",
    preco: 5,
    estoque:20
  }
}

quantidade_bolacha = 2 
preco_bolacha = produtos[:produto5][:preco]

total_bolacha = quantidade_bolacha * preco_bolacha

quantidade_leite = 3 
preco_leite = produtos[:produto4][:preco]

total_leite = quantidade_leite * preco_leite

total = total_bolacha + total_leite

quantidade_cafe = 1 
preco_cafe = produtos[:produto3][:preco]

total_cafe = quantidade_cafe * preco_cafe

total = total_cafe + total_bolacha + total_leite

 "Bolacha: #{quantidade_bolacha} Unidades"
 "Leite: #{quantidade_leite} Unidades"
 "Cafe: #{quantidade_cafe} Unidade"
 "Total: #{total}"

quantidade_arroz = 3
preco_arroz = produtos[:produto1][:preco]

total_arroz = quantidade_arroz * preco_arroz 

quantidade_feijao = 4
preco_feijao = produtos[:produto2][:preco]

total_feijao = quantidade_feijao * preco_feijao 

total = total_arroz + total_feijao

quantidade_cafe = 5
preco_cafe = produtos[:produto3][:preco]

total_cafe = quantidade_cafe * preco_cafe

quantidade_leite = 3
preco_leite = produtos[:produto4][:preco]

total_leite = quantidade_leite * preco_leite

total = total_arroz + total_feijao + total_cafe + total_leite 

puts "Produto: #{produtos[:produto1][:nome]}"
puts "Quantidade: #{quantidade_arroz}"
puts "Subtotal: #{total_arroz}"

puts

puts "Produto: #{produtos[:produto2][:nome]}"
puts "Quantidade: #{quantidade_feijao}"
puts "Subtotal: #{total_feijao}"

puts

puts "Produto: #{produtos[:produto3][:nome]}"
puts "Quantidade: #{quantidade_cafe}"
puts "Subtotal: #{total_cafe}"

puts

puts "Produto: #{produtos[:produto4][:nome]}"
puts "Quantidade: #{quantidade_leite}"
puts "Subtotal: #{total_leite}"
puts "Total da compra: #{total_arroz + total_feijao + total_cafe + total_leite}"

puts


puts "Quantos pacotes de arroz voce quer? (Estoque: #{produtos[:produto1][:estoque]})"
qtd = gets.chomp.to_i
if qtd <= produtos[:produto1][:estoque]
  quantidade_arroz = qtd 
  produtos[:produto1][:estoque] -= qtd 
else 
  puts "Estoque insuficiente de Arroz! Nao foi adicionado."
  quantidade_arroz = 0 
end 

puts "Quantos pacotes de feijao voce quer? (Estoque: #{produtos[:produto2][:estoque]})"
qtd = gets.chomp.to_i
if qtd <= produtos[:produto2][:estoque]
  quantidade_feijao = qtd 
  produtos[:produto2][:estoque] -= qtd 
else 
  puts "Estoque insuficiente de feijao! Nao foi adicionado."
  quantidade_feijao = 0
end 

puts"Quantos pacotes de cafe voce quer? (Estoque: #{produtos[:produto3][:estoque]})"
qtd = gets.chomp.to_i 
if qtd <= produtos[:produto3][:estoque]
  quantidade_cafe = qtd 
  produtos[:produto3][:estoque] -= qtd 
else 
  puts "Estoque insuficiente de cafe! Nao foi adicionado."
  quantidade_cafe = 0
end 

puts "Quantos pacotes de leite voce quer? (Estoque: #{produtos[:produto4][:estoque]})"
qtd = gets.chomp.to_i 
if qtd <= produtos[:produto4][:estoque]
  quantidade_leite = qtd 
  produtos[:produto4][:estoque] -= qtd 
else 
  puts "Estoque insuficiente de cafe! Nao foi adicionado."
  quantidade_leite = 0
end 

puts

subtotal_arroz = quantidade_arroz * preco_arroz 
subtotal_feijao = quantidade_feijao * preco_feijao 
subtotal_cafe = quantidade_cafe * preco_cafe 
subtotal_leite = quantidade_leite * preco_leite 
total = subtotal_arroz + subtotal_feijao + subtotal_cafe + subtotal_leite 

puts "RESUMO DA COMPRA"
puts "Subtotal_arroz: R$#{subtotal_arroz}"
puts "Subtotal_feijao: R$#{subtotal_feijao}"
puts "Subtotal_cafe: R$#{subtotal_cafe}"
puts "Subtotal_leite: R$#{subtotal_leite}"
puts "Total geral: R$#{total}"

if total> 100
  desconto = total * 0.10 
  total_com_desconto = total - desconto 
  puts "Voce ganhou 10% de desconto! R$#{desconto}"
  puts "Total a pagar: R$#{total_com_desconto}"
else 
  puts "Total a pagar: R$#{total}"
end 

puts 

opcao = 0
total_compra = 0
carrinho = [] 

while opcao != 5 
  system("clear")
  puts "--- MENU DA LOJA ---"
  puts "1 - Ver produtos"
  puts "2 - Comprar"
  puts "3 - Ver carrinho"
  puts "4 - Finalizar compra"
  puts "5 - Sair"

  print "Escolha uma opcao: "
  opcao = gets.chomp.to_i  

  case opcao 
  when 1 
    puts "--- PRODUTOS DISPONIVEIS ---"
    puts "1 - Arroz: R$ 10"
    puts "2 - Feijao: R$ 12"
    puts "3 - Cafe: R$ 15"
    puts "4 - Leite: R$ 6"

    puts "Pressione ENTER para voltar ao menu..."
    gets

  when 2
    puts "-- COMPRAR PRODUTO --"
    puts "1 - Arroz R$ 10"
    puts "2 - Feijao R$ 12"
    puts "3 - Cafe R$ 15"
    puts "4 - Leite R$ 6"

    print "Qual produto voce quer? (1,2,3,4):"
    produto_escolhido = gets.chomp.to_i 

    print "Quantas Unidades?" 
    quantidade = gets.chomp.to_i 

    if produto_escolhido == 1 
      nome_produto = "Arroz"
      preco = 10 
    elsif produto_escolhido == 2
      nome_produto = "Feijao"
      preco = 12 
    elsif produto_escolhido == 3
      nome_produto = "Cafe"
      preco = 15 
    elsif produto_escolhido == 4
      nome_produto = "Leite"
      preco = 6 
    else
      nome_produto = ""
      preco = 0 
      puts "Produto invalido!"
end

    subtotal = preco * quantidade 
    total_compra = total_compra + subtotal 
    carrinho << "#{quantidade}x #{nome_produto} - R$ #{subtotal}"

    puts "(Subtotal dessa compra: R$ #{subtotal})"

    puts "Pressione ENTER para voltar ao menu..."
    gets 
    
  when 3 
    puts "-- SEU CARRINHO --"
    if carrinho.empty?
      puts "Seu carrinho esta vazio!"
    else 
      carrinho.each do |item|
        puts "-#{item}"
      end 
    end 

    puts "Total acumulado ate agora: R$ #{total_compra}"

    puts "Pressione ENTER para voltar ao menu..."
    gets 

  when 4
    puts "--- FINALIZANDO COMPRA ---"
    puts "Total acumulado: R$ #{total_compra}"

    if total_compra > 100
      desconto = total_compra * 0.10
      total_final = total_compra - desconto 
      puts "Parabens! Ganhou 10% de desconto R$#{desconto}"
      puts "Total a pagar: R$#{total_final}"
    else 
      puts "Total a pagar: R$ #{total_compra}"
    end 

    total_compra = 0 # zeramos para a proxima compra!
    carrinho.clear # Limpa a lista de itens!
    puts "Obrigado pela compra!"

    puts "Pressione ENTER para voltar ao menu..."
    gets 
end
end
