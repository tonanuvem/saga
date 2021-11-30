# saga

Exemplo de SAGA utilizando NIFI para orquestrar event-driven microservices

Motivação:
- A arquitetura de microsserviços decompõe um aplicativo em serviços, cada um correspondendo a uma capacidade de negócios. Desafios dessa arquitetura envolvem transações distribuídas, separação em domínio e consultas de informações decompostas em várias entidades aplicando a ideia de um "agregado do DDD (Domain Driven Design)". Dentro de cada serviço, uma transação cria ou atualiza um único agregado. Os eventos são usados para manter a consistência dos dados entre agregados.

Contexto:

- Terminologia DDD engloba dentre seus termos: Entidades, Objetos de Valor (atributos) e Agregados (conjunto de entidades/atributos). 
- Os agregados são objetos que encapsulam outras entidades/atributos e são responsáveis por impor restrições (violação de uma regra de negócios).
- Pode haver vários agregados dentro de um determinado contexto (bounded context).
- Dentro de cada contexto, precisamos identificar os limites transacionais onde há restrições.
- Os serviços usam Eventos para manter a consistência entre os agregados da seguinte forma: um agregado publica um evento sempre que algo importante acontece, como mudança de estado ou tentativa de violação de uma regra de negócios (restrição). Outros agregados se inscrevem em eventos e respondem os eventos atualizando seu próprio estado.

Sequência de eventos (caminho feliz):

1) Pedido (agregado) é criado com um status NOVO e publica-se um evento "PedidoCriado".
2) Pagamento (agregado) consome o evento "PedidoCriado", tenta aprovar o crédito para o pedido e publica um evento "PagamentoAprovado".
3) Estoque/Produto (agregado) consome o evento "PagamentoAprovado" e altera a quantidade em estoque de cada item, publicando na sequência um evento "EstoqueAtualizado".
4) Entrega/Delivery (agregado) consome o evento "EstoqueAtualizado" e envia os itens, publicando um evento "ItensEnviados".

![alt text](https://imgopt.infoq.com/fit-in/1200x2400/filters:quality(80)/filters:no_upscale()/articles/microservices-aggregates-events-cqrs-part-1-richardson/en/resources/figure6.jpg)

Compensações (fluxos de exceção, em caso de falhas):

5) Se a autorização de pagamento falhar devido a créditos insuficientes, o agregado Pagamento publica um evento "PagamentoRejeitado". Este evento não corresponde a uma mudança de estado, mas representa uma tentativa fracassada que viola uma regra de negócios. O agregado Pedido consome esse evento e altera seu estado para CANCELADO_PAGAMENTO_REJEITADO.
6) Se Estoque falhar devido a quantidades insuficientes, o agregado Estoque publica um evento "EstoqueRejeitado". Este evento não corresponde a uma mudança de estado, mas representa uma tentativa fracassada que viola uma regra de negócios. O agregado Pedido consome esse evento, remove itens sem estoque do pedido e atualiza seu estado para ATUALIZADO_ESTOQUE_INSUFICIENTE.
7) Se Entrega falhar ao tentar submeter o envio por uma transportadora, o agregado Entrega publica um evento "EnvioeRejeitado". Este evento não corresponde a uma mudança de estado, mas representa uma tentativa fracassada que viola uma regra de negócios. O agregado Pedido consome esse evento e atualiza seu estado para PENDENTE_FALHA_ENVIO, o qual poderá ser tratado conforme definição da área de negócios.
 
Diagramas:

> https://dbdiagram.io/d/6183dfe4d5d522682df8aea9

Links:

> https://blog.christianposta.com/microservices/the-hardest-part-about-microservices-data/
<br> <br>
> https://www.infoq.com/articles/microservices-aggregates-events-cqrs-part-1-richardson/
<br> <br>
> https://thedataengineer.com.br/2021/05/09/nifi-consumo-dados-rest/
<br> <br>
> https://github.com/WoodyFleurant/nifi-poc
<br> <br>
> https://github.com/jfrazee/awesome-nifi
<br> <br>
> https://capgemini.github.io/development/introduction-nifi-best-practices/
<br> <br>
> https://www.compose.com/articles/mongo-to-mongo-data-moves-with-nifi/
<br> <br>
> https://nifi.apache.org/docs/nifi-docs/html/expression-language-guide.html
<br> <br>
> https://community.cloudera.com/t5/Support-Questions/Nifi-How-to-add-key-value-to-json/td-p/200907
<br> <br>
> https://community.cloudera.com/t5/Community-Articles/Jolt-quick-reference-for-Nifi-Jolt-Processors/ta-p/244350
<br> <br>
> https://jolt-demo.appspot.com/
