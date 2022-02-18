## TheoremRisk - Seguros Massificados

Os scripts para os seguros massificados calculam prêmios de seguro e estatísticas com base nos datasets disponibilizados pelo sistema SES da SUSEP - Superintendência de Seguros Privados. <http://www2.susep.gov.br/redarq.asp?arq=BaseCompleta%2ezip>

Para usar esses scripts, baixe o pack com os datasets por meio do link acima

Os scripts para seguros massificados foram escritos para lerem e analisarem o dataset 'Ses_seguros.csv', que contém dados prêmios diretos, prêmios ganhos, sinistros ocorridos e demais informações elencadas por data/companhia/grupo/ramo. Outros datasets não funcionarão com esse script por enquanto, mas adicionarei novo código para analisá-los quando possível.

### Método de precificação

O método atuarial utilizado no script dos seguros massificados é o método de rateio proporcional simples das perdas, onde o prêmio puro é calculado dividindo-se o montante gasto em indenizações igualmente entre toda a carteira vigente, considerando margem de segurança e taxas esperadas de cancelamento/não renovação e inadimplentes, e a partir desse prêmio base são adicionadas variáveis contábeis, tributárias e comerciais até chegar ao prêmio final ofertado ao consumidor.

Para usar os scripts desse projeto, é necessário que o seu sistema operacional (Linux, Windows ou Mac) possua o interpretador da linguagem R instalado para uso em linha de comando. Para melhor comodidade e estudo desse script, use uma IDE específica para a linguagem R, como o RStudio.

### O que é cada arquivo?

`parametros.csv`: parâmetros que o script `tr_geral_calculo.R` e utilizará para o cálculo dos prêmios ao consumidor final. Manter os nomes e a ordem dos parâmetros inalterados, apenas modifique os valores da segunda coluna de acordo com a sua preferência antes de executar `tr_geral_atuarial.R`.

#### Variáveis de `parametros.csv`

`tamanho_carteira`: tamanho da carteira em quantidade de apólices condizente com o período compreendido em `data_inicio` e `data_fim` (Ex: ao inserir 202101 e 202112, incluir a quantidade de apólices no espaço de 12 meses). Valor em número inteiro

`ramo_escolhido`: código SUSEP do ramo de seguro a ser calculado. Para entender os códigos e seus respectivos ramos, acesse o arquivo `cod_ramos.csv` . Seguir o padrão desse arquivo.

`margem_seguranca`: margem de segurança para evitar prejuízos por desvios bruscos ou altas repentinas de sinistralidade. Valor em %

`cia_escolhida`: código da companhia para os dados do dataset a serem analisados. Para ter precisão nos preços usando esse parâmetro, use um valor em `tamanho_carteira` condizente com o porte da companhia escolhida e sua carteira em `ramo_escolhido`. Para entender os códigos e as respectivas seguradoras, acesse o arquivo `cod_segs.csv` .

`data_inicio`: Data de início dos dados do dataset a serem analisados. Formato em AAAAMM

`data_fim`: Data limite dos dados do dataset a serem analisados. Deve ser maior que data_inicio. Formato em AAAAMM

`taxa_perda`: taxa de cancelamento/não renovação esperada para a próxima vigência ou período. Valor em %

`taxa_inadimplentes`: taxa de inadimplentes esperada para a próxima vigência ou período. Valor em %

`carregamento`: carregamento, compreendendo despesas administrativas, comissionamento do corretor, margem de lucro e impostos indiretos. Valor em %

`iof`: Imposto sobre Operações Financeiras vigente para os seguros de acordo com a legislação tributária. Valor em %

### Scripts

`tr_geral_atuarial.R`: calcula o prêmio puro com base no método de precificação explicado anteriormente.

`tr_geral_calculo.R`: é chamado automaticamente após a execução de `tr_geral_atuarial.R`. Calcula o prêmio ao consumidor final levando em consideração os prêmios base obtidos e os parâmetros existentes em `parametros.csv`, e exibe o resultado no terminal.

Determinados ramos, por serem raros dentro das carteiras, podem apresentar indisponibilidade de resultados devido à ausência de sinistros ocorridos. Para evitar esse problema, o código executa um processo de suavização de Laplace durante o cálculo do prêmio puro, artificialmente somando +1 em todos os dados de sinistros ocorridos.

### Uso/Sintaxe

`[interpretador R] [tr_geral_atuarial.R] [caminho do dataset Ses_seguros.csv no seu computador]`

Exemplo: `Rscript tr_geral_atuarial.R Ses_seguros.csv`
