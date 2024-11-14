#include <stdio.h>
#include <math.h>

#define SCALE 5000;

int main() {
    int sticks;
    int result = scanf("%d", &sticks);
    if (result != 1) {
        return -1;
    }

    int locs[sticks][2];
    int loc1, loc2;
    for (int i = 0; i < sticks; i++) {
        result = scanf("%d %d", &loc1, &loc2);

        if (result != 2) {
            return -1;
        }

        locs[i][0] = loc1;
        locs[i][1] = loc2;
    }

    double len = 0;

    for (int i = 1; i < sticks; i++) {
        len += sqrt(pow(locs[i][0] - locs[i-1][0], 2) + pow(locs[i][1] - locs[i-1][1], 2));
    }
    len += sqrt(pow(locs[0][0] - locs[sticks-1][0], 2) + pow(locs[0][1] - locs[sticks-1][1], 2));

    len *= SCALE;
    int res = ceil(len/1000);

    printf("%d\n", res);
}

