BEGIN{
printf "Relatório de Latência.\n"
}

{ system("ping " $0 " -c 5 | grep 'avg' | sed -e 's/.*= //g' | cut -d '/' -f2 | xargs printf  '%s %sms\n' "$0 ) }

END{}
