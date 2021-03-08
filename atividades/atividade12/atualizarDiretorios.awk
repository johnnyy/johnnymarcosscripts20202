# OK
BEGIN{}
	 gsub("/home/alunos","/srv/students")1 { print $0  > "passwd.new" }
END{}
