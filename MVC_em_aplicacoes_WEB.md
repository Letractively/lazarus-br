# MVC em aplicações WEB #

![http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/1.png](http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/1.png)

Mesmo o MVC tendo sido projetado como uma framework para aplicações desktop, há 3 décadas, ele se encaixou bem em aplicações web, as quais
requerem mapeamento de URLs e/ou direcionamento de mensagens HTTP (request/response). Este artigo resume o padrão MVC usado em aplicações Web.

## MVC para aplicações Desktop ##

O padrão MVC foi introduzido no começo dos anos 80, como um framework para aplicações desktop. À época, os widgets não tinham ainda a habilidade de processar as entradas dos usuários (cliques de mouse e digitação no teclado). O MVC introduziu a entidade Controller, para agir como uma ponte entre o usuário e a aplicação. No final dos anos 80, os widgets passaram a ter suporte nativo para processamento de entradas dos usuários, tornando obsoleto o papel do controller, e o MVC deu lugar ao MVP. Mesmo que o Presenter seja comumente citado como Controller, o autêntico controller permaneceu nas sobras até o surgimento das aplicações Web baseadas em navegadores (browsers).

## Web MVC ##

Em aplicações Web, no lado cliente, o usuário interage com o navegador, gerando requests HTTP (sejam POST ou GET) e enviam para o servidor. O
servidor processa o request (extrai os dados da URL ou do corpo do request), executa alguma operação do negócio, e cria a resposta (uma página HTML), a qual é enviada de volta para o cliente para ser renderizada no navegador.

![http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/2.png](http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/2.png)

## Colaboração ##

Componentes MVC residem no servidor: o **modelo** guarda os dados e lida com a lógica de negócios (como sempre), a **view** gera a resposta
(página HTML) de acordo com os dados do modelo, e o **controller** processa as entradas dos usuários presentes nos requests HTTP, comanda  o modelo - alterando o seu estado - e cria a view apropriada para ser reenviada para o cliente e renderizada na tela.

![http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/3.png](http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/3.png)

### Interação ###

A UI mostrada abaixo tem um único use case. O usuário clica no botão "votar". No banco de dados, a coluna que salva a quantidade de votos é
incrementada, e a caixa de texto é atualizada com o valor atual do número de votos.

![http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/4.png](http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/4.png)

A modelagem MVC para esta UI terá um objeto view, para gerar o HTML mostrado acima, um objeto de modelo, para incrementar e armazenar a contagem
de votos, e um controller para processar o pedido "post" iniciado quando o usuário clica no botão "votar". O controller comanda o modelo, e cria
a view para a geração da resposta, retornando-a para o cliente.

![http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/5.png](http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/5.png)

Nota do tradutor: Numa aplicação web escrita em Java, tipicamente é um servlet, que interage com a camada de negócios, e em seguida delega a
renderização da página a um JSP (um tipo especial de servlet). A view, neste caso, tem acesso direto aos objetos do modelo que o servlet salvar
como atributos da sessão do usuário. As frameworks web atuais costumam usar uma abordagem parecida com o AM-MVC, com uma camada de aplicação,
que tem a finalidade de blindar os objetos de negócio dos detalhes da view, ainda que a view tenha acesso direto a esses objetos.

![http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/6.png](http://lazarus-br.googlecode.com/svn/media/MVC_em_aplicacoes_WEB/6.png)

Nesta arquitetura toda lógica da aplicação (visualização, modelos de dados, relacionamento entre modelos) é definida no servidor.

[Este artigo é uma adaptação do artigo original em inglês](http://aviadezra.blogspot.com/2008/07/mvc-for-web-applications-and-aspnet.html).