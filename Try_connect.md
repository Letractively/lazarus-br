# Tentar conectar ao banco com CGI #

Num módulo CGI não há a necessidade de reconexão (reconnect) a um banco de dados, pois o conector não terá um estado "conectado". No CGI você tenta conectar, e após isso, conecte ou não, a conexão é destruída. Então o que pode ser feito é apenas tentar conectar algumas vezes antes de destruir a conexão.

Se o módulo CGI estiver no mesmo PC do servidor do banco de dados então não há a necessidade de um try-connect pois a conexão será local (localhost), mas, caso não saibamos onde nosso banco de dados está (no mesmo host/PC do host alugado ou em outro alugado pelo host), então deixamos uma opção try-connect.

Já no caso de um projeto desktop que usa uma conexão externa, aí sim, o reconnect terá um valor muito importante, pois haverá (ou poderá haver) um estado "conectado", e os conectores (pelo menos a maioria escrito em Pascal) quando por algum motivo perdem a conexão com o banco, não permite reconectar usando "disconnect/connect", e sim apenas pelo "reconnect".

Um exemplo prático para usar tentativas para conectar ao banco (PostgreSQL) pode ser encontrado **[aqui](http://code.google.com/p/lazarus-br/source/browse/#svn%2Ftrunk%2Fweb%2FTryConnect)**.