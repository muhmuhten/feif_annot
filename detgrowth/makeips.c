#ifdef _WIN32
#include "err.c"
char *__progname = __FILE__;
#else
#include <err.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

char *slurpfile(size_t *outlen, FILE *fp) {
	char *buf = 0;
	size_t bufsize = 0;

	struct stat st;
	if (fstat(fileno(fp), &st) == 0) {
		buf = realloc(0, st.st_size+1);
		if (buf) {
			*outlen = fread(buf, 1, st.st_size+1, fp);
			if (*outlen <= st.st_size)
				return buf;
			bufsize = st.st_size+1;
		}
	}

	for (;;) {
		bufsize *= 2;
		if (bufsize < 4096)
			bufsize = 4096;

		char *newbuf = realloc(buf, bufsize);
		if (newbuf == 0)
			err(2, "realloc");
		buf = newbuf;

		*outlen += fread(buf+*outlen, 1, bufsize-*outlen, fp);

		if (*outlen < bufsize)
			return newbuf;
	}
}

int main(int argc, char **argv) {
	if (argc < 3)
		errx(2, "need two filenames");

	FILE *fh1 = fopen(argv[1], "rb");
	if (fh1 == 0)
		err(1, "%s", argv[1]);
	FILE *fh2 = fopen(argv[2], "rb");
	if (fh2 == 0)
		err(1, "%s", argv[2]);

	size_t len1, len2;
	char *buf1 = slurpfile(&len1, fh1);
	char *buf2 = slurpfile(&len2, fh2);

	fwrite("PATCH", 1, 5, stdout);

	size_t front = 0, grace = 0;
	for (size_t j = 0; j <= len2; j++) {
		int need_emit = 0;
		if (j >= len2) {
			need_emit = grace > 0;
			grace++;
		}
		else {
			if (j < len1 && buf1[j] == buf2[j]) {
				if (grace > 0)
					grace++;
			}
			else {
				if (grace == 0) {
					front = j;
					if (front == 0x454f46)
						front--;
				}
				grace = 1;
			}

			need_emit = grace > 5 || (grace && j-grace+2-front >= 0xffff);
		}

		if (need_emit) {
			size_t end = j - (grace-2);
			size_t len = end - front;
			grace = 0;

			fputc(front >> 16, stdout);
			fputc(front >> 8, stdout);
			fputc(front, stdout);

			fputc(len >> 8, stdout);
			fputc(len, stdout);

			fwrite(buf2+front, 1, len, stdout);

			fprintf(stderr, "%zx~%zx -", front, end-1);
			for (size_t k = front; k < end; k++) {
				if (k < len1)
					fprintf(stderr, " %02x", (uint8_t)buf1[k]);
				else {
					fprintf(stderr, " (eof)");
					break;
				}
			}
			fprintf(stderr, ". [@%zx]\n", j);

			fprintf(stderr, "%zx~%zx +", front, end-1);
			for (size_t k = front; k < end; k++)
				fprintf(stderr, " %02x", (uint8_t)buf2[k]);
			fprintf(stderr, " (%zu).\n", len);
		}
	}

	fwrite("EOF", 1, 3, stdout);
}
