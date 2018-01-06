//
//  PrintMethod.h
//  jianke
//
//  Created by xiaomk on 16/5/25.
//  Copyright © 2016年 xianshijian. All rights reserved.
//

#ifndef PrintMethod_h
#define PrintMethod_h

#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

//编译方法，
//gcc file.c -o file
//运行方法
//./file
//然后就会输出你工程里的类名方法名，就可以把这里组装成一个需要混淆的配置文件了。
//缺限
//1.输出名字没有做重复处理。
//2.判断方法时只是处理了两种情况，如果空格多于2个没有处理。

#if 0//放开调试
#define Printf_info(x,y) printf(x,y);
#else
#define Printf_info(x,y)
#endif

int Mydir(const char *filepath);
int checkFile(const char *filepath);

int findNum = 0;

int main(int argc, char *argv[]){
    //此代码的功能是遍历ios的项目的所有。h和。m的文件，把里面的类名，方法名，参数名等都提取出来，
    Mydir("/Users/xiaomk/work/jiankejianzhi_dev/jianke/Base/");//填写自己的工程的根目录路径。
    
    return 0;
}

void Print_fileName(const char * filename){
    unsigned long a = strlen(filename);
    for(int i = 0; i < a - 2; i++){
        printf("%c",filename[i]);
    }
    printf("\n");
}

int Mydir(const char *filepath){
    char *fullpath,*filetype,*tmp;
    struct stat statbuf;
    DIR *dr;
    struct dirent *drt;
    
    if((dr=opendir(filepath))==NULL)
        return 2;
    
    while((drt=readdir(dr))!=NULL){
        
        if(strcmp(drt->d_name,".")==0||strcmp(drt->d_name,"..")==0||strcmp(drt->d_name,".DS_Store")==0)
            continue;
        
        fullpath=strdup(filepath);
        fullpath=strcat(fullpath,"/");
        fullpath=strcat(fullpath,drt->d_name);
        
        Printf_info("%s\n",fullpath);
        
        if(stat(fullpath,&statbuf)<0)
            continue;
        
        if (S_ISREG(statbuf.st_mode)){
            filetype = "reguler";
            unsigned long a = strlen(drt->d_name);
            char *pp = drt->d_name;
            //printf("----  %c %c" , pp[a - 2], pp[a - 1]);
            
            if(pp[a - 2] == '.' && pp[a - 1] == 'm')
            {
                Print_fileName(drt->d_name);
                checkFile(fullpath);
            }
#if 0
            else if(pp[a - 2] == '.' && pp[a - 1] == 'h'){
                
                char *mPath = strdup(fullpath);
                //printf("\nmpath: %s\n",mPath);
                char *ppp = mPath;//drt->d_name;
                int a = strlen(ppp);
                ppp[a - 1] = 'm';//检查m文件是否存在。
                //printf("\nmpath: %s\n",mPath);
                if((access(mPath,F_OK))==0){
                    continue;
                }
                Print_fileName(drt->d_name);
                checkFile(fullpath);
            }
#endif
        }
        else if(S_ISDIR(statbuf.st_mode)){
            filetype="directory";
            //fullpath=strcat(fullpath,"/");
            //printf("%s,%s\n",fullpath,filetype);
            tmp=strdup(fullpath);
            Mydir(tmp);
        }else{
            filetype="invalid";
            printf("%s,%s\n",fullpath,filetype);
        }
        //printf("%s,%s\n",fullpath,filetype);
        bzero(fullpath,strlen(fullpath));
    }
    return 0;
}
int print_Method(char *text){
    char *p = text;
    char c;
    int start = 0;
    while((c = *p++) !='\n'){//Method
        if(c == ':' || c == '{' || c == ';'){
            start = 0;
            break;
        }
        if(start == 1){
            printf("%c", c);
        }
        if(c == ')')
            start = 1;
    }
    printf("\n");
#if 0
    start = 0;
    while((c = *p++) !='\n'){//arge
        if(c == ':'){
            start = 0;
            printf("\n");
        }
        if(start == 2 && c != '{'){
            printf("%c", c);
        }
        if(c == ' ' && start == 1)
            start = 2;
        if(c == ')')
            start = 1;
    }
    //printf("\n");
#endif
    return 0;
}

int findMethod(char *text){
    char *p = text;
    char c;
    while((c = *p++) !='\n'){
        if(c == '-' && ((*p == ' ' && *(p + 1) == '(') || *p == '(' )){
            if( text[0] == '-' ){
                //printf("%d %s\n", findNum++, text);
                print_Method(text);
            }
            //else
            //  printf("%d %s\n", findNum++, text);
        }
        if(c == '+' && ((*p == ' ' && *(p + 1) == '(') || *p == '(' )){
            if( text[0] == '+' ){
                //printf("%d %s\n", findNum++, text);
                print_Method(text);
            }
            //else
            //  printf("%d %s\n", findNum++, text);
        }
    }
    return 0;
}

int checkFile(const char *filepath){
    //printf("＝＝＝＝%s\n", filepath);
    
    FILE *fp1;//定义文件流指针，用于打开读取的文件
    char text[40961];//定义一个字符串数组，用于存储读取的字符
    fp1 = fopen(filepath,"r");//只读方式打开文件a.txt
    while(fgets(text,40960,fp1)!=NULL)//逐行读取fp1所指向文件中的内容到text中
    {
        //puts(text);//输出到屏幕
        findMethod(text);
    }
    fclose(fp1);//关闭文件a.txt，有打开就要有关闭
    
    return 0;
}


#endif /* PrintMethod_h */
