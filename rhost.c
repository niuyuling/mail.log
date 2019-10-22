#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <time.h>

#define BUFFER 270

int main(int argc, char *argv[])
{
    FILE *fp;
    char *temp;
    char buffer[BUFFER];
    time_t timep;
    struct tm *p;
    time(&timep);
    p = localtime(&timep);
    char p1[2];

    if (p->tm_mday >= 10) {
        if ((fp =
             popen
             ("grep -E \"^$(date \"+%h\").$(date \"+%d\")\" /var/log/auth.log | grep failure | grep rhost",
              "r")) == NULL) {
            return 1;
        }
    } else {
        if ((fp =
             popen
             ("grep -E \"^$(date \"+%h\")..$(date | awk '{print $3}')\" /var/log/auth.log | grep failure | grep rhost",
              "r")) == NULL) {
            return 1;
        }
    }

    while (fgets(buffer, BUFFER, fp) != NULL) {
        temp = strstr(buffer, "rhost");
        sscanf(temp, "rhost=%s", temp);
        
        if (atoi(strncpy(p1, temp, 1)) > 0)
            printf("%s\n", temp);
    }

    pclose(fp);
    return 0;
}
