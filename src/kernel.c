#include "kernel.h"

#include <stdint.h>
#include <stddef.h> 


uint16_t* video_mem = 0;
uint16_t term_row = 0;
uint16_t term_col = 0;

uint16_t Term_Make_Char(char c, char color)
{
    return (color << 8) | c;
}

void Term_Put_Char(int x, int y, char c, char color)
{
    video_mem[(y * VGA_WIDTH) + x] = Term_Make_Char(c, color);
}

void Term_Write_Char(char c, char color)
{
    if (c == '\n')
    {
        term_row++;
        term_col =0;
        return;
    }

    Term_Put_Char(term_col, term_row, c, color);
    term_col++;

    if (term_col >= VGA_WIDTH)
    {
        term_col = 0;
        term_row ++;
    }
}

void Term_Initialize()
{
    video_mem = (uint16_t*)(0xB8000);
    for (int y = 0; y < VGA_HEIGHT; y++)
    {
        for (int x = 0; x < VGA_WIDTH; x++)
        {
            Term_Put_Char(x, y, ' ',  0);
        }
    }
}

size_t strlen(const char * str)
{
    size_t len = 0;
    while(str[len])
    {
        len++;
    }

    return len;
}

void print(const char * str)
{
    size_t len = strlen(str);

    for (int i = 0; i < len; i++)
    {
        Term_Write_Char(str[i], 15);
    }
}



void kernel_start()
{
    // 0xB8000

    Term_Initialize();

    print("hello, world!\ntest");

    while(1)
    {
        print("help!");
    }

}
