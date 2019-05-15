#include <time.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

// fonctions a ecrire en assembleur x86_32
extern void copiemem1(uint8_t *dst, uint8_t *src, uint32_t taille);
extern void copiemem2(uint8_t *dst, uint8_t *src, uint32_t taille);
extern void copiemem3(uint8_t *dst, uint8_t *src, uint32_t taille);

// fonction de reference ecrite en C
// recopie taille octets de la zone src vers la zone dst
static void copiemem0(uint8_t *dst, uint8_t *src, uint32_t taille)
{
    for (uint32_t i = 0; i < taille; i++) {
        dst[i] = src[i];
    }
}

// fonction d'affichage du contenu d'une zone memoire
// affiche en hexadecimal les taille octets de la zone ptr
// n'affiche rien si taille > 20
static void affiche(uint8_t *ptr, uint32_t taille)
{
    if (taille <= 20) {
        printf("  => contenu de la zone : ");
        for (uint32_t i = 0; i < taille; i++) {
            printf("%02" PRIX8 " ", ptr[i]);
        }
        puts("");
    }
}

// fonction qui verifie que les zones ptr1 et ptr2 contiennent bien les taille memes octets
static void compare(uint8_t *ptr1, uint8_t *ptr2, uint32_t taille)
{
    if (0 == memcmp(ptr1, ptr2, taille)) {
        puts("  => copie OK");
    } else {
        puts("  => ERREUR lors de la copie !!!");
    }
}

// alloue la zone memoire destination
static uint8_t *init_zone(char *trace, uint32_t taille)
{
    puts(trace);
    uint8_t *dst = calloc(taille, sizeof(uint8_t)); assert(NULL != dst);
    return dst;
}

// verifie si les zones src et dst contiennent bien les memes valeurs et desalloue dst
static void verifie_zones(uint8_t *dst, uint8_t *src, uint32_t taille, clock_t debut, clock_t fin)
{
    printf("  => copie effectuee en %.2f secondes\n", ((double) fin - debut) / CLOCKS_PER_SEC);
    compare(src, dst, taille);
    affiche(dst, taille);
    free(dst);
}

int main(int argc, char *argv[]) {
    // analyse des parametres de la ligne de commande
    if (argc != 2) {
        fprintf(stderr, "usage : %s <taille de la zone memoire>\n", argv[0]);
        return 1;
    }
    uint32_t taille = atoi(argv[1]);

    // initialisation de la zone source avec des octets aleatoires
    printf("Initialisation pour %" PRIu32 " octets de memoire...\n", taille);
    srandom(time(NULL));
    uint8_t *src = malloc(taille); assert(NULL != src);
    for (uint32_t i = 0; i < taille; i++) {
        src[i] = random() % 256;
    }
    affiche(src, taille);
    clock_t debut, fin;
    uint8_t *dst;

    dst = init_zone("Fonction de reference en C...", taille);
    debut = clock();
    copiemem0(dst, src, taille);
    fin = clock();
    verifie_zones(dst, src, taille, debut, fin);

    dst = init_zone("Fonction naive en assembleur...", taille);
    debut = clock();
    copiemem1(dst, src, taille);
    fin = clock();
    verifie_zones(dst, src, taille, debut, fin);

    dst = init_zone("Fonction optimisee en assembleur...", taille);
    debut = clock();
    copiemem2(dst, src, taille);
    fin = clock();
    verifie_zones(dst, src, taille, debut, fin);

    dst = init_zone("Fonction native en assembleur...", taille);
    debut = clock();
    copiemem3(dst, src, taille);
    fin = clock();
    verifie_zones(dst, src, taille, debut, fin);

    dst = init_zone("Fonction native de la libc...", taille);
    debut = clock();
    memcpy(dst, src, taille);
    fin = clock();
    verifie_zones(dst, src, taille, debut, fin);

    free(src);
    return 0;
}
