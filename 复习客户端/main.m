//
//  main.m
//  复习客户端
//
//  Created by DC017 on 16/9/5.
//  Copyright © 2016年 宋玉涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <pthread.h>
int acceptFd;
pthread_t thread[2];
void *thread1()
{
    char buf[1024];
    ssize_t recesize;
    do
    {
        memset(buf, 0, sizeof(buf));
        recesize = recv(acceptFd, buf, sizeof(buf), 0);
        //        scanf("%s",buf);
        //        send(acceptFd, buf, sizeof(buf), 0);
        NSLog(@"从客户端收到的信息：%s",buf);
    }
    while (strcmp(buf, "exit\n") !=0 );
    {
        close(acceptFd);
    }
    
    return  0;
}
void *thread2()
{
    char buf[1024];
    //    ssize_t recesize;
    do
    {
        memset(buf, 0, sizeof(buf));
        //        recesize = recv(acceptFd, buf, sizeof(buf), 0);
        scanf("%s",buf);
        send(acceptFd, buf, sizeof(buf), 0);
        //        NSLog(@"从客户端收到的信息：%s",buf);
    }
    while (strcmp(buf, "exit\n") !=0 );
    {
        close(acceptFd);
    }
    
    return 0;
}
int main(int argc, const char * argv[])

{
    @autoreleasepool
    {
    //定义一个套接字
    int fd = socket(AF_INET, SOCK_STREAM, 0);
    //定义一个结构体
    struct sockaddr_in addr;
    //初始化
    memset(&addr, 0, sizeof(addr));
    //设置属性值
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_len = sizeof(addr);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(1024);
    //绑定
    int err = bind(fd, (const struct sockaddr *)&addr, sizeof(addr));//err==0时，绑定成功
    //监听
    err = listen(fd, 5);
    if(err == 0)
    {
        NSLog(@"监听成功");
    }
    //进行阻塞
    while (true)
    {
        NSLog(@"等待客户端输入：");
        //客户端结构体
        struct sockaddr_in clientAddr;
        socklen_t addLen;
        addLen = sizeof(clientAddr);
        acceptFd = accept(fd,(struct sockaddr *)&clientAddr,&addLen);
        NSLog(@"地址是：%s终端号是：%d",inet_ntoa(clientAddr.sin_addr),ntohs(clientAddr.sin_port));
        NSLog(@"acceptFd:%i",acceptFd);
        if(acceptFd != -1)
        {
//            char buf[1024];
//            ssize_t recesize;
//            do
//            {
//                memset(buf, 0, sizeof(buf));
//                recesize = recv(acceptFd, buf, sizeof(buf), 0);
//                scanf("%s",buf);
//                send(acceptFd, buf, sizeof(buf), 0);
//                NSLog(@"从客户端收到的信息：%s",buf);
//            }
//            while (strcmp(buf, "exit\n") !=0 );
//            {
//                close(acceptFd);
//            }
            pthread_create(&thread[0],NULL,thread1,NULL);
            pthread_create(&thread[1], NULL, thread2, NULL);
            
            pthread_join(thread[0], NULL);
            pthread_join(thread[1], NULL);
            
          }
        }
    }
    return 0;
}
