#Professor com maior salario por curso
{
	if (NR != 1){

		nome=$1
		curso=$2
		salario=$3
		if ( salario > salario_maior_[curso] ){
			salario_maior_[curso] = salario
			nome_maior_[curso] = nome
			nome_curso[curso] = curso
		}
	}
	

}

END{
	for ( curso in nome_curso){
		printf "%s: %s, %d\n", curso, nome_maior_[curso], salario_maior_[curso]
	}
}
