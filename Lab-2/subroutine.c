#include <stdio.h>
extern int MAX_2(int x, int y);

int main(){
		int a[5] = {1, 20, 3, 4, 5};
		int max_val;
		max_val = 0;
		int max_two;
		for (unsigned int i = 0; i < 4; i++) {
			max_two = MAX_2(a[i], a[i+1]);
			if (max_two > max_val) {
				max_val = max_two;
			}
		}
		printf("Max value = %d\n", max_val);
		return max_val;
}
