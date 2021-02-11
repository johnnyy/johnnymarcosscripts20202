BEGIN{}
	 gsub("/home/alunos","/home/students")1 { print $0  > "passwd.new" }
END{}
