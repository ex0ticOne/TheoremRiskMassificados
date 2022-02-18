
options(warn = -1)

#Lê argumento da linha de comando com o dataset a ser tratado
argumentos <- commandArgs(trailingOnly = TRUE)

if(length(argumentos) == 0) {
  stop("Uso: tr_geral_atuarial.R [dataset em .csv] \n Para mais informações de uso desse script, acesse o README_massificados.md")
}

#Carrega o arquivo do dataset e a tabela com os códigos SUSEP de ramos e seguradoras
message("-------------------------------------------")
message("TheoremRisk - Massificados - Versão 1.0")
message("-------------------------------------------")
message(cat("Lendo e analisando os dados do dataset", argumentos[1]))
message("Isso pode durar alguns minutos, aguarde.")
tbl_ses <- read.csv2(argumentos[1])
codigo_ramos <- read.csv("cod_ramos.csv")
codigo_segs <- read.csv("cod_segs.csv", encoding = "ISO-8859-1")

#Converte o código do ramo para fator
tbl_ses$coramo <- as.factor(tbl_ses$coramo)

#Cria variáveis e carrega os parâmetros do arquivo
parametros_calculo <- read.csv("parametros.csv")
tamanho_carteira <- as.integer(parametros_calculo[1, 2])
ramo_escolhido <- as.character(parametros_calculo[2, 2])
margem_seguranca <- parametros_calculo[3, 2] / 100
taxa_perda <- parametros_calculo[4, 2] / 100
taxa_inadimplentes <- parametros_calculo[5, 2] / 100
data_inicio <- parametros_calculo[8, 2]
data_fim <- parametros_calculo[9, 2]
cia_escolhida <- as.numeric(parametros_calculo[10, 2])

#Separa o subset de acordo com o mês e ano inicial e final e a companhia escolhida no arquivo de parâmetros . 
tbl_ses_subset <- tbl_ses[tbl_ses$damesano >= data_inicio & 
                          tbl_ses$damesano <= data_fim & 
                          tbl_ses$coenti == cia_escolhida &
                          tbl_ses$sinistro_ocorrido > 0 &
                          tbl_ses$premio_ganho > 0, ]

#Calcula a sinistralidade
tbl_ses_subset$sinistralidade <- round(as.double(tbl_ses_subset$sinistro_ocorrido / tbl_ses_subset$premio_ganho), digits = 4)

#Soma os sinistros ocorridos por ramo e compila em nova tabela
tbl_sinistro_ramos <- data.frame(tapply(X = tbl_ses_subset$sinistro_ocorrido, INDEX = tbl_ses_subset$coramo, FUN = "sum"))
tbl_sinistro_ramos <- na.exclude(tbl_sinistro_ramos)
colnames(tbl_sinistro_ramos) <- c("Valor")

#Calcula o prêmio puro pelo método do rateio proporcional simples das perdas
premio_puro <- tbl_sinistro_ramos[ramo_escolhido, 1] * (1 + margem_seguranca) / (tamanho_carteira * (1 - taxa_perda - taxa_inadimplentes))

#Prossegue para o script de cálculo de prêmio bruto
message("Iniciando o script de cálculo de prêmio bruto")
Sys.sleep(1)

source('tr_geral_calculo.R')