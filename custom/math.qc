float sqrt(float x);
float pow(float x, float y);
float max(float a, float b);
float min(float a, float b);
float mod(float a, float b);

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

float pow(float x, float y) =
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
};

/*
* max
*
* QuakeC lacks a max function unlike C.
* This function provides which of the two numbers is higher.
* If they are equal, it returns the first number.
* 
*/

float max(float a, float b) = {
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

float min(float a, float b) = {
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