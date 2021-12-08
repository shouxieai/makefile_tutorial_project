
srcs := $(shell find src -name "*.cpp")
objs := $(srcs:.cpp=.o)
objs := $(objs:src/%=objs/%)
mks  := $(objs:.o=.mk)

include_paths := lean/curl7.78.0/include \
				 lean/openssl-1.1.1j/include

library_paths := lean/curl7.78.0/lib     \
				 lean/openssl-1.1.1j/lib

# 把library path给拼接为一个字符串，例如a b c => a:b:c
# 然后使得LD_LIBRARY_PATH=a:b:c
empty := 
library_path_export := $(subst $(empty) $(empty),:,$(library_paths))

ld_librarys   := curl ssl crypto

# 把每一个头文件路径前面增加-I，库文件路径前面增加-L，链接选项前面加-l
run_paths     := $(library_paths:%=-Wl,-rpath=%)
include_paths := $(include_paths:%=-I%)
library_paths := $(library_paths:%=-L%)
ld_librarys   := $(ld_librarys:%=-l%)

compile_flags := -std=c++11 -w -g -O0 $(include_paths)
link_flags := $(library_paths) $(ld_librarys) $(run_paths)

# 所有的头文件依赖产生的makefile文件，进行include
# -include表示如果有异常请不要打印出来
# 这里判断，如果是clean指令，则不需要生成mk文件
ifneq ($(MAKECMDGOALS), clean)
-include $(mks)
endif

objs/%.o : src/%.cpp
	@echo 编译$<，生成$@，目录是：$(dir $@)
	@mkdir -p $(dir $@)
	@g++ -c $< -o $@ $(compile_flags)

workspace/pro : $(objs)
	@echo 链接$@
	@g++ $^ -o $@ $(link_flags)

objs/%.mk : src/%.cpp
	@echo 生成依赖$@
	@mkdir -p $(dir $@)
	@g++ -MM $< -MF $@ -MT $(@:.mk=.o) $(compile_flags)

pro : workspace/pro
	@echo 编译完成

run : pro
	@cd workspace && ./pro

clean :
	@rm -rf workspace/pro objs

.PHONY : pro run debug clean

export LD_LIBRARY_PATH:=$(LD_LIBRARY_PATH):$(library_path_export)