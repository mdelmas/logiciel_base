/*
struct cellule_t {
  int64_t val; (%rdi)
  struct cellule_t *suiv; 8(%rdi)
};

void inverse(struct cellule_t **l)
{
  struct cellule_t *res, *suiv;
  res = NULL;
  while (*l != NULL) {
    suiv = (*l)->suiv;
    (*l)->suiv = res;
    res = *l;
    *l = suiv;
  }
  *l = res;
}
*/
  .text
  .globl inverse
  // void inverse(struct cellule_t **l)
  // l : %rdi
inverse:
  enter $16, $0
  // struct cellule_t *res : %rbp - 8
  // struct cellule_t *suiv : %rbp - 16
  // res = NULL
  movq $0, -8(%rbp)
while_inverse:
  // while_inverse (*l != NULL)
  cmpq $0, (%rdi)
  je end_while_inverse
  // *l
  movq (%rdi), %r10
  // suiv = (*l)->suiv
  movq 8(%r10), %rax
  movq %rax, -16(%rbp)
  // (*l)->suiv = res
  movq -8(%rbp), %rax
  movq %rax, 8(%r10)
  // res = *l
  movq %r10, -8(%rbp)
  // *l = suiv
  movq -16(%rbp), %rax
  movq %rax, (%rdi)
  jmp while_inverse
end_while_inverse:
  // *l = res;
  movq -8(%rbp), %rax
  movq %rax, (%rdi)
  leave
  ret

/*
struct cellule_t *decoupe(struct cellule_t *l,
struct cellule_t **l1,
struct cellule_t **l2)
{
  struct cellule_t fictif1, fictif2;
  *l1 = &fictif1;
  *l2 = &fictif2;
  while (l != NULL) {
    if (l->val % 2 == 1) {
      (*l1)->suiv = l;
      *l1 = l;
    } else {
      (*l2)->suiv = l;
      *l2 = l;
    }
    l = l->suiv;
  }
  (*l1)->suiv = NULL;
  (*l2)->suiv = NULL;
  *l1 = fictif1.suiv;
  *l2 = fictif2.suiv;
  return l;
}
*/
  .globl decoupe
  // struct cellule_t *decoupe(struct cellule_t *l, struct cellule_t **l1, struct cellule_t **l2)
  // l : %rdi
  // l1 : %rsi
  // l2 : %rdx
decoupe:
  enter $32, $0
  // struct cellule_t fictif1 : %rbp - 16
  // struct cellule_t fictif2 : %rbp - 32
  // *l1 = &fictif1
  leaq -16(%rbp), %rax
  // equivalent a :
  // movq %rbp, %rax
  // subq $16, %rax
  movq %rax, (%rsi)
  // *l2 = &fictif2
  leaq -32(%rbp), %rax
  movq %rax, (%rdx)
while:
  // while (l != NULL)
  cmpq $0, %rdi
  je end_while
if:
  // if (l->val % 2 == 1)
  // ou test + jz, shr
  movq (%rdi), %rax
  andq $1, %rax
  cmpq $1, %rax
  jne else
  // (*l1)->suiv = l
  movq (%rsi), %rax
  movq %rdi, 8(%rax)
  // *l1 = l
  movq %rdi, (%rsi)
  jmp end_if
else:
  // (*l2)->suiv = l
  movq (%rdx), %rax
  movq %rdi, 8(%rax)
  // *l2 = l;
  movq %rdi, (%rdx)
end_if:
  // l = l->suiv
  movq 8(%rdi), %rax
  movq %rax, %rdi
  jmp while
end_while:
  // (*l1)->suiv = NULL
  movq (%rsi), %rax
  movq $0, 8(%rax)
  // (*l2)->suiv = NULL;
  movq (%rdx), %rax
  movq $0, 8(%rax)
  // *l1 = fictif1.suiv
  // movq %rbp, %rax
  // subq $8, %rax
  movq -8(%rbp), %rax
  movq %rax, (%rsi)
  // *l2 = fictif2.suiv;
  // movq %rbp, %rax
  // subq $24, %rax
  movq -24(%rbp), %rax
  movq %rax, (%rdx)
  // return l
  movq %rdi, %rax
  leave
  ret
