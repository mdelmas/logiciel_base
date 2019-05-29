#include <cpu.h>
#include <inttypes.h>
#include "ecran.h"
#include "traitant.h"

// on peut s'entrainer a utiliser GDB avec ce code de base
// par exemple afficher les valeurs de x, n et res avec la commande display

// une fonction bien connue
uint32_t fact(uint32_t n)
{
    uint32_t res;
    if (n <= 1) {
        res = 1;
    } else {
        res = fact(n - 1) * n;
    }
    return res;
}

void kernel_start(void)
{
    init_traitant(32, traitant_IT_32);
    init_traitant(40, traitant_IT_40);
    demasquer_IRQ0();
    demasquer_IRQ8();
    regler_horloge();

    sti();
    efface_ecran();
    console_putbytes("hello", 5);
    // affiche_heure(0);

    regle_frequence_RTC();
    affiche_date();
    // printf("xxxxx\fabc\rde\bfgh\tijklmno\tpqrst\nuvwxyz");
    // for (int i = 0; i < 26; i++) {
    //     for (int j = 0; j < i + 1; j++) {
    //         char str[2];
    //         str[0] = i + 'a';
    //         str[1] = '\0';
    //         console_putbytes(str, 1);
    //     }
    //     console_putbytes("\n", 1);
    // }
    // defilement();
    // affiche_heure(3662);

    // on ne doit jamais sortir de kernel_start
    while (1) {
        // cette fonction arrete le processeur
        hlt();
    }
}
