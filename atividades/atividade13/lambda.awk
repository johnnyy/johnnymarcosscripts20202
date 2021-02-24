BEGIN{
	print "Relatório da execução do lambda"
}


	$0 ~ /\tDuration/ {
		count_total = count_total + 1
		sucesso = sucesso + 1
		time_exec = $7 + time_exec
	}
	
	$0 ~ /timed out/ {
		count_total = count_total + 1
		falha = falha + 1
	}

END{
	printf "Total de Invocações é %d\n", count_total
	printf "Total de Invocações com sucesso é %d\n", sucesso
	printf "Total de Invocações com falha é %d\n", falha
	printf "Tempo médio das invocações com sucesso é %.3f\n", time_exec/sucesso
}
