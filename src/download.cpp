
#include "download.hpp"

#include <string>
#include <curl/curl.h>

using namespace std;

// 这个回调函数，是为了让curl获取到数据后，写入的管道。我们通过string的append函数
// 写入到string对象中。string可以储存二进制也可以储存字符串
size_t write_data(const void* buffer, size_t count, size_t size, void* user_data){
    string* stream = static_cast<string*>(user_data);
    const char* pbytes = static_cast<const char*>(buffer);
    stream->append(pbytes, count * size);
    return count * size;
}

string download(const string& url){

    CURL *curl = curl_easy_init();  
    string response;

    curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, &write_data);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response);
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0L);
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 1);

    CURLcode code = curl_easy_perform(curl);
    if(code != CURLE_OK){
        printf("Has error: code = %d, message: %s\n", code, curl_easy_strerror(code));
    }
    curl_easy_cleanup(curl);
    return response;
}