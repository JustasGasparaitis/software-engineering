/*
** pollserver.c -- a cheezy multiperson chat server
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <poll.h>
#include <pthread.h>

#define NAMESIZE 10

char names[NAMESIZE][256]; // Buffer for list of names
int receiverFd;

// Start off with room for 5 connections
// (We'll realloc as necessary)
int fd_count = 0;
int fd_size = 5;
struct pollfd *pfds;

char *serverPort;
char *clientPort;
int listener;     // Listening socket descriptor
int isServerHost = 1;

char remoteIP[INET6_ADDRSTRLEN];

pthread_mutex_t lock;

// Get sockaddr, IPv4 or IPv6:
void *get_in_addr(struct sockaddr *sa) {
    if (sa->sa_family == AF_INET) {
        return &(((struct sockaddr_in *) sa)->sin_addr);
    }

    return &(((struct sockaddr_in6 *) sa)->sin6_addr);
}

// Return a listening socket
int get_listener_socket(char *port, int count) {
    int listener;     // Listening socket descriptor
    int yes = 1;        // For setsockopt() SO_REUSEADDR, below
    int rv;

    struct addrinfo hints, *ai, *p;

    // Get us a socket and bind it
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE;
    if ((rv = getaddrinfo(NULL, port, &hints, &ai)) != 0) {
        fprintf(stderr, "selectserver: %s\n", gai_strerror(rv));
        exit(1);
    }

    for (p = ai; p != NULL; p = p->ai_next) {
        listener = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
        if (listener < 0) {
            continue;
        }

        // Lose the pesky "address already in use" error message
        setsockopt(listener, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int));

        if (bind(listener, p->ai_addr, p->ai_addrlen) < 0) {
            close(listener);
            continue;
        }

        break;
    }

    freeaddrinfo(ai); // All done with this

    // If we got here, it means we didn't get bound
    if (p == NULL) {
        return -1;
    }

    // Listen
    if (listen(listener, count) == -1) {
        return -1;
    }

    return listener;
}

// Return a listening socket
int connect_to_socket(char *port, int count) {
    int listener;     // Listening socket descriptor
    int yes = 1;        // For setsockopt() SO_REUSEADDR, below
    int rv;

    struct addrinfo hints, *ai, *p;

    // Get us a socket and bind it
    memset(&hints, 0, sizeof hints);
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE;
    if ((rv = getaddrinfo(NULL, port, &hints, &ai)) != 0) {
        fprintf(stderr, "selectserver: %s\n", gai_strerror(rv));
        exit(1);
    }

    for (p = ai; p != NULL; p = p->ai_next) {
        listener = socket(p->ai_family, p->ai_socktype, p->ai_protocol);
        if (listener < 0) {
            continue;
        }

        // Lose the pesky "address already in use" error message
        setsockopt(listener, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int));

        if (connect(listener, p->ai_addr, p->ai_addrlen) < 0) {
            close(listener);
            continue;
        }

        break;
    }

    freeaddrinfo(ai); // All done with this

    return listener;
}

// Add a new file descriptor to the set
void add_to_pfds(struct pollfd *pfds[], int newfd, int *fd_count, int *fd_size) {
    // If we don't have room, add more space in the pfds array
    if (*fd_count == *fd_size) {
        *fd_size *= 2; // Double it

        *pfds = realloc(*pfds, sizeof(**pfds) * (*fd_size));
    }

    (*pfds)[*fd_count].fd = newfd;
    (*pfds)[*fd_count].events = POLLIN; // Check ready-to-read

    (*fd_count)++;
}

// Remove an index from the set
void del_from_pfds(struct pollfd pfds[], int i, int *fd_count) {
    // Copy the one from the end over this one
    pfds[i] = pfds[*fd_count - 1];

    (*fd_count)--;
}

void *thread_function(void *vargp) {
    int nbytes;
    char buf[1024];
    for (;;) {
        if ((nbytes = recv(receiverFd, buf, sizeof buf, 0)) == -1) {
            perror("recv");
            exit(0);
        } else if (nbytes == 0) {
            exit(0);
        } else {
            buf[nbytes - 1] = '\0';
            //printf("got a message: %s\n", buf);

            // Parse message for sending
            char str[1024];
            memset(str, 0, 1024);
            char pranesimas[11] = "PRANESIMAS";
            char *name = malloc(sizeof(char) * 1024);
            char *name1 = malloc(sizeof(char) * 1024);
            char *name2 = malloc(sizeof(char) * 1024);
            char *message = malloc(sizeof(char) * 1024);
            char bufCopy[1024];
            strcpy(bufCopy, buf);
            //printf("buf = %s\n", buf);
            name = strtok(bufCopy, " ");
            strcpy(name1, name);
            name = strtok(NULL, " ");
            strcpy(name2, name);
            name = strtok(NULL, " ");
            strcpy(message, name);
            name1 = strtok(name1, ":");
            name2 = strtok(name2, "@");


            //printf("name1 = %s\n", name1);
            //printf("name2 = %s\n", name2);
            //printf("message = %s\n", message);
            strncpy(str, pranesimas, strlen(pranesimas));
            strncat(str, name1, strlen(name1));
            strncat(str, ": @", 4);
            strncat(str, name2, strlen(name2));
            strncat(str, " ", 2);
            strncat(str, message, strlen(message));
            strncat(str, "\r\n", 3);

            for (int k = 0; k < fd_count; k++) {
                if (strcmp(name2, names[k]) == 0) {
                    //printf("comparison! - sending str = %s\n", str);
                    send(pfds[k].fd, str, strlen(str), 0);
                }
            }
        }
    }
}

_Noreturn void *thread_client(void *arg) {
    int fd = *((int *) arg); // get fd from thread argument
    int fdIndex = 0;
    char buf[256];   // Buffer for client data
    char name[256];   // Buffer for a single name
    int nameLength;

    // Find fdIndex
    for (int i = 0; i < fd_count; i++) {
        if (pfds[i].fd == fd) {
            fdIndex = i;
        }
    }

    // This is a new connection, ask for name
    char atsiuskVarda[13] = "ATSIUSKVARDA\n";
    if (send(fd, atsiuskVarda, 13, 0) == -1) {
        perror("send");
    }

    // Wait for the client to send the name
    nameLength = recv(fd, name, sizeof name, 0);

    // Parse and insert the name into name list
    name[nameLength - 1] = '\0';

    pthread_mutex_lock(&lock);
    strcpy(names[fdIndex], name);
    pthread_mutex_unlock(&lock);

    //printf("new user: %s\n", name);

    // Inform client of successful name insertion
    char vardasOk[9] = "VARDASOK\n";
    if (send(fd, vardasOk, 9, 0) == -1) {
        perror("send");
    }

    for (;;) {
        printf("name list: \n");
        for (int i = 0; i < fd_count; i++) {
            printf("%d: %s\n", i, names[i]);
        }

        // Receive data from client
        int nbytes = recv(fd, buf, sizeof buf, 0);

        int sender_fd = fd;
        if (nbytes <= 0) {
            // Got error or connection closed by client
            if (nbytes == 0) {
                // Connection closed
                printf("pollserver: socket %d hung up\n", sender_fd);
            } else {
                perror("recv");
            }
            close(fd); // Bye!
            exit(0);
            //del_from_pfds(pfds, i, &fd_count);
        } else {
            // If it's a targeted message
            if (buf[0] == '@') {
                // Find sender name
                int senderNameIndex;
                for (int k = 0; k < fd_count; k++) {
                    if (pfds[k].fd == sender_fd) {
                        senderNameIndex = k;
                        break;
                    }
                }

                // Send to server
                char temp[1024];
                memset(temp, 0, 1024);
                strncpy(temp, names[senderNameIndex], strlen(names[senderNameIndex]));
                strncat(temp, ": ", 3);
                strncat(temp, buf, strlen(buf));

                //printf("temp = %s\n", temp);

                if (send(receiverFd, temp, sizeof(temp), 0) == -1) {
                    perror("sendToServer");
                }

                // Then separate name and message
                char nameAndMessage[1024];
                strcpy(nameAndMessage, buf);
                char *name;
                char nameWithoutAt[1024];
                int nameWithoutAtLength = 0;
                name = strtok(nameAndMessage, " ");
                for (int i = 0; i <= strlen(nameAndMessage); i++) {
                    if (name[i] != '@') {
                        nameWithoutAt[nameWithoutAtLength] = name[i];
                        nameWithoutAtLength++;
                    }
                }

                // Check if name exists
                int nameExists = 0;
                int target_fd;
                for (int k = 0; k < fd_count; k++) {
                    if (strcmp(nameWithoutAt, names[k]) == 0) {
                        target_fd = pfds[k].fd;
                        nameExists = 1;
                    }
                }
                // If name exists, send targeted message to target
                if (nameExists) {
                    // Find sender name
                    int senderNameIndex;
                    for (int k = 0; k < fd_count; k++) {
                        if (pfds[k].fd == sender_fd) {
                            senderNameIndex = k;
                            break;
                        }
                    }

                    // Send message to target and sender
                    char str[1024];
                    char pranesimas[11] = "PRANESIMAS";
                    memset(str, 0, 1024);
                    strncpy(str, pranesimas, strlen(pranesimas));
                    strncat(str, names[senderNameIndex], strlen(names[senderNameIndex]));
                    strncat(str, ": ", 3);
                    strncat(str, buf, strlen(buf));
                    strncat(str, "\r\n", 3);
                    //printf("Str (len: %lu): : %s\n", strlen(str), str);
                    if (send(target_fd, str, strlen(str), 0) == -1) {
                        perror("send");
                    }
                    if (send(sender_fd, str, strlen(str), 0) == -1) {
                        perror("send");
                    }
                }
                // If name doesn't exist, inform sender
                else {
//                                char str[40] = "PRANESIMASIvestas vardas neegzistuoja.\n";
//                                //printf("Str (len: %lu): : %s\n", strlen(str), str);
//                                if (send(sender_fd, str, strlen(str), 0) == -1) {
//                                    perror("send");
//                                }
                }
            } else {
                for (int j = 0; j < fd_count; j++) {
                    // Send to everyone!
                    int dest_fd = pfds[j].fd;

                    // Else send as regular message
                    if (dest_fd != listener) {

                        // Find sender name
                        int senderNameIndex;
                        for (int k = 0; k < fd_count; k++) {
                            if (pfds[k].fd == sender_fd) {
                                senderNameIndex = k;
                                break;
                            }
                        }

                        // Send message
                        char str[1024];
                        char pranesimas[11] = "PRANESIMAS";
                        memset(str, 0, 1024);
                        strncpy(str, pranesimas, strlen(pranesimas));
                        strncat(str, names[senderNameIndex], strlen(names[senderNameIndex]));
                        strncat(str, ": ", 3);
                        strncat(str, buf, strlen(buf));
                        strncat(str, "\r\n", 3);
                        //printf("Str (len: %lu): : %s\n", strlen(str), str);
                        if (send(dest_fd, str, strlen(str), 0) == -1) {
                            perror("send");
                        }
                    }
                }
            }
        }
    }
}

// Main
int main(int argc, char *argv[]) {
    printf("Server started...\n");

    for (int i = 0; i < NAMESIZE; i++) {
        strcpy(names[i], "empty name");
    }

    pfds = malloc(sizeof *pfds * fd_size); // allocate pfds[]

    // Get client and server ports from arguments
    if (argc == 3) {
        serverPort = argv[1];
        clientPort = argv[2];
    } else {
        fprintf(stderr, "usage: ./pollserver server_port client_port\n");
        exit(1);
    }

    // Initialize mutex for sharing names and pfds
    if (pthread_mutex_init(&lock, NULL) != 0) {
        printf("\n mutex init has failed\n");
        return 1;
    }

    // Set up and get a listening socket for clients
    listener = get_listener_socket(clientPort, 10);

    if (listener == -1) {
        fprintf(stderr, "error getting listening socket with port %s\n", clientPort);
        exit(1);
    } else {
        printf("Listening to port %s...\n", clientPort);
    }

    // Add the listener to set
    pfds[0].fd = listener;
    fd_count = 1;

    // Set up and get a listening socket for the server
    int serverFd = get_listener_socket(serverPort, 2);

    // If getting a server socket failed
    if (serverFd == -1) {
        // Try to connect to that socket, it may already be created
        printf("Connecting to existing socket...\n");
        serverFd = connect_to_socket(serverPort, 2);
        isServerHost = 0;
    }
    else {
        // If getting a server socket was successful, we are connected
        printf("Connecting to new socket...\n");
    }

    // If connecting to the socket did not work, print error
    if (serverFd == -1) {
        fprintf(stderr, "error connecting to socket with port %s\n", serverPort);
        exit(1);
    } else {
        // Else we are connected successfully
        printf("Connected to port %s...\n", serverPort);
    }

    // Accept the connection from server
    struct sockaddr_storage acceptAddr;
    socklen_t acceptAddrSize = sizeof acceptAddr;
    if (isServerHost) {
        receiverFd = accept(serverFd, (struct sockaddr *) &acceptAddr, &acceptAddrSize);
    } else {
        receiverFd = serverFd;
    }

    // Create server thread
    pthread_t thread_id1;
    pthread_create(&thread_id1, NULL, thread_function, NULL);

    struct sockaddr_storage remoteaddr;
    socklen_t addrlen;
    int newfd;

    // Main listener loop
    for (;;) {
        // Accept new connection
        int *arg = malloc(sizeof(*arg));
        addrlen = sizeof remoteaddr;
        newfd = accept(listener,
                       (struct sockaddr *) &remoteaddr,
                       &addrlen);
        if (newfd == -1) {
            perror("accept");
        }

        // Add new connection to pfds[]
        add_to_pfds(&pfds, newfd, &fd_count, &fd_size);
        printf("pollserver: new connection from %s on "
               "socket %d\n",
               inet_ntop(remoteaddr.ss_family,
                         get_in_addr((struct sockaddr *) &remoteaddr),
                         remoteIP, INET6_ADDRSTRLEN),
               newfd);

        // Observe client in new thread, pass i in pfds[i] as an argument
        pthread_t thread_id2;
        *arg = newfd;
        pthread_create(&thread_id2, NULL, thread_client, arg);
    }

    pthread_mutex_destroy(&lock);

    return 0;
}