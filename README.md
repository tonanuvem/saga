# saga

Exemplo de SAGA utilizando NIFI para orquestrar event-driven microservices

Contexto:

- Quando construímos nosso modelo de domínio usando a terminologia DDD, identificamos Entidades, Objetos de Valor (atributos) e Agregados (conjunto de entidades/atributos). Os agregados são objetos que encapsulam outras entidades / atributos e são responsáveis por impor restrições (pode haver vários agregados dentro de um determinado contexto (bounded context).
 
 - Dentro de cada contexto, precisamos identificar os limites transacionais onde há restrições.
 
Diagrama:

> https://dbdiagram.io/d/6183dfe4d5d522682df8aea9

Links:

> https://blog.christianposta.com/microservices/the-hardest-part-about-microservices-data/
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
