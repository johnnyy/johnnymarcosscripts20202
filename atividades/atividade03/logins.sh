grep -v "sshd" auth.log.1
grep -E "sshd\[[0-9]*\]: pam_unix\(sshd:session\): session opened" auth.log.1
grep -E "sshd\[[0-9]*\]: Disconnected from authenticating user root" auth.log.1
grep -E "Dec  4 (18:[0-5][0-9]:[0-9]{2}|19:00:00) programacaoscripts sshd\[[0-9]*\]: pam_unix\(sshd:session\): session opened" auth.log.1 
