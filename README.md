# Rastro

Editor e jogo de tabuleiros digitais, em português, executado diretamente no navegador.

## Executar

Para testar no computador, sirva a pasta por HTTP, por exemplo com `python -m http.server 8000`, e abra `http://localhost:8000`. Não é necessário instalar dependências.

Para instalar no celular, publique estes arquivos em um endereço HTTPS e use a opção **Adicionar à tela inicial/Instalar app** do navegador. O acesso offline fica disponível depois que o app for carregado uma vez com internet. Abrir o HTML por `file://` continua funcionando, mas não permite instalar o PWA nem usar o modo offline do service worker.

## Recursos

- Crie nós numerados e conexões direcionais; conecte trilhas existentes para formar bifurcações e junções.
- Navegue com pan, zoom por roda/pinch, encaixe, desfazer/refazer e arraste de nó com espera de 500 ms.
- Configure eventos, espera, bloqueio, emboscada e suprimentos com texto, imagem e recompensas.
- Faça upload de imagem de fundo, importe/exporte o mapa em JSON e use o modelo ou exemplo de desafio.
- Jogue com dois dados, movimento no grafo, inventário, especiais, bloqueios e horda com perseguição BFS a cada 4 segundos.
- Salve tabuleiros nomeados, restaure até cinco backups automáticos e use autosave com debounce de 1,5 s.
- Instale como PWA e abra a interface offline depois do primeiro carregamento.
- Layout responsivo para desktop e celular.
- Tiles com célula padrão de 256 px, opção de 512 px para alta resolução, renderização suave e transformações por célula (90°, 180°, 270°, inversão horizontal e vertical).
- PNGs oficiais podem ser organizados na pasta [tiles/](tiles/) do projeto. Ao abrir o HTML diretamente, o navegador mantém uma cópia persistida do upload; ele não consegue gravar automaticamente na pasta por limitações de segurança do navegador.

## Armazenamento e aparelhos

O autosave, os tabuleiros nomeados, os backups e os assets ficam no armazenamento local do navegador (IndexedDB; versões anteriores são migradas automaticamente). O app solicita ao navegador que preserve esse armazenamento. A disponibilidade depende das políticas do aparelho e do navegador: limpar os dados do site/app ou desinstalá-lo pode apagar os dados.

Os dados são isolados por aparelho e endereço do app. Não há servidor, conta ou sincronização nesta versão; instalar o PWA no celular não transfere os tabuleiros do computador. Para transferir um tabuleiro manualmente, use **Exportar** e depois **Importar** no outro aparelho.