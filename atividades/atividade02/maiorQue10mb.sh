mkdir maiorque10
find pasta_arquivos/ -size +10000k -exec mv {} maiorque10/ \;
tar -czf maiorque10.tar.gz maiorque10/
rm -r maiorque10


#Usei +10000k pq com o uso do +10M os arquivos maiores que 10mb e menores que 11mb não estavam sendo selecionados
#Creio que pelo uso da forma interia do +10M, revendo tudo menor que 11M
