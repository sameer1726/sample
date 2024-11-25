Here’s a simplified and easier version for each of the tasks:

---

### *A. Shell Program to Reverse a String*
bash
#!/bin/bash
echo "Enter a string:"
read str
echo "Reversed string: $(echo $str | rev)"


---

### *B. File Transfer Using Message Queue (IPC)*

#### *Sender Program*
c
#include <stdio.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <string.h>

struct message {
    long type;
    char text[100];
};

int main() {
    key_t key = ftok("queuefile", 65);
    int msgid = msgget(key, 0666 | IPC_CREAT);

    struct message msg;
    msg.type = 1;

    printf("Enter a message: ");
    fgets(msg.text, 100, stdin);

    msgsnd(msgid, &msg, sizeof(msg), 0);
    printf("Message sent.\n");
    return 0;
}


#### *Receiver Program*
c
#include <stdio.h>
#include <sys/ipc.h>
#include <sys/msg.h>

struct message {
    long type;
    char text[100];
};

int main() {
    key_t key = ftok("queuefile", 65);
    int msgid = msgget(key, 0666 | IPC_CREAT);

    struct message msg;
    msgrcv(msgid, &msg, sizeof(msg), 1, 0);

    printf("Received message: %s", msg.text);
    msgctl(msgid, IPC_RMID, NULL);
    return 0;
}


---

### *C. UDP Client and Server for Sentence Reversal*

#### *Server Program*
c
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>

int main() {
    int sockfd;
    struct sockaddr_in server, client;
    char buffer[100];
    socklen_t len = sizeof(client);

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    server.sin_family = AF_INET;
    server.sin_port = htons(8080);
    server.sin_addr.s_addr = INADDR_ANY;

    bind(sockfd, (struct sockaddr *)&server, sizeof(server));
    printf("Server ready.\n");

    recvfrom(sockfd, buffer, 100, 0, (struct sockaddr *)&client, &len);
    strrev(buffer);  // Reverse the string
    sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)&client, len);

    close(sockfd);
    return 0;
}


#### *Client Program*
c
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>

int main() {
    int sockfd;
    struct sockaddr_in server;
    char buffer[100];

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    server.sin_family = AF_INET;
    server.sin_port = htons(8080);
    server.sin_addr.s_addr = INADDR_ANY;

    printf("Enter a sentence: ");
    fgets(buffer, 100, stdin);

    sendto(sockfd, buffer, strlen(buffer), 0, (struct sockaddr *)&server, sizeof(server));
    recvfrom(sockfd, buffer, 100, 0, NULL, NULL);

    printf("Reversed sentence: %s", buffer);
    close(sockfd);
    return 0;
}


---

### *D. TCP Client and Server for File Transfer*

#### *Server Program*
c
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>
#include <unistd.h>

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    char buffer[1024] = {0};

    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    address.sin_family = AF_INET;
    address.sin_port = htons(8080);
    address.sin_addr.s_addr = INADDR_ANY;

    bind(server_fd, (struct sockaddr *)&address, sizeof(address));
    listen(server_fd, 3);

    new_socket = accept(server_fd, NULL, NULL);
    read(new_socket, buffer, 1024);

    FILE *file = fopen("received_file.txt", "w");
    fprintf(file, "%s", buffer);
    fclose(file);

    printf("File received and saved.\n");
    close(new_socket);
    return 0;
}


#### *Client Program*
c
#include <stdio.h>
#include <string.h>
#include <arpa/inet.h>

int main() {
    int sockfd;
    struct sockaddr_in server;
    char buffer[1024];

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    server.sin_family = AF_INET;
    server.sin_port = htons(8080);
    server.sin_addr.s_addr = INADDR_ANY;

    connect(sockfd, (struct sockaddr *)&server, sizeof(server));

    printf("Enter file content: ");
    fgets(buffer, 1024, stdin);

    send(sockfd, buffer, strlen(buffer), 0);
    printf("File sent.\n");
    close(sockfd);
    return 0;
}


---

These versions are simplified and should be easy to implement and understand. Let me know if you have any questions!
