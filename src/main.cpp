#include <stdio.h>
#include <fstream>
#include "download.hpp"

using namespace std;

int main(){
    
    // 下载一个图片文件
    string sxai = download(
        "http://www.zifuture.com:1556/fs/sxai/2021/07/pro-18432c111ca44aa9bba49eab650f466c.jpg"
    );
    
    // 打印他的大小
    printf("sxai.size = %d byte\n", sxai.size());

    // 储存图片数据到sxai.jpg文件
    ofstream of("sxai.jpg", ios::binary|ios::out);
    of.write(sxai.data(), sxai.size());
    of.close();
    return 0;
}