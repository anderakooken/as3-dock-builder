# Szarca Dock *Builder* 

Editor/Criador de arquivos com extensão **.szd** (szarca-dock). O arquivo SZD é basicamente com XML encriptado, contendo em suas tags as informações sobre o funcionamento do projeto e os objetos a serem monitorados, sendo a chave de criptografia informada no próprio código AS3.

Imagem do software em produção no Windows 11: [Behance](https://www.behance.net/gallery/169059953/Dock-Builder)

O software `Dock Builder é apenas um editor`, ou seja, apenas cria/edita os arquivos de monitoramento. Para o software de execução (Player) , consulte o  [Szarca Dock](https://github.com/anderakooken/szarca-dock)

# Premissas

O frontend da aplicação é desenvolvido com Adobe AIR, na linguagem **AS3 (Action Script 3.0)**. O backend pode ser utilizado com qualquer linguagem de programação, contanto que as requisições sejam realizadas via **HTTP/HTTPS** e seja respeitado a estrutura do arquivo de retorno que é desenhado **XML**.

## Softwares necessários

Para edição do frontend, sugiro utilizar o **Adobe CS5.5** ou superior, pois essas versões são estáveis. Uma vez que o desenvolvedor instale o software sugerido, este também contem o runtime do **Adobe AIR**, que é a única obrigatoriedade para rodar a aplicação.  

## Estrutura do projeto

|  Arquivo|||
|----------------|-------------------------------|-----------------------------|
|szarca-dock-builder.fla| Arquivo para edição do programa| Código AS3 incluso na Timeline (Camada 1) |
|szarca-dock-builder.air          |`Executavél compilado na última versão`||
|szarca-dock-builder.as|Código fonte da aplicação.| O mesmo código está incluído no szarca-dock-builder.fla|

Outros arquivos são apenas dependências, tais como bibliotecas externas, imagens ou scripts de uso do Adobe Air.