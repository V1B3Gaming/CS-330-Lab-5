#include <stdio.h>

int main(void){
    //start to square the values
    int myarr[5] = {-3, 0, 2, 4, 5};

    //Now square each value in the array
    for (int i = 0; i < 5; i++){
        *(myarr + i) = *(myarr + i) * *(myarr + i);
    }
    //this is where we print the values
    for (int i = 0; i < 5; i++){
        printf("%d ", myarr[i]);
    }
    printf("\n");


    return 0;
}
