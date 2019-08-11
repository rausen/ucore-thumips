#include <ulib.h>
#include <stdio.h>

int get(int index) {
	if (index < 2) {
		return 1;
	}
	return get(index - 1) + get(index - 2);
}

int
main(int argc, int **argv) {
	int i;
	
	i = 0;
	while (i < 20) {
		cprintf("%d\n", get(i));
		i = i + 1;
	}
	return 0;
}