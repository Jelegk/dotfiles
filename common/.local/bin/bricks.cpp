// from https://en.cppreference.com/w/cpp/string/basic_string_view

#include <iostream>
#include <string_view>
 
#define WIDTH  30
#define HEIGHT 10

int main()
{
    #define A "▀"
    #define B "▄"
    #define C "─"
 
    constexpr std::string_view blocks[]{A B C, B A C, A C B, B C A};
 
    for (int y{}, p{}; y != HEIGHT; ++y, p = ((p + 1) % 4))
    {
        for (char x{}; x != WIDTH; ++x)
            std::cout << blocks[p];
        std::cout << '\n';
    }
}
