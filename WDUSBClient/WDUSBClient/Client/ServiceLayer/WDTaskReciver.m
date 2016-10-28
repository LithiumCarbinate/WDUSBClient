//
//  WDTaskReciver.m
//  socketDemo
//
//  Created by sixleaves on 16/10/28.
//  Copyright © 2016年 sixleaves. All rights reserved.
//

#import "WDTaskReciver.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface WDTaskReciver ()

@property (nonatomic, assign) int serverSocket;
@property (nonatomic, strong) NSMutableArray *tasks;

@end

@implementation WDTaskReciver

#pragma mark - Public Method

- (void)reciveDataAtLocalhostOnPort:(__uint16_t)port {
    [self _startReciveDataFromHost:@"127.0.0.1" onPort: port];
}

- (NSMutableArray *)getTasks {
    return self.tasks;
}

- (NSInteger)currentTasksSize {
    return self.tasks.count;
}

- (void)removeAllTask {
    [self.tasks removeAllObjects];
}

- (void)_startReciveDataFromHost:(NSString *)host onPort:(__uint16_t)port {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        struct sockaddr_in server_addr;
        server_addr.sin_len = sizeof(struct sockaddr_in);
        server_addr.sin_family = AF_INET;
        server_addr.sin_port = htons(port);
        server_addr.sin_addr.s_addr = inet_addr(host.UTF8String);
        bzero(&(server_addr.sin_zero),8);
        
        //创建socket TCP协议
        int server_socket = socket(AF_INET, SOCK_STREAM, 0);
        if (server_socket == -1) {
            perror("socket error");
            exit(-1);
        }
        
        //绑定socket：将创建的socket绑定到本地的IP地址和端口，此socket是半相关的，只是负责侦听客户端的连接请求，并不能用于和客户端通信
        int bind_result = bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr));
        if (bind_result == -1) {
            perror("bind error");
            exit(-1);
        }
        
        //listen侦听 第一个参数是套接字，第二个参数为等待接受的连接的队列的大小，在connect请求过来的时候,完成三次握手后先将连接放到这个队列中，直到被accept处理。如果这个队列满了，且有新的连接的时候，对方可能会收到出错信息。
        if (listen(server_socket, 5) == -1) {
            perror("listen error");
            exit(-1);
        }
        
        while (true) {
            struct sockaddr_in client_address;
            socklen_t address_len;
            int client_socket = accept(server_socket, (struct sockaddr *)&client_address, &address_len);
            
            if (client_socket == -1) {
                perror("accept error");
                exit(-1);
            }
            NSString *params = [self _getBodyWithSocket: client_socket];
            [self.tasks addObject: params];
        }
    });
}


#pragma mark - Private Method
/*
 return -1 that read header size have some error
 return other that body size will recive;
 */
- (NSInteger)_getBodySizeWithSocket:(int)clientSocket {
    
    size_t header_byte_rec_num = 0;
    size_t header_byte_size = 4;
    
    char recv_msg_header[header_byte_size + 1];
    NSMutableData *headerData =[NSMutableData data];
    
    bzero(recv_msg_header, 4);
    do {
        
        size_t recv_size = recv(clientSocket,
                                recv_msg_header + header_byte_rec_num,
                                header_byte_size - header_byte_rec_num,
                                0);
        
        if (recv_size == 0) break;
        
        header_byte_rec_num += recv_size;
        
    }while(header_byte_rec_num != header_byte_size);
    
    if (header_byte_rec_num != header_byte_size) return -1;
    
    recv_msg_header[header_byte_rec_num] = '\0';
    
    [headerData appendBytes:recv_msg_header length: header_byte_rec_num];
    
    NSString *size = [[NSString alloc] initWithData: headerData encoding:NSUTF8StringEncoding];
    
    NSLog(@"header info size = %@", size);
    
    return size.integerValue;
}

- (NSString *)_getBodyWithSocket:(int)clientSocket {
    
    // get body size
    NSInteger bodySize = [self _getBodySizeWithSocket: clientSocket];
    
    // init rec body size
    ssize_t body_rec_size = 0;
    
    char recv_msg[bodySize + 1];
    char reply_msg[1024];
    NSMutableData *bodyData = [NSMutableData data];
    
    if (bodySize == -1 || bodySize == 0) {
        
        [self _sendErrorWithSocket:clientSocket
                         errorNum:bodySize
                     andErrorInfo:@"header size is empty or parse header error"];
        
        return nil;
    }
    
    bzero(recv_msg, bodySize + 1);
    bzero(reply_msg, 1024);
    while (body_rec_size != bodySize) {
        
        ssize_t rec_size = recv(clientSocket,
                                recv_msg + body_rec_size,
                                bodySize - body_rec_size,
                                0);
        
        if (rec_size == 0) break;
        
        body_rec_size += rec_size;
    }
    
    if (body_rec_size != bodySize) {
        
        [self _sendErrorWithSocket:clientSocket
                         errorNum:-2
                     andErrorInfo:@"rec_size not equal to body_size"];
        
        return nil;
    }
    
    recv_msg[body_rec_size] = '\0';
    [bodyData appendBytes:recv_msg length: body_rec_size];
    
    NSString *revMsg = [[NSString alloc] initWithData: bodyData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", revMsg);
    
    return revMsg;
}


- (void)_sendErrorWithSocket:(int)clientSocket
                   errorNum:(ssize_t)errorNum
               andErrorInfo:(NSString *)errorInfo{
    
    NSString *error = [NSString stringWithFormat:@"Error code: %ld, ErrorInfo: %@", errorNum, errorInfo];
    
    const char *cError = error.UTF8String;
    
    send(clientSocket, cError, strlen(cError), 0);
}

#pragma mark - Lazy method
- (NSMutableArray *)tasks {
    if (_tasks == nil) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}


@end
