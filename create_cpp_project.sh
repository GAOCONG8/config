#!/bin/bash

# 设置默认项目名称
DEFAULT_PROJECT_NAME="my_cpp_project"

# 检查是否提供了项目名称作为参数
if [ $# -eq 0 ]; then
    # 没有提供参数，交互式获取项目名称
    read -p "请输入项目名称 [$DEFAULT_PROJECT_NAME]: " PROJECT_NAME
    PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_PROJECT_NAME}
else
    # 使用命令行参数作为项目名称
    PROJECT_NAME=$1
fi

# 清理项目名称：移除特殊字符，只保留字母、数字和下划线
CLEAN_PROJECT_NAME=$(echo "$PROJECT_NAME" | sed 's/[^a-zA-Z0-9_]/_/g')

# 确保项目名称不以数字开头
if [[ "$CLEAN_PROJECT_NAME" =~ ^[0-9] ]]; then
    CLEAN_PROJECT_NAME="project_$CLEAN_PROJECT_NAME"
fi

# 移除开头和结尾的下划线
CLEAN_PROJECT_NAME=$(echo "$CLEAN_PROJECT_NAME" | sed 's/^_*\|_*$//g')

# 确保项目名称不为空
if [ -z "$CLEAN_PROJECT_NAME" ]; then
    CLEAN_PROJECT_NAME=$DEFAULT_PROJECT_NAME
fi

# 创建命名空间（移除下划线）
PROJECT_NAMESPACE=$(echo "$CLEAN_PROJECT_NAME" | sed 's/_//g')

echo "创建项目: $CLEAN_PROJECT_NAME (命名空间: $PROJECT_NAMESPACE)"

# 创建项目根目录并进入
mkdir -p "$CLEAN_PROJECT_NAME" && cd "$CLEAN_PROJECT_NAME" || exit

# 创建目录结构
echo "创建目录结构..."
mkdir -p cmake
mkdir -p docs
mkdir -p "include/$CLEAN_PROJECT_NAME"
mkdir -p include/base
mkdir -p src/base
mkdir -p tests
mkdir -p 3rd
mkdir -p scripts
mkdir -p config

# 创建基础文件
echo "创建基础文件..."
touch .gitignore
touch .clang-format
touch .clang-tidy
touch CMakeLists.txt
touch README.md
touch LICENSE
touch "include/$CLEAN_PROJECT_NAME/version.h"
touch include/base/Logger.h
touch src/base/Logger.cpp
touch src/main.cpp
touch tests/CMakeLists.txt
touch tests/main_tests.cpp
touch tests/spdlog_tests.cpp
touch scripts/setup.sh
touch scripts/build.sh
touch scripts/run_tests.sh

# 初始化git仓库
echo "初始化 Git 仓库..."
git init

# 创建基础.gitignore文件
cat > .gitignore << EOF
# 构建目录
build/
cmake-build-*/
out/

# 依赖库
vcpkg/
.vcpkg-root

# IDE
.vscode
.clangd
.tags
*.swp
*.swo

# 可执行文件
*.exe
*.out
*.app

# 日志和临时文件
*.log
*.tmp

# macOS
.DS_Store
EOF

# 创建基础CMakeLists.txt
cat > CMakeLists.txt << EOF
cmake_minimum_required(VERSION 3.14)
project($CLEAN_PROJECT_NAME VERSION 1.0.0 LANGUAGES CXX)

# 设置C++标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# 编译选项
set(CMAKE_CXX_FLAGS_DEBUG "\${CMAKE_CXX_FLAGS_DEBUG} -g -O0 -Wall -Wextra")
set(CMAKE_CXX_FLAGS_RELEASE "\${CMAKE_CXX_FLAGS_RELEASE} -O2 -DNDEBUG -march=native")


# 项目选项
option(BUILD_TESTS "Build tests" ON)
option(BUILD_EXAMPLES "Build examples" OFF)
option(BUILD_BENCHMARKS "Build benchmarks" OFF)
option(ENABLE_COVERAGE "Enable coverage reporting" OFF)

# 包含3rd目录
include_directories(
)

link_directories(
)

# 包含目录
include_directories(include)

# 添加主库
add_library(\${PROJECT_NAME} 
    src/base/Logger.cpp
    src/main.cpp
)
target_include_directories(\${PROJECT_NAME} PUBLIC
    \$<BUILD_INTERFACE:\${PROJECT_SOURCE_DIR}/include>
    \$<INSTALL_INTERFACE:include>
)

# 导出目标
install(TARGETS \${PROJECT_NAME}
    EXPORT \${PROJECT_NAME}-targets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    INCLUDES DESTINATION include
)

# 测试
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# CPack 配置
include(InstallRequiredSystemLibraries)
set(CPACK_PACKAGE_VERSION \${PROJECT_VERSION})
set(CPACK_GENERATOR "TGZ;ZIP")
include(CPack)
EOF

# 创建基础.clang-format
cat > .clang-format << EOF
BasedOnStyle: Google
UseTab: Never
IndentWidth: 4
TabWidth: 4
BreakBeforeBraces: Attach
AllowShortIfStatementsOnASingleLine: false
IndentCaseLabels: false
ColumnLimit: 80
AccessModifierOffset: -4 
NamespaceIndentation: All
EOF

# 创建基础README.md
cat > README.md << EOF
# ${CLEAN_PROJECT_NAME^}

## 概述
这是一个现代C++项目的模板，使用CMake构建系统，支持跨平台开发。

## 先决条件
- CMake 3.14+
- C++17兼容的编译器 (GCC 7+, Clang 5+, MSVC 2019+)
- (可选) vcpkg 用于依赖管理

## 构建说明

### 使用CMake构建
\`\`\`bash
mkdir build
cd build
cmake ..
make
\`\`\`

### 使用vcpkg管理依赖
\`\`\`bash
git clone https://github.com/microsoft/vcpkg.git
./vcpkg/bootstrap-vcpkg.sh
cmake -B build -DCMAKE_TOOLCHAIN_FILE=./vcpkg/scripts/buildsystems/vcpkg.cmake
cmake --build build
\`\`\`

## 运行测试
\`\`\`bash
cd build
ctest
\`\`\`

## 项目结构
- \`include/\`: 公共头文件
  - \`include/base/\`: 基础组件头文件
  - \`include/\${PROJECT_NAME}/\`: 项目特定头文件
- \`src/\`: 源代码
  - \`src/base/\`: 基础组件实现
- \`tests/\`: 测试代码
- \`cmake/\`: CMake模块

## 贡献
请阅读[CONTRIBUTING.md](CONTRIBUTING.md)了解贡献流程。

## 许可证
本项目采用[MIT许可证](LICENSE)。
EOF

# 创建版本头文件
cat > "include/$CLEAN_PROJECT_NAME/version.h" << EOF
#pragma once

#define ${PROJECT_NAMESPACE^^}_VERSION_MAJOR 1
#define ${PROJECT_NAMESPACE^^}_VERSION_MINOR 0
#define ${PROJECT_NAMESPACE^^}_VERSION_PATCH 0

#define ${PROJECT_NAMESPACE^^}_VERSION_STRING "1.0.0"
EOF

# 创建Logger头文件
cat > include/base/Logger.h << EOF
#ifndef MY_LOGGER_H
#define MY_LOGGER_H

#include <spdlog/spdlog.h>
#include <memory>
#include <string>
#include <iostream>

class Loggers {
public:
    static std::shared_ptr<spdlog::logger> defaultLogger();

    static void init(const std::string& log_dir = ".",
                     const std::string& default_prefix = "Logger",
                     size_t max_size     = 10 * 1024 * 1024,
                     size_t max_files    = 10,
                     spdlog::level::level_enum console_level = spdlog::level::debug,
                     spdlog::level::level_enum file_level    = spdlog::level::debug);

    // ---------------- 自定义 logger ----------------
    static std::shared_ptr<spdlog::logger>
    create(const std::string& logger_name,
           const std::string& file_prefix);

    // 获取任意 logger（不存在返回 nullptr）
    static std::shared_ptr<spdlog::logger> get(const std::string& logger_name);

private:
    // 存储全局日志配置
    static std::string log_dir_;
    static std::string default_prefix_;
    static size_t max_size_;
    static size_t max_files_;
    static spdlog::level::level_enum console_level_;
    static spdlog::level::level_enum file_level_;

    // 友元函数，允许访问私有成员
    friend void ensureDefault();
};

// 默认 logger 宏
#define LOG_TRACE(...)    Loggers::defaultLogger()->trace(__VA_ARGS__)
#define LOG_DEBUG(...)    Loggers::defaultLogger()->debug(__VA_ARGS__)
#define LOG_INFO(...)     Loggers::defaultLogger()->info(__VA_ARGS__)
#define LOG_WARN(...)     Loggers::defaultLogger()->warn(__VA_ARGS__)
#define LOG_ERROR(...)    Loggers::defaultLogger()->error(__VA_ARGS__)
#define LOG_CRITICAL(...) Loggers::defaultLogger()->critical(__VA_ARGS__)

#endif
EOF

# 创建Logger实现文件
cat > src/base/Logger.cpp << EOF
#include "base/Logger.h"

#include <mutex>
#include <chrono>
#include <iomanip>
#include <sstream>

#include "spdlog/sinks/basic_file_sink.h"
#include "spdlog/sinks/daily_file_sink.h"
#include "spdlog/sinks/rotating_file_sink.h"
#include "spdlog/sinks/stdout_color_sinks.h"
#include "spdlog/sinks/stdout_sinks.h"

namespace {
    std::shared_ptr<spdlog::logger> g_default;
    std::once_flag g_once;
    std::mutex g_mutex;  // 保护自定义 logger 创建

    // 生成带时间戳的文件名
    std::string generateTimestampedFilename(const std::string& dir, const std::string& prefix) {
        auto now = std::chrono::system_clock::now();
        auto in_time_t = std::chrono::system_clock::to_time_t(now);
        std::stringstream ss;
        ss << dir << "/" << prefix << "_";
        ss << std::put_time(std::localtime(&in_time_t), "%Y%m%d%H%M%S") << ".log";
        return ss.str();
    }
}  // namespace

// 初始化静态成员变量
std::string Loggers::log_dir_ = ".";
std::string Loggers::default_prefix_ = "Logger";
size_t Loggers::max_size_ = 10 * 1024 * 1024;
size_t Loggers::max_files_ = 10;
spdlog::level::level_enum Loggers::console_level_ = spdlog::level::debug;
spdlog::level::level_enum Loggers::file_level_ = spdlog::level::debug;

// 格式说明：
// %Y-%m-%d %H:%M:%S - 日期时间
// %t - 线程ID
// %n - logger名称
// %l - 日志级别
// %v - 实际日志消息
// ---------- 默认 logger ----------
void ensureDefault() {
    std::call_once(g_once, [] {
        auto console = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
        std::string filename = generateTimestampedFilename(Loggers::log_dir_, Loggers::default_prefix_);
        auto file = std::make_shared<spdlog::sinks::rotating_file_sink_mt>(
            filename, Loggers::max_size_, Loggers::max_files_, false);
        console->set_level(Loggers::console_level_);

        file->set_level(Loggers::file_level_);

        g_default = std::make_shared<spdlog::logger>(
            Loggers::default_prefix_, spdlog::sinks_init_list{console, file});
        g_default->set_level(spdlog::level::debug);
        g_default->flush_on(spdlog::level::debug);
        g_default->set_pattern("[%Y-%m-%d %H:%M:%S.%e] [%t] [%^%l%$] %v");
        spdlog::register_logger(g_default);
    });
}

std::shared_ptr<spdlog::logger> Loggers::defaultLogger() {
    ensureDefault();
    return g_default;
}

// ---------- 创建 / 获取任意 logger ----------
std::shared_ptr<spdlog::logger> Loggers::create(
    const std::string& logger_name, const std::string& file_prefix) {
    std::lock_guard<std::mutex> lk(g_mutex);

    // 已存在直接返回
    if (auto l = spdlog::get(logger_name))
        return l;

    auto console = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
    console->set_level(console_level_);

    std::string filename = generateTimestampedFilename(log_dir_, file_prefix);
    auto file = std::make_shared<spdlog::sinks::rotating_file_sink_mt>(
        filename, max_size_, max_files_, false);
    file->set_level(file_level_);

    auto logger = std::make_shared<spdlog::logger>(
        logger_name, spdlog::sinks_init_list{console, file});
    logger->set_level(spdlog::level::debug);
    logger->flush_on(spdlog::level::debug);
    logger->set_pattern("[%Y-%m-%d %H:%M:%S.%e] [%t] [%^%l%$] %v");
    spdlog::register_logger(logger);
    return logger;
}

std::shared_ptr<spdlog::logger> Loggers::get(const std::string& logger_name) {
    return spdlog::get(logger_name);  // 不存在返回 nullptr
}

// 初始化日志配置
void Loggers::init(const std::string& log_dir,
                   const std::string& default_prefix,
                   size_t max_size,
                   size_t max_files,
                   spdlog::level::level_enum console_level,
                   spdlog::level::level_enum file_level) {
    log_dir_ = log_dir;
    default_prefix_ = default_prefix;
    max_size_ = max_size;
    max_files_ = max_files;
    console_level_ = console_level;
    file_level_ = file_level;
}
EOF

# 创建示例源文件
cat > src/main.cpp << EOF
#include <iostream>
#include "${CLEAN_PROJECT_NAME}/version.h"

namespace $PROJECT_NAMESPACE {

void say_hello() {
    std::cout << "Hello from $CLEAN_PROJECT_NAME v" 
              << ${PROJECT_NAMESPACE^^}_VERSION_STRING << std::endl;
}

} // namespace $PROJECT_NAMESPACE
EOF

# 创建测试CMakeLists.txt
cat > tests/CMakeLists.txt << EOF
find_package(spdlog REQUIRED)
find_package(GTest REQUIRED)

aux_source_directory(. TEST_SRC_LIST)
foreach(TEST_SRC \${TEST_SRC_LIST})
    STRING(REGEX REPLACE "^\\\\./|\\\\.c[a-zA-Z0-9_]*\$" "" TEST_EXE_NAME \${TEST_SRC})
    message(STATUS "添加测试程序:\${TEST_EXE_NAME}")
    add_executable(\${TEST_EXE_NAME} \${TEST_SRC})
    target_link_libraries(
      \${TEST_EXE_NAME}
      \${PROJECT_NAME}
      GTest::gtest          
      GTest::gtest_main
      spdlog::spdlog
    )
    add_test(NAME \${TEST_EXE_NAME} COMMAND \${TEST_EXE_NAME})

endforeach(TEST_SRC \${TEST_SRC_LIST})
EOF

# 创建示例测试文件
cat > tests/main_tests.cpp << EOF
#include <gtest/gtest.h>
#include "${CLEAN_PROJECT_NAME}/version.h"

TEST(VersionTest, VersionDefined) {
    EXPECT_GT(${PROJECT_NAMESPACE^^}_VERSION_MAJOR, 0);
    EXPECT_GE(${PROJECT_NAMESPACE^^}_VERSION_MINOR, 0);
    EXPECT_GE(${PROJECT_NAMESPACE^^}_VERSION_PATCH, 0);
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
EOF

# 创建spdlog测试文件
cat > tests/spdlog_tests.cpp << EOF
#include "base/Logger.h"

int main() {
    // 初始化 logger
    Loggers::init("./logs", "Test");

    // 1) 默认 logger 直接宏
    LOG_INFO("hello from default");
    LOG_DEBUG("hello from debug");

    // 2) 创建新 logger
    auto db_logger = Loggers::create("db", "db.log");
    db_logger->info("this is db logger");

    // 3) 获取已创建的 logger
    if (auto net_logger = Loggers::get("db")) {
        net_logger->warn("reuse existing logger");
    }

    return 0;
}
EOF

# 创建有用的脚本
cat > scripts/setup.sh << EOF
#!/bin/bash
# 设置开发环境

echo "安装依赖..."
if [[ "\$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    sudo apt-get install -y build-essential cmake ninja-build git curl zip unzip tar
    sudo apt-get install -y libjsoncpp-dev libspdlog-dev libgtest-dev fmt-dev libfmt-dev
elif [[ "\$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew &> /dev/null; then
        brew install cmake
    else
        echo "请先安装 Homebrew: https://brew.sh/"
        exit 1
    fi
fi

echo "设置完成!"
EOF

cat > scripts/build.sh << EOF
#!/bin/bash
# 构建项目

BUILD_TYPE=\${1:-Debug}
BUILD_DIR=\${2:-build}

echo "使用构建类型: \$BUILD_TYPE"
echo "构建目录: \$BUILD_DIR"

cmake -B \$BUILD_DIR -DCMAKE_BUILD_TYPE=\$BUILD_TYPE
cmake --build \$BUILD_DIR -j\$(nproc)
EOF

cat > scripts/run_tests.sh << EOF
#!/bin/bash
# 运行测试

BUILD_DIR=\${1:-build}

cd \$BUILD_DIR
ctest --output-on-failure
EOF

# 设置脚本执行权限
chmod +x scripts/*.sh

# 初始提交
git add .
git commit -m "chore: initial project structure"

echo ""
echo "✅ 项目模板创建完成!"
echo ""
echo "项目名称: $CLEAN_PROJECT_NAME"
echo "命名空间: $PROJECT_NAMESPACE"
echo ""
echo "下一步建议:"
echo "1. 根据需要编辑 README.md 和其他配置文件"
echo "2. 运行 ./scripts/setup.sh 安装依赖"
echo "3. 运行 ./scripts/build.sh 编译项目"
echo "4. 运行 ./scripts/run_tests.sh 运行测试"
echo ""
echo "项目目录: $(pwd)"
echo ""
echo "要使用此项目模板，执行以下命令进入项目目录:"
echo "cd $CLEAN_PROJECT_NAME"
EOF