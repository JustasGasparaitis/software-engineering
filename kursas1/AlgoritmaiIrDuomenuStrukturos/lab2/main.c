// Išdėstyti šachmatų lentoje 5 karalienes,
// kad kiekvienas langelis būtų kontroliuojamas bent vienos iš jų.

// Standard libraries
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// Chars for a more graphical board
#define QUEEN_CHAR   'Q'
#define EMPTY_CHAR   'X'

// Create an empty board
void createBoard(bool board[8][8]);

// Print board to console as adjacency matrix/graphical board
void printBoard(bool board[8][8], bool asMatrix);

// Place a queen on the board
void placeQueen(bool board[8][8], int row, int col);

// Remove a queen from the board
void removeQueen(bool board[8][8], int row, int col);

// Returns true if square is controlled by a queen, else false
bool isSquareAttacked(bool board[8][8], int row, int col);

// Count the number of queens on the board
int queenCount(bool board[8][8]);

// Solve the problem
bool solve(bool board[8][8]);

// Main function
int main()
{
    // Standard 8x8 chess board
    bool board[8][8];
    createBoard(board);
    //placeQueen(board, 0, 5);
    bool solved = solve(board);
    if (solved)
        printBoard(board, false);
    else
        printf("Unsolved!");
    return 0;
}
void createBoard(bool board[8][8])
{
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            board[i][j] = false;
        }
    }
}
void printBoard(bool board[8][8], bool asMatrix)
{
    printf("Press ENTER to see the board");
    getchar();
    system("clear");
    if (asMatrix)
    {
        for (int i = 0; i < 8; i++)
        {
            for (int j = 0; j < 8; j++)
            {
                printf("%d", board[i][j]);
            }
            printf("\n");
        }
    }
    else
    {
        for (int i = 0; i < 8; i++)
        {
            for (int j = 0; j < 8; j++)
            {
                if (board[i][j]) printf("%c ", QUEEN_CHAR);
                else printf("%c ", EMPTY_CHAR);
            }
            printf("\n");
        }
    }
}
void placeQueen(bool board[8][8], int row, int col)
{
    board[row][col] = true;
}
void removeQueen(bool board[8][8], int row, int col)
{
    board[row][col] = false;
}
bool isSquareAttacked(bool board[8][8], int row, int col)
{
    // Check rows and columns
    for (int i = 0; i < 8; i++)
    {
        if (board[i][col] || board[row][i]) return true;
    }

    // Check diagonals
    for (int i = 0; i < 8; i++)
    {
        if (board[row - i][col - i] &&
            row - i >= 0 &&
            col - i >= 0)
            return true;
        else if (board[row - i][col + i] &&
            row - i >= 0 &&
            col + i < 8)
            return true;
        else if (board[row + i][col - i] &&
            row + i < 8 &&
            col - i >= 0)
            return true;
        else if (board[row + i][col + i] &&
            row + i < 8 &&
            col + i < 8)
            return true;
    }
    return false;
}
int queenCount(bool board[8][8])
{
    int count = 0;
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            if (board[i][j]) count++;
        }
    }
    return count;
}
bool solve(bool board[8][8])
{
    // Base case:
    // if there's no unattacked square with 5 queens, puzzle is solved
    bool hasUnattackedSquare = false;
    int numOfQueens = queenCount(board);
    for (int i = 0; i < 8 && !hasUnattackedSquare; i++)
    {
        for (int j = 0; j < 8 && !hasUnattackedSquare; j++)
        {
            if (!isSquareAttacked(board, i, j)) hasUnattackedSquare = true;
        }
    }

    // If every square is attacked with 5 queens, puzzle is solved
    if (!hasUnattackedSquare && numOfQueens == 5) return true;

    // If there are more than 5 queens, puzzle is not solved
    else if (numOfQueens > 5) return false;

    // Recursive case
    for (int i = 0; i < 8; i++)
    {
        for (int j = 0; j < 8; j++)
        {
            if (!isSquareAttacked(board, i, j))
            {
                placeQueen(board, i, j);
                solve(board);
            }
        }
    }
    return solve(board);
}
