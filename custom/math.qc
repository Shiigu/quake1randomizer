float sqrt(float x);
float fpow(float x, float y);
float fmax(float a, float b);
float fmin(float a, float b);
float mod(float a, float b);
float rand();

/*
* sqrt
*
* QuakeC lacks a sqrt function unlike C.
* This function provides a good enough approximation of the square root of a number.
* Copied from https://stackoverflow.com/a/17247614
* 
*/

float sqrt(float x) =
{
    float rt = 1, ort = 0;
    while(ort!=rt)
    {
        ort = rt;
        rt = ((x/rt) + rt) / 2;
    }
    return rt;
};

/*
* pow
*
* QuakeC lacks a pow function unlike C.
* This function provides a simplified work for an exponential function.
* 
*/

float fpow(float x, float y) =
{
    if(x == 0 && y != 0) return 0;
    if(x != 0 && y == 0) return 1;
    if(x == 0 && y == 0) error("0^0 is undefined\n");
    local float i, pow;
    pow = 1;
    for(i = 0; i < y; i++)
    {
        pow = pow * x;
    }
    return pow;
};

/*
* max
*
* QuakeC lacks a max function unlike C.
* This function provides which of the two numbers is higher.
* If they are equal, it returns the first number.
* 
*/

float fmax(float a, float b) = {
    if(a >= b)
        return a;
    return b;
};

/*
* min
*
* QuakeC lacks a max function unlike C.
* This function provides which of the two numbers is lower.
* If they are equal, it returns the first number.
* 
*/

float fmin(float a, float b) = {
    if(a <= b)
        return a;
    return b;
};

/*
* mod
*
* QuakeC lacks a modulo operator unlike C.
* This function provides the reminder of the division between a and b.
* (In other words, it returns a % b)
* 
*/

float mod(float a, float b) = {
    return a - (floor(a/b) * b);
};

/*
*
* POSIX-like linear congruent random number generation.
* Provides the ability to use a specific seed.
* 
*/

float seed, next, seedIsFixed;

float rand() = {
    float a = 11;
    float c = 10653;
    float m = 1000000;
    if(next == 0) next = seed;
    next = floor((next * a + c) % m);
    return (next / m);
};