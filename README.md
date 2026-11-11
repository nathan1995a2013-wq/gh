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

O progresso da partida fica no armazenamento local do navegador (IndexedDB) e é separado por versão publicada do tabuleiro. O app solicita ao navegador que preserve esse armazenamento; limpar os dados do site/app ou desinstalá-lo pode apagá-lo.

O rascunho do editor, os tabuleiros nomeados e seus até cinco backups são salvos localmente e sincronizados com o Supabase quando configurado e conectado à internet. O rascunho não é público. Só contas autorizadas como editoras podem carregá-lo ou alterá-lo; a tabela separada de publicação é pública para os jogadores. Alterações simultâneas são detectadas para evitar sobrescrever silenciosamente o trabalho de outro aparelho.

O modo jogador só carrega o tabuleiro publicado. O progresso individual da partida continua local ao aparelho e não é enviado ao Supabase.

### Configurar a sincronização Supabase

O site continua estático e hospedado no GitHub Pages; o Supabase é usado apenas como banco e autenticação. Para ativar:

1. Crie um projeto no Supabase e execute o conteúdo de [supabase-setup.sql](supabase-setup.sql) no SQL Editor do projeto.
2. Crie sua conta de editor em **Authentication → Users** e copie o UUID dela.
3. No SQL Editor, autorize apenas essa conta, substituindo o UUID:

   ```sql
   insert into public.board_editors (user_id)
   values ('UUID-DA-SUA-CONTA');
   ```

4. Preencha `url` e `anonKey` em [supabase-config.js](supabase-config.js) com a URL do projeto e sua chave pública (anon/publishable), disponíveis no painel do Supabase. Essa chave pública pode estar no site; as políticas RLS do SQL protegem o rascunho. **Nunca coloque a chave `service_role` no site ou no GitHub.**
5. Publique a alteração no GitHub Pages. Entre em **Entrar** primeiro no aparelho que contém seus tabuleiros atuais: na primeira sincronização, esse aparelho envia o rascunho e os tabuleiros salvos. Nos outros aparelhos, entre com a mesma conta para carregá-los. Somente contas cadastradas em `board_editors` abrem o editor; contas de jogador permanecem no jogo, que também pode ser usado sem login.
6. Edite normalmente; o autosave local continua com debounce de 1,5 s e envia o rascunho à nuvem quando conectado. Use **Publicar** para atualizar o tabuleiro que os jogadores veem. O PWA mantém a interface e a última publicação carregada disponíveis offline; entrar pela primeira vez e publicar exigem internet.

Se duas sessões editarem o mesmo rascunho ao mesmo tempo, **Sincronizar** detecta a divergência e permite carregar a cópia da nuvem ou enviar explicitamente a cópia local. O editor não sobrescreve a outra versão sem essa escolha.

O endereço e a chave pública do Supabase são configuração, não credenciais administrativas. A senha do editor não é gravada no código nem enviada ao GitHub.

No celular, abra o painel **☷** para acessar as ações do editor (tabuleiros, tiles, importar/exportar, sincronizar, publicar e sair). Use os controles `+`/`−`, o gesto de pinça ou **Encaixar tabuleiro** para navegar pelo mapa.