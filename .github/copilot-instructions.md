# Instruções do projeto

- Mantenha a interface e os textos voltados ao usuário em português do Brasil.
- O app é estático e sem dependências: `index.html` deve continuar abrindo diretamente no navegador, sem etapa de build.
- A persistência é local ao aparelho (`IndexedDB`, com migração de dados legados do `localStorage`); não presuma API, nuvem ou sincronização externa.
- O PWA usa um service worker para abrir a interface offline; os dados não sincronizam entre aparelhos.
- Preserve o autosave de 1,5 s e o limite de cinco backups por tabuleiro nomeado.
- A horda persegue pelo grafo e avança em intervalos constantes de 4 s; evite avançá-la como efeito colateral de ações do jogador.
- Ao alterar interações do tabuleiro, teste no navegador criação/conexão de nós e fluxo básico do jogo.