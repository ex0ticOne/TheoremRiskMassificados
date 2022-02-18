
#Cria variáveis e pega parâmetros do arquivo de configuração
carregamento <- parametros_calculo[6, 2] / 100
iof <- parametros_calculo[7, 2] / 100

#Calcula o prêmio bruto do ramo escolhido
premio_comercial <- premio_puro / (1 - carregamento)
premio_bruto <- round(premio_comercial * (1 + iof), digits = 2)

#Exibe o resultado no terminal
message("-------------------------------------------")
message("Parâmetros considerados para os cálculos")
message(cat("Ramo", ramo_escolhido, codigo_ramos[codigo_ramos$cod_ramo == ramo_escolhido, 2]))
message(cat("Período analisado", data_inicio, "até", data_fim))
message(cat("Margem de segurança", margem_seguranca * 100, "%"))
message(cat("Companhia escolhida", cia_escolhida, codigo_segs[codigo_segs$CodigoFIP == cia_escolhida, 2]))
message(cat("Tamanho da carteira", tamanho_carteira, "apólices vigentes"))
message(cat("Taxa de perda esperada", taxa_perda * 100, "%"))
message(cat("Taxa de inadimplentes esperada", taxa_inadimplentes * 100, "%"))
message(cat("Carregamento", carregamento * 100, "%"))
message(cat("Valor do IOF", iof * 100, "%"))
message("-------------------------------------------")
message(cat("Prêmio ao consumidor final: R$", premio_bruto))

