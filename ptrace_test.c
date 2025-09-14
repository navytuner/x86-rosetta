#include <stdio.h>
#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/user.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

int main(){
  pid_t p;
  if ((p = fork()) == 0){
    printf("Child: requesting to be traced\n");
    ptrace(PTRACE_TRACEME, 0, NULL, NULL);
    execl("/bin/ls", "ls", "-l", NULL);
    perror("execve");
    exit(1);
  }
  else {
    int status;
    struct user_regs_struct regs;

    waitpid(p, &status, 0);
    printf("Parent: child stopped, reading registers...\n");

    if (ptrace(PTRACE_GETREGS, p, NULL, &regs) == -1){
      perror("ptrace GETREGS\n");
      exit(1);
    }

    printf("rip = 0x%llx\n", (unsigned long long)regs.rip);
    printf("rsp = 0x%llx\n", (unsigned long long)regs.rsp);
    printf("rax = 0x%llx\n", (unsigned long long)regs.rax);

    ptrace(PTRACE_CONT, p, NULL, NULL);
    waitpid(p, &status, 0);
    printf("Parent: child exited\n");
  }
  return 0;
}
