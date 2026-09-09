const TELEFONE_LOJA = "5585994017943";

const produtos = [
  { 
    id: 1, 
    nome: "Marcador de Página (Personalizado)", 
    preco: 12.00,
    imagem: "imagens/marcador.jpg"
  },
  { 
    id: 2, 
    nome: "Chaveiro QR Code Instagram", 
    preco: 18.00,
    imagem: "imagens/chaveiro.jpg"
  },
  { 
    id: 3, 
    nome: "Caneta Decorada", 
    preco: 15.00,
    imagem: "imagens/caneta.jpg"
  }
];

let carrinho = [];

function carregarProdutos() {
  const container = document.getElementById("lista-produtos");
  container.innerHTML = "";

  produtos.forEach(prod => {
    const card = document.createElement("div");
    card.classList.add("card-produto");
    card.innerHTML = `
      <img src="${prod.imagem}" alt="${prod.nome}" class="foto-produto">
      <h3>${prod.nome}</h3>
      <p class="preco">R$ ${prod.preco.toFixed(2)}</p>
      <input type="text" id="detalhe-${prod.id}" placeholder="Detalhes (ex: Tema, Nome)">
      <button onclick="adicionarAoCarrinho(${prod.id})">Adicionar ao Pedido</button>
    `;
    container.appendChild(card);
  });
}

function adicionarAoCarrinho(idProduto) {
  const produto = produtos.find(p => p.id === idProduto);
  const campoDetalhe = document.getElementById(`detalhe-${idProduto}`);
  const detalhe = campoDetalhe.value.trim();

  carrinho.push({
    nome: produto.nome,
    preco: produto.preco,
    detalhe: detalhe || "Sem personalização específica"
  });

  campoDetalhe.value = "";
  atualizarCarrinho();
}

function atualizarCarrinho() {
  const container = document.getElementById("itens-carrinho");
  const elementoTotal = document.getElementById("valor-total");
  container.innerHTML = "";

  if (carrinho.length === 0) {
    container.innerHTML = '<p class="carrinho-vazio">Seu carrinho está vazio.</p>';
    elementoTotal.innerText = "0.00";
    return;
  }

  let total = 0;

  carrinho.forEach((item) => {
    total += item.preco;
    const div = document.createElement("div");
    div.classList.add("item-carrinho");
    div.innerHTML = `
      <div>
        <strong>${item.nome}</strong><br>
        <small>${item.detalhe}</small>
      </div>
      <div>
        <span>R$ ${item.preco.toFixed(2)}</span>
      </div>
    `;
    container.appendChild(div);
  });

  elementoTotal.innerText = total.toFixed(2);
}

function enviarWhatsapp() {
  const nomeCliente = document.getElementById("nome-cliente").value.trim();

  if (!nomeCliente) {
    alert("Por favor, digite seu nome antes de finalizar!");
    return;
  }

  if (carrinho.length === 0) {
    alert("Seu carrinho está vazio! Adicione pelo menos um produto.");
    return;
  }

  let texto = `Olá! Meu nome é *${nomeCliente}* e gostaria de fazer o seguinte pedido:\n\n`;
  let total = 0;

  carrinho.forEach((item) => {
    texto += `• *${item.nome}* - R$ ${item.preco.toFixed(2)}\n`;
    texto += `  Detalhe: _${item.detalhe}_\n`;
    total += item.preco;
  });

  texto += `\n*Total:* R$ ${total.toFixed(2)}`;

  const mensagemEncoded = encodeURIComponent(texto);
  const urlWhatsapp = `https://wa.me/${TELEFONE_LOJA}?text=${mensagemEncoded}`;

  window.open(urlWhatsapp, "_blank");
}

document.addEventListener("DOMContentLoaded", carregarProdutos);
