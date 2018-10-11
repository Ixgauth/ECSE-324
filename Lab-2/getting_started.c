#include <stdio.h>
int main() {
		int a[5] = {1, 20, 3, 4, 5};
		int max_val;
		max_val = 0;
		for (unsigned int i = 0; i < 5; i++) {
			if (a[i] > max_val) {
				max_val = a[i];
			}
		}
		printf("Max value = %d\n", max_val);
		return max_val;
}
